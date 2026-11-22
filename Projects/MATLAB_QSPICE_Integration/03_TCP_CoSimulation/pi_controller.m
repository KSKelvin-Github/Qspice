function u = pi_controller(err, kp, ki, Ts, rst) %#codegen
%PI_CONTROLLER Discrete-time Forward-Euler PI controller with synchronous reset.
%   u = PI_CONTROLLER(err, kp, ki, Ts, rst) computes one discrete-time step of
%   a proportional-integral (PI) controller using Forward-Euler integration.
%   Compatible with MATLAB Coder (%#codegen) for C code generation and
%   integration into QSPICE C-Blocks.
%
%   Input Arguments:
%       err - Control error signal (setpoint minus feedback)
%       kp  - Proportional gain
%       ki  - Integral gain
%       Ts  - Discrete sampling period (s)
%       rst - Reset control flag (> 0.5 resets integrator state to 0.0)
%
%   Output Arguments:
%       u   - Computed controller output command
%
%   Notes:
%       * Persistent state 'integ_state' retains the accumulated integral
%         across consecutive calls.
%       * When wrapping in a QSPICE C-Block, gate calls using '*ForKeeps'
%         and/or a sample clock edge so integration occurs once per sample
%         period Ts rather than on every Newton-Raphson iteration.
%
%   Last Updated : 22-Nov-2026

% Declare persistent variable to retain integrator memory across function calls
persistent integ_state

% Initialize or synchronously reset the integrator state when rst > 0.5
if isempty(integ_state) || rst > 0.5
    integ_state = 0.0;
end

% Accumulate integral term using Forward-Euler discrete integration
integ_state = integ_state + ki * Ts * err;

% Sum proportional and integral terms to compute controller output
u = kp * err + integ_state;
end