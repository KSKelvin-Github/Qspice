clc; clear;
pkg load instrument-control;
page_screen_output(false);

PORT_EVALUATE = int32(2);
host       = '127.0.0.1';
port       = 55000;
verbose    = true;
printEvery = 5;

fprintf('Octave TCP Server ready on %s:%d (Press Ctrl+C to stop).\n', host, port);
fflush(stdout);

while true
    % Create a fresh server socket for each QSPICE run
    server = tcpserver(host, port, 'Timeout', 5);
    cleanupObj = onCleanup(@() clear('server'));

    fprintf('\nWaiting for QSPICE simulation... (Ctrl+C to terminate)\n');
    fflush(stdout);
    while ~server.Connected
        pause(0.05);
    end

    clear pi_controller;
    fprintf('QSPICE connected! Co-simulation running...\n');

    if verbose
        fprintf('\n%5s | %8s | %9s | %6s | %6s | %6s | %3s | %9s\n', ...
            'Step', 't (s)', 'err', 'kp', 'ki', 'Ts', 'rst', 'u (out)');
        fprintf('%s\n', repmat('-', 1, 70));
    end
    fflush(stdout);

    stepCount = 0;
    try
        while true
            % Direct read detects QSPICE disconnect (EOF) immediately
            raw = read(server, 52, 'uint8');
            if isempty(raw) || numel(raw) < 52
                break;
            end

            cmd = typecast(uint8(raw(1:4)), 'int32');
            rx  = typecast(uint8(raw(5:52)), 'double'); % [t, err, kp, ki, Ts, rst]

            if cmd == PORT_EVALUATE
                t   = rx(1);
                err = rx(2);
                kp  = rx(3);
                ki  = rx(4);
                Ts  = rx(5);
                rst = rx(6);

                u = pi_controller(err, kp, ki, Ts, rst);
                write(server, double(u), 'double');
                stepCount = stepCount + 1;

                if verbose && (stepCount == 1 || mod(stepCount, printEvery) == 0)
                    fprintf('%5d | %8.4f | %9.4f | %6.2f | %6.2f | %6.3f | %3.0f | %9.4f\n', ...
                        stepCount, t, err, kp, ki, Ts, rst, u);
                    fflush(stdout);
                end
            end
        end
    catch
        % QSPICE closed the socket at the end of the simulation
    end

    fprintf('Simulation finished (%d steps). Resetting server...\n', stepCount);
    fflush(stdout);

    % Explicitly close and release port 55000 before listening for the next run
    clear server cleanupObj;
    pause(0.1);
end
