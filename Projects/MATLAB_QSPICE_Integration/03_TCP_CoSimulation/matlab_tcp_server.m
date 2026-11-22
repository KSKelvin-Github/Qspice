% =========================================================================
% MATLAB TCP Co-Simulation Server for QSPICE (Berkeley Socket API)
% =========================================================================
% Description:
%   Runs a persistent local TCP server on 127.0.0.1:55000 that communicates
%   with QSPICE's built-in Berkeley Socket API C-Block (pi_block.cpp).
%   Executes pi_controller.m natively in MATLAB without requiring MATLAB
%   Coder or Simulink Coder.
%
%   The server stays active across multiple QSPICE simulation runs and
%   automatically resets pi_controller's persistent state upon each new
%   connection (as well as honoring the rst flag sent by QSPICE).
%
% Binary Protocol (Little-Endian):
%   Receive from QSPICE (52 bytes):
%     - 4 bytes  (int32)  : Command code (PORT_EVALUATE = 2)
%     - 48 bytes (6x f64) : [t, err, kp, ki, Ts, rst]
%   Send to QSPICE (8 bytes):
%     - 8 bytes  (1x f64) : [u] (computed PI controller output)
%
% Usage:
%   1. Run this script in MATLAB first (keep it running in the background).
%   2. Open and run my_circuit.qsch in QSPICE.
%   3. Press Ctrl+C in the MATLAB Command Window to stop the server.
%
% Last Updated : 22-Nov-2026
% =========================================================================

% Clear command window and workspace variables
clc; clear;

% =========================================================================
% 1. Server Configuration & Initialization
% =========================================================================
PORT_EVALUATE = int32(2);
host       = "127.0.0.1";
port       = 55000;
verbose    = true; % Set to false to disable console printing completely
printEvery = 5;   % Print console update every N received packets

% Create TCP server object listening for incoming QSPICE connections
server = tcpserver(host, port, "Timeout", 30);
fprintf("MATLAB TCP Server running on %s:%d (Press Ctrl+C to stop).\n", host, port);

% =========================================================================
% 2. Persistent Co-Simulation Loop (Handles Repeated QSPICE Runs)
% =========================================================================
while true
    % Wait until QSPICE opens a socket connection at the start of a run
    fprintf("\nWaiting for QSPICE simulation...\n");
    while ~server.Connected
        pause(0.05);
    end

    % Reset persistent state as an extra safeguard on every new connection
    clear pi_controller;
    fprintf("QSPICE connected! Co-simulation running...\n");

    % Print formatted table header for console logging
    if verbose
        fprintf("\n%5s | %8s | %9s | %6s | %6s | %6s | %3s | %9s\n", ...
            "Step", "t (s)", "err", "kp", "ki", "Ts", "rst", "u (out)");
        fprintf("%s\n", repmat('-', 1, 70));
    end

    stepCount = 0;
    try
        % Process incoming evaluation packets while QSPICE remains connected
        while server.Connected
            % Wait until a complete 52-byte packet (4-byte cmd + 6 doubles) arrives
            if server.NumBytesAvailable >= 52
                cmd = read(server, 1, "int32");
                rx  = read(server, 6, "double"); % [t, err, kp, ki, Ts, rst]

                if cmd == PORT_EVALUATE
                    % Unpack simulation time, error, controller parameters, and reset flag
                    t   = rx(1);
                    err = rx(2);
                    kp  = rx(3);
                    ki  = rx(4);
                    Ts  = rx(5);
                    rst = rx(6);

                    % Compute one discrete PI step in MATLAB and send u back to QSPICE
                    u = pi_controller(err, kp, ki, Ts, rst);
                    write(server, double(u), "double");
                    stepCount = stepCount + 1;

                    % Print first step (to verify rst=1) and every Nth step thereafter
                    if verbose && (stepCount == 1 || mod(stepCount, printEvery) == 0)
                        fprintf("%5d | %8.4f | %9.4f | %6.2f | %6.2f | %6.3f | %3.0f | %9.4f\n", ...
                            stepCount, t, err, kp, ki, Ts, rst, u);
                    end
                end
            end
        end
    catch
        % QSPICE closed the socket at the end of the simulation
    end

    % Report total steps exchanged and loop back to wait for the next QSPICE run
    fprintf("Simulation finished (%d steps). Ready for next run.\n", stepCount);
end