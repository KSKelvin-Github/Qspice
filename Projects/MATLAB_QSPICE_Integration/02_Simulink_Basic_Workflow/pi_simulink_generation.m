% =========================================================================
% Simulink Model Builder & Standalone C Code Generator for QSPICE
% =========================================================================
% Description:
%   Programmatically constructs a discrete-time Forward-Euler PI controller
%   in Simulink (pi_simulink.slx), configures Simulink Coder / Embedded
%   Coder for standalone C89/C90 code generation, and packages the output
%   into the 'qspice_bundle' subfolder for QSPICE C-Block compilation.
%
%   - Creates top-level Inports (err, kp, ki, Ts, rst) and Outport (u).
%   - Uses a unit-gain Discrete-Time Integrator scaled externally by (ki*Ts)
%     so gains and sample period can be tuned dynamically from QSPICE pins.
%   - Automatically selects Embedded Coder (ert.tlc) if licensed, falling
%     back to Simulink Coder (grt.tlc) with MAT-file logging disabled.
%   - Extracts packNGo archive into 'qspice_bundle\' and cleans up build files.
%
% GitHub       : https://github.com/KSKelvin-Github/Qspice
% Last Updated : 22-Nov-2026
% =========================================================================

clc; close all; clear;

modelName = 'pi_simulink';
zipFile   = fullfile(pwd, 'qspice_bundle.zip');
outFolder = fullfile(pwd, 'qspice_bundle');

% =========================================================================
% 1. Create & Populate Simulink Model (pi_simulink.slx)
% =========================================================================
% Close and delete any existing model with the same name in memory/disk
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
if isfile([modelName, '.slx'])
    delete([modelName, '.slx']);
end

new_system(modelName);
open_system(modelName);

% --- Add Top-Level Input Ports (Ports 1 to 5) ---
inNames = {'err', 'kp', 'ki', 'Ts', 'rst'};
for k = 1:length(inNames)
    blkPath = [modelName, '/', inNames{k}];
    add_block('simulink/Sources/In1', blkPath, ...
        'Position', [40, 40 + (k-1)*60, 70, 54 + (k-1)*60], ...
        'OutDataTypeStr', 'double', ...
        'PortDimensions', '1');
end

% --- Add Math & Discrete Integrator Blocks ---
% Proportional path: P = kp * err
add_block('simulink/Math Operations/Product', [modelName, '/Prod_P'], ...
    'Position', [220, 42, 250, 73]);

% Integral input: ki * err (Simulink's Discrete-Time Integrator multiplies by Ts automatically)
add_block('simulink/Math Operations/Product', [modelName, '/Prod_I'], ...
    'Inputs', '2', ...
    'Position', [220, 145, 250, 185]);

% Terminate unused Ts port (Ts is governed by the fixed-step sample time 0.1s)
add_block('simulink/Sinks/Terminator', [modelName, '/Term_Ts'], ...
    'Position', [130, 220, 150, 240]);

% Discrete-Time Integrator (Backward Euler updates state on current step before output,
% matching: integ_state = integ_state + ki*Ts*err; u = kp*err + integ_state)
add_block('simulink/Discrete/Discrete-Time Integrator', [modelName, '/Integrator'], ...
    'IntegratorMethod', 'Integration: Backward Euler', ...
    'gainval', '1.0', ...
    'ExternalReset', 'level', ...
    'InitialConditionSource', 'internal', ...
    'InitialCondition', '0', ...
    'SampleTime', '-1', ...
    'Position', [320, 160, 365, 200]);

% Output Summation: u = P + I
add_block('simulink/Math Operations/Add', [modelName, '/Sum_PI'], ...
    'Position', [440, 80, 470, 110]);

% --- Add Top-Level Output Port (Port 1) ---
add_block('simulink/Sinks/Out1', [modelName, '/u'], ...
    'Position', [530, 88, 560, 102]);

% --- Wire Signals Between Blocks ---
add_line(modelName, 'err/1', 'Prod_P/1', 'autorouting', 'on');
add_line(modelName, 'kp/1',  'Prod_P/2', 'autorouting', 'on');

add_line(modelName, 'err/1',        'Prod_I/1',     'autorouting', 'on');
add_line(modelName, 'ki/1',         'Prod_I/2',     'autorouting', 'on');
add_line(modelName, 'Ts/1',         'Term_Ts/1',    'autorouting', 'on');
add_line(modelName, 'Prod_I/1',     'Integrator/1', 'autorouting', 'on');
add_line(modelName, 'rst/1',        'Integrator/2', 'autorouting', 'on');

add_line(modelName, 'Prod_P/1',     'Sum_PI/1',     'autorouting', 'on');
add_line(modelName, 'Integrator/1', 'Sum_PI/2',     'autorouting', 'on');
add_line(modelName, 'Sum_PI/1',     'u/1',          'autorouting', 'on');

% =========================================================================
% 2. Configure Solver & C Code Generation Settings
% =========================================================================
% Fixed-step discrete solver (required for standalone C code generation)
set_param(modelName, 'SolverType', 'Fixed-step');
set_param(modelName, 'Solver', 'FixedStepDiscrete');
set_param(modelName, 'FixedStep', '0.1');

% Select Embedded Coder (ert.tlc) if available; otherwise use Simulink Coder (grt.tlc)
if license('test', 'RTW_Embedded_Coder')
    set_param(modelName, 'SystemTargetFile', 'ert.tlc');
else
    set_param(modelName, 'SystemTargetFile', 'grt.tlc');
end

% Configure C dialect and standalone source-only export for QSPICE Digital Mars
set_param(modelName, 'TargetLang', 'C');
set_param(modelName, 'TargetLangStandard', 'C89/C90 (ANSI)');
set_param(modelName, 'GenCodeOnly', 'on');              % Export .c/.h only (skip .exe build)
set_param(modelName, 'MatFileLogging', 'off');          % Disable rt_logging.c file I/O dependencies
set_param(modelName, 'GenerateReport', 'off');          % Skip HTML report generation for faster build

% Package all generated C source and header files into a flat zip archive
packCmd = sprintf('packNGo(buildInfo, {''packType'', ''flat'', ''fileName'', ''%s''});', zipFile);
set_param(modelName, 'PostCodeGenCommand', packCmd);

% Save the configured Simulink model
save_system(modelName);

% =========================================================================
% 3. Build C Code, Extract to 'qspice_bundle\', & Clean Up
% =========================================================================
slbuild(modelName);
close_system(modelName, 0);

% Remove stale 'qspice_bundle' subfolder from previous builds if present
if isfolder(outFolder)
    rmdir(outFolder, 's');
end

% Extract flat C bundle into 'qspice_bundle\' and remove temporary zip/build folders
unzip(zipFile, outFolder);
delete(zipFile);

% Remove temporary Simulink build folder (<modelName>_ert_rtw or <modelName>_grt_rtw) and slprj
rtwFolders = dir([modelName, '_*_rtw']);
for k = 1:length(rtwFolders)
    if rtwFolders(k).isdir
        rmdir(rtwFolders(k).name, 's');
    end
end
if isfolder('slprj')
    rmdir('slprj', 's');
end

% Remove Simulink cache file (<modelName>.slxc) so only clean source files remain
slxcFile = [modelName, '.slxc'];
if isfile(slxcFile)
    delete(slxcFile);
end

fprintf('Simulink C code bundle successfully extracted to: %s\n', outFolder);