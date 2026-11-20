% =========================================================================
% MATLAB-to-QSPICE Regression Test Script (User-Selected Files)
% =========================================================================
% Description:
%   Prompts the user to select one or more QSPICE schematic files (.qsch)
%   from a directory and runs each selected schematic through QSPICE
%   (netlist generation + simulation).
%
%   - Automatically selects qsch2qraw() for standard writable folders and
%     qsch2qraw_pwd() for write-protected directories under C:\Program Files\.
%   - Cleans up temporary .cir and .qraw files after each run.
%   - Tracks and reports schematics that encounter execution errors or fail
%     to return a 'Total elapsed time:' completion message.
%
% Dependencies:
%   qsch2qraw.m, qsch2qraw_pwd.m
%
% GitHub       : https://github.com/KSKelvin-Github/Qspice
% Last Updated : 20-Nov-2026
% =========================================================================

% Clear Command Window, close all figure windows, and reset workspace variables
clc; close all; clear all;

% =========================================================================
% 1. Select Target .qsch Schematic File(s)
% =========================================================================
default_path = 'C:\Program Files\QSPICE\Examples'; % Default starting directory for file dialog

% Prompt user to select one or more .qsch files
[filename, filepath] = uigetfile([default_path, '\*.qsch'], 'Select QSPICE Schematic(s) for Regression', 'MultiSelect', 'on');

% Abort script if user clicks Cancel
if isequal(filename, 0)
    disp('File selection canceled.');
    return;
end

% Ensure filename is a cell array even when only a single file is selected
if ischar(filename)
    filename = {filename};
end

% =========================================================================
% 2. Execute Batch QSPICE Simulations & Track Errors
% =========================================================================
idxErr = 1;           % Counter for schematics returning an execution error
idxNoElapsedTime = 1; % Counter for schematics missing 'Total elapsed time:' in console log

% Iterate through every selected .qsch file
for idx = 1:length(filename)
    full_qsch_path = fullfile(filepath, filename{idx}); % Full absolute path to the schematic

    % Display batch progress in Command Window
    fprintf('\n[%d/%d] Processing: %s\n', idx, length(filename), full_qsch_path);

    % Route simulation based on whether the source folder is write-protected
    if ~startsWith(filepath, 'C:\Program Files\', 'IgnoreCase', true)
        % Writable directory: generate .cir and .qraw alongside the .qsch file
        [Qpath, ~, Console] = qsch2qraw(full_qsch_path);
    else
        % Write-protected directory: generate .cir and .qraw in MATLAB's current working directory
        [Qpath, ~, Console] = qsch2qraw_pwd(full_qsch_path);
    end

    % Clean up temporary .cir and .qraw output files if they were generated
    if isfile(Qpath.cir)
        delete(Qpath.cir);
    end
    if isfile(Qpath.qraw)
        delete(Qpath.qraw);
    end

    % Check for silent execution failure (empty console output flagged by qsch2qraw)
    if strcmp(Console{1}, 'Execution error:')
        error_fname{idxErr} = filename{idx}; % Store filename for summary report
        idxErr = idxErr + 1;
    end

    % Check if simulation completed normally by verifying the final elapsed time line
    if ~startsWith(Console{end}, 'Total elapsed time:')
        NoElapsedTime_fname{idxNoElapsedTime} = filename{idx}; % Store filename for summary report
        idxNoElapsedTime = idxNoElapsedTime + 1;
    end
end

% =========================================================================
% 3. Display Regression Test Summary Report
% =========================================================================
disp(' ')
disp('*** Regression Test Summary Report ****')
disp(['Directory tested        : ', filepath])
disp(['Total .qsch files tested: ', num2str(length(filename))])

% Report schematics that failed to execute
if exist('error_fname', 'var')
    disp('Filename(s) return a system error because they are not executable:')
    for n = 1:length(error_fname)
        disp(['  ', error_fname{n}]);
    end
else
    disp('No execution errors occurred.')
end

% Report schematics that did not conclude with a 'Total elapsed time:' message
if exist('NoElapsedTime_fname', 'var')
    disp('Filename(s) without Total elapsed time returned:')
    disp('  [These files may be hierarchical/subcircuit blocks or encountered a fatal error.]')
    for n = 1:length(NoElapsedTime_fname)
        disp(['  ', NoElapsedTime_fname{n}]);
    end
end