function out = mUniversal(in, param, Ts, rst, t) %#codegen
%MUNIVERSAL Universal 8-in / 8-out / 8-param discrete-time MATLAB function
%   for QSPICE TcpUniversal TCP co-simulation.
%
%   out = MUNIVERSAL(in, param, Ts, rst, t)
%
%   Input Arguments:
%       in    - 1x8 double vector of QSPICE block inputs  [in1 .. in8]
%       param - 1x8 double vector of QSPICE parameters    [TcpParam1 .. TcpParam8]
%       Ts    - Discrete sampling period (s)
%       rst   - Synchronous reset flag (> 0.5 resets all persistent states to 0)
%       t     - Current QSPICE simulation time (s)
%
%   Output Arguments:
%       out   - 1x8 double vector of QSPICE block outputs [out1 .. out8]
%
%   Persistent States:
%       s1 .. s8 retain internal memory across consecutive sample periods Ts.
%       All 8 states are automatically zeroed on the first step of each
%       QSPICE run (rst > 0.5) and whenever the MATLAB server accepts a new
%       TCP connection (via 'clear mUniversal').

% =========================================================================
% 1. Persistent State Variables (8 States)
% =========================================================================
persistent s1 s2 s3 s4 s5 s6 s7 s8

if isempty(s1) || rst > 0.5
    s1 = 0.0;
    s2 = 0.0;
    s3 = 0.0;
    s4 = 0.0;
    s5 = 0.0;
    s6 = 0.0;
    s7 = 0.0;
    s8 = 0.0;
end

% =========================================================================
% 2. Unpack 8 Inputs & 8 Parameters (Optional Convenience Aliases)
% =========================================================================
in1 = in(1);  in2 = in(2);  in3 = in(3);  in4 = in(4);
in5 = in(5);  in6 = in(6);  in7 = in(7);  in8 = in(8);

p1 = param(1);  p2 = param(2);  p3 = param(3);  p4 = param(4);
p5 = param(5);  p6 = param(6);  p7 = param(7);  p8 = param(8);

% =========================================================================
% 3. User Algorithm (Replace with your custom discrete-time logic)
% =========================================================================
% Default example: Forward-Euler PI controller on channel 1
%   in1 -> error signal, p1 -> kp, p2 -> ki, s1 -> integrator state, out1 -> u
s1   = s1 + p2 * Ts * in1;
out1 = p1 * in1 + s1*1;

% Unused channels default to 0.0 (assign as needed)
out2 = 0.0;
out3 = 0.0;
out4 = 0.0;
out5 = 0.0;
out6 = 0.0;
out7 = 0.0;
out8 = 0.0;

% =========================================================================
% 4. Pack 8 Outputs
% =========================================================================
out = [out1, out2, out3, out4, out5, out6, out7, out8];
end
