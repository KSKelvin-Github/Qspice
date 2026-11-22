% =========================================================================
% MATLAB High-Speed TCP Co-Simulation Server for QSPICE (Java ServerSocket)
% =========================================================================
% Description:
%   Runs a persistent local TCP server on 127.0.0.1:55000 using MATLAB's
%   built-in java.net.ServerSocket with TCP_NODELAY enabled to eliminate
%   MATLAB tcpserver asyncio overhead and Nagle's algorithm delay.
%
%   Executes pi_controller.m natively in MATLAB without requiring MATLAB
%   Coder, Simulink Coder, or any extra toolboxes.
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
% =========================================================================

clc; clear;
import java.net.*
import java.io.*

% =========================================================================
% 1. Server Configuration & Initialization
% =========================================================================
PORT_EVALUATE = int32(2);
host       = '127.0.0.1';
port       = 55000;
verbose    = true; % Set to false for maximum speed (disables console printing)
printEvery = 10;   % Print console update every N received packets

% Create Java ServerSocket bound to localhost:55000
serverSocket = ServerSocket();
serverSocket.setReuseAddress(true);
serverSocket.bind(InetSocketAddress(host, port));
serverSocket.setSoTimeout(500); % 500 ms accept timeout so Ctrl+C stays responsive

% Automatically release port 55000 when script is stopped with Ctrl+C
cleanupServer = onCleanup(@() serverSocket.close());
fprintf('MATLAB Java TCP Server running on %s:%d (Press Ctrl+C to stop).\n', host, port);

% =========================================================================
% 2. Persistent Co-Simulation Loop (Handles Repeated QSPICE Runs)
% =========================================================================
while true
    fprintf('\nWaiting for QSPICE simulation... (Ctrl+C to terminate)\n');
    clientSocket = [];
    while isempty(clientSocket)
        try
            clientSocket = serverSocket.accept();
        catch
            % accept() timed out after 500 ms; pause briefly so Ctrl+C is processed
            pause(0.01);
        end
    end

    % Disable Nagle's algorithm for immediate 8-byte reply transmission
    clientSocket.setTcpNoDelay(true);
    din  = DataInputStream(BufferedInputStream(clientSocket.getInputStream()));
    dout = DataOutputStream(clientSocket.getOutputStream());

    % Reset persistent state as an extra safeguard on every new connection
    clear pi_controller;
    fprintf('QSPICE connected! Co-simulation running...\n');

    if verbose
        fprintf('\n%5s | %8s | %9s | %6s | %6s | %6s | %3s | %9s\n', ...
            'Step', 't (s)', 'err', 'kp', 'ki', 'Ts', 'rst', 'u (out)');
        fprintf('%s\n', repmat('-', 1, 70));
    end

    stepCount = 0;
    rawInts   = zeros(1, 12, 'int32');
    tStart    = tic;

    try
        while true
            % Read 4-byte command + 12x 4-byte ints (52 bytes total)
            % 32-bit ints convert losslessly across the MATLAB-Java bridge
            cmd = swapbytes(int32(din.readInt()));
            for k = 1:12
                rawInts(k) = int32(din.readInt());
            end
            rx = typecast(swapbytes(rawInts), 'double'); % [t, err, kp, ki, Ts, rst]

            if cmd == PORT_EVALUATE
                t   = rx(1);
                err = rx(2);
                kp  = rx(3);
                ki  = rx(4);
                Ts  = rx(5);
                rst = rx(6);

                % Compute one discrete PI step in MATLAB and flush 8-byte reply
                u = pi_controller(err, kp, ki, Ts, rst);
                dout.write(typecast(double(u), 'int8'));
                dout.flush();
                stepCount = stepCount + 1;

                if verbose && (stepCount == 1 || mod(stepCount, printEvery) == 0)
                    fprintf('%5d | %8.4f | %9.4f | %6.2f | %6.2f | %6.3f | %3.0f | %9.4f\n', ...
                        stepCount, t, err, kp, ki, Ts, rst, u);
                end
            end
        end
    catch
        % QSPICE closed the socket at the end of the simulation
    end

    elapsed = toc(tStart);
    clientSocket.close();
    fprintf('Simulation finished (%d steps in %.3f s -> %.2f ms/step). Resetting server...\n', ...
        stepCount, elapsed, (elapsed / max(stepCount, 1)) * 1000);
end