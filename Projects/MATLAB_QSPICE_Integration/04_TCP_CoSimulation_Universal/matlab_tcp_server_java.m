% =========================================================================
% MATLAB High-Speed TCP Co-Simulation Server for QSPICE (Java ServerSocket)
% Universal 8-In / 8-Out / 8-Param Edition
% =========================================================================
% Description:
%   Runs a persistent local TCP server on 127.0.0.1:55000 using MATLAB's
%   built-in java.net.ServerSocket with TCP_NODELAY enabled to eliminate
%   MATLAB tcpserver asyncio overhead and Nagle's algorithm delay.
%
%   Executes mUniversal.m natively in MATLAB without requiring MATLAB
%   Coder, Simulink Coder, or any extra toolboxes.
%
% Binary Protocol (Little-Endian):
%   Receive from QSPICE (156 bytes):
%     - 4 bytes   (int32)   : Command code (PORT_EVALUATE = 2)
%     - 152 bytes (19x f64) : [t, in1..in8, TcpParam1..TcpParam8, Ts, rst]
%   Send to QSPICE (64 bytes):
%     - 64 bytes  (8x f64)  : [out1..out8]
%
% Usage:
%   1. Run this script in MATLAB first (keep it running in the background).
%   2. Open and run your QSPICE schematic containing the TcpUniversal block.
%   3. Press Ctrl+C in the MATLAB Command Window to stop the server.
% =========================================================================

clc; clear;
import java.net.*
import java.io.*

% =========================================================================
% 1. Server Configuration & Initialization
% =========================================================================
PORT_EVALUATE = int32(2);
NUM_RX_DBL    = 19; % [t, in1..in8, TcpParam1..TcpParam8, Ts, rst]
NUM_RX_INT32  = NUM_RX_DBL * 2; % 38x 32-bit ints = 152 bytes
NUM_TX_DBL    = 8;  % [out1..out8] = 64 bytes

host       = '127.0.0.1';
port       = 55000;
verbose    = true; % Set to false for maximum speed (disables console printing)
printEvery = 1;   % Print console update every N received packets

% Create Java ServerSocket bound to localhost:55000
serverSocket = ServerSocket();
serverSocket.setReuseAddress(true);
serverSocket.bind(InetSocketAddress(host, port));
serverSocket.setSoTimeout(500); % 500 ms accept timeout so Ctrl+C stays responsive

% Automatically release port 55000 when script is stopped with Ctrl+C
cleanupServer = onCleanup(@() serverSocket.close());
fprintf('MATLAB Java TCP Universal Server running on %s:%d (Press Ctrl+C to stop).\n', host, port);

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

    % Disable Nagle's algorithm for immediate 64-byte reply transmission
    clientSocket.setTcpNoDelay(true);
    din  = DataInputStream(BufferedInputStream(clientSocket.getInputStream()));
    dout = DataOutputStream(clientSocket.getOutputStream());

    % Reset persistent state as an extra safeguard on every new connection
    clear mUniversal;
    fprintf('QSPICE connected! Co-simulation running...\n');

    if verbose
        fprintf('\n%5s | %9s | %9s | %9s | %9s | %9s | %7s | %3s\n', ...
            'Step', 't (s)', 'in1', 'in2', 'out1', 'out2', 'Ts', 'rst');
        fprintf('%s\n', repmat('-', 1, 78));
    end

    stepCount = 0;
    rawInts   = zeros(1, NUM_RX_INT32, 'int32');
    tStart    = tic;

    try
        while true
            % Read 4-byte command + 38x 4-byte ints (156 bytes total)
            % 32-bit ints convert losslessly across the MATLAB-Java bridge
            cmd = swapbytes(int32(din.readInt()));
            for k = 1:NUM_RX_INT32
                rawInts(k) = int32(din.readInt());
            end
            rx = typecast(swapbytes(rawInts), 'double');

            if cmd == PORT_EVALUATE
                t        = rx(1);
                inVec    = rx(2:9);    % [in1 .. in8]
                paramVec = rx(10:17);  % [TcpParam1 .. TcpParam8]
                Ts       = rx(18);
                rst      = rx(19);

                % Compute one discrete step in MATLAB and flush 64-byte reply
                outVec = mUniversal(inVec, paramVec, Ts, rst, t);

                % Ensure exactly 8 doubles in row-vector form before transmission
                tx = zeros(1, NUM_TX_DBL);
                nOut = min(numel(outVec), NUM_TX_DBL);
                tx(1:nOut) = double(outVec(1:nOut));

                dout.write(typecast(tx, 'int8'));
                dout.flush();
                stepCount = stepCount + 1;

                if verbose && (stepCount == 1 || mod(stepCount, printEvery) == 0)
                    fprintf('%5d | %9.5f | %9.4f | %9.4f | %9.4f | %9.4f | %7.2e | %3.0f\n', ...
                        stepCount, t, inVec(1), inVec(2), tx(1), tx(2), Ts, rst);
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
