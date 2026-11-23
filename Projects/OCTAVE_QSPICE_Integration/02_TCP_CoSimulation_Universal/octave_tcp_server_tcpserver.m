% =========================================================================
% GNU Octave TCP Co-Simulation Server for QSPICE (instrument-control)
% Universal 8-In / 8-Out / 8-Param Edition
% =========================================================================
% Description:
%   Runs a persistent local TCP server on 127.0.0.1:55000 using Octave's
%   instrument-control package (tcpserver) to co-simulate with QSPICE's
%   TcpUniversal C-Block.
%
% Binary Protocol (Little-Endian):
%   Receive from QSPICE (156 bytes):
%     - 4 bytes   (int32)   : Command code (PORT_EVALUATE = 2)
%     - 152 bytes (19x f64) : [t, in1..in8, TcpParam1..TcpParam8, Ts, rst]
%   Send to QSPICE (64 bytes):
%     - 64 bytes  (8x f64)  : [out1..out8]
%
% Usage:
%   1. Ensure the instrument-control package is installed in Octave.
%   2. Run this script in Octave first (keep it running in the background).
%   3. Open and run your QSPICE schematic containing the TcpUniversal block.
%   4. Press Ctrl+C in the Octave Command Window to stop the server.
% =========================================================================

clc; clear;
pause(0.15); % Allow Windows to finish releasing port 55000 if just stopped
if ~exist('tcpserver', 'file')
    pkg load instrument-control;
end
page_screen_output(false);

% =========================================================================
% 1. Server Configuration
% =========================================================================
PORT_EVALUATE = int32(2);
RX_BYTES      = 156; % 4-byte int32 cmd + 19x 8-byte doubles
NUM_TX_DBL    = 8;   % [out1..out8] = 64 bytes

host       = '127.0.0.1';
port       = 55000;
verbose    = true; % Set to false for maximum speed (disables console printing)
printEvery = 10;   % Print console update every N received packets

fprintf('Octave TCP Universal Server ready on %s:%d (Press Ctrl+C to stop).\n', host, port);
fflush(stdout);

% =========================================================================
% 2. Persistent Co-Simulation Loop (Handles Repeated QSPICE Runs)
% =========================================================================
while true
    % Create a fresh server socket for each QSPICE run (brief retry if port is still closing)
    server = [];
    for attempt = 1:5
        try
            server = tcpserver(host, port, 'Timeout', 5);
            break;
        catch err
            if attempt == 5
                rethrow(err);
            end
            pause(0.2);
        end
    end
    cleanupObj = onCleanup(@() evalin('base', 'clear server'));

    fprintf('\nWaiting for QSPICE simulation... (Ctrl+C to terminate)\n');
    fflush(stdout);
    while ~server.Connected
        pause(0.05);
    end

    % Reset persistent state as an extra safeguard on every new connection
    clear mUniversal;
    fprintf('QSPICE connected! Co-simulation running...\n');

    if verbose
        fprintf('\n%5s | %9s | %9s | %9s | %9s | %9s | %7s | %3s\n', ...
            'Step', 't (s)', 'in1', 'in2', 'out1', 'out2', 'Ts', 'rst');
        fprintf('%s\n', repmat('-', 1, 78));
    end
    fflush(stdout);

    stepCount = 0;
    tStart    = tic;

    try
        while true
            % Direct read detects QSPICE disconnect (EOF) immediately
            raw = read(server, RX_BYTES, 'uint8');
            if isempty(raw) || numel(raw) < RX_BYTES
                break;
            end

            cmd = typecast(uint8(raw(1:4)), 'int32');
            rx  = typecast(uint8(raw(5:RX_BYTES)), 'double');

            if cmd == PORT_EVALUATE
                t        = rx(1);
                inVec    = rx(2:9);    % [in1 .. in8]
                paramVec = rx(10:17);  % [TcpParam1 .. TcpParam8]
                Ts       = rx(18);
                rst      = rx(19);

                % Compute one discrete step in Octave and send 64-byte reply
                outVec = mUniversal(inVec, paramVec, Ts, rst, t);

                % Ensure exactly 8 doubles in row-vector form before transmission
                tx = zeros(1, NUM_TX_DBL);
                nOut = min(numel(outVec), NUM_TX_DBL);
                tx(1:nOut) = double(outVec(1:nOut));

                write(server, tx, 'double');
                stepCount = stepCount + 1;

                if verbose && (stepCount == 1 || mod(stepCount, printEvery) == 0)
                    fprintf('%5d | %9.5f | %9.4f | %9.4f | %9.4f | %9.4f | %7.2e | %3.0f\n', ...
                        stepCount, t, inVec(1), inVec(2), tx(1), tx(2), Ts, rst);
                    fflush(stdout);
                end
            end
        end
    catch
        % QSPICE closed the socket at the end of the simulation
    end

    elapsed = toc(tStart);
    fprintf('Simulation finished (%d steps in %.3f s -> %.2f ms/step). Resetting server...\n', ...
        stepCount, elapsed, (elapsed / max(stepCount, 1)) * 1000);
    fflush(stdout);

    % Explicitly close and release port 55000 before listening for the next run
    clear server cleanupObj;
    pause(0.1);
end
