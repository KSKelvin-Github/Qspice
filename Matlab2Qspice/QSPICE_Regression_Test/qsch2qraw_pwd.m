function [Qpath,step,Console]=qsch2qraw_pwd(Qpathname,Qformat,Qsimulator)
%QSCH2QRAW_PWD Convert a QSPICE schematic (.qsch) to a netlist (.cir) and run simulation (.qraw).
%   PWD (Print Working Directory) version: generated .cir and .qraw files are
%   saved in MATLAB's current working directory rather than the schematic's
%   source folder. Ideal when running schematics stored in write-protected
%   directories (e.g., C:\Program Files), though local dependencies (such as
%   .lib or .sub files) in the original directory will not be resolved.
%
%   [Qpath, step, Console] = QSCH2QRAW(Qpathname) runs a 64-bit QSPICE
%   simulation on the schematic specified by Qpathname and outputs waveform
%   data in binary .qraw format.
%
%   [Qpath, step, Console] = QSCH2QRAW(Qpathname, Qformat, Qsimulator)
%   specifies the output file format and simulator engine.
%
%   Input Arguments:
%       Qpathname  - Path to the input .qsch schematic file, specified as:
%                      * String / char vector : 'C:\path\to\circuit.qsch'
%                      * Struct               : Qpathname.qsch = 'C:\path\to\circuit.qsch'
%       Qformat    - Output .qraw file format (optional, case-insensitive):
%                      * 'binary' (default) : Binary waveform format
%                      * 'ascii'            : ASCII text waveform format
%       Qsimulator - QSPICE simulator executable (optional, case-insensitive):
%                      * 'QSPICE64' (default) : Standard 64-bit solver
%                      * 'QSPICE80'           : Extended 80-bit precision solver
%
%   Output Arguments:
%       Qpath      - Structure containing file paths for all stages:
%                      * Qpath.qsch : Input schematic file path
%                      * Qpath.cir  : Generated SPICE netlist filename (in current folder)
%                      * Qpath.qraw : Generated simulation output filename (in current folder)
%       step       - Structure containing .step sweep metadata parsed from console:
%                      * step.status    : Logical flag (true if .step sweep detected)
%                      * step.TotalStep : Total number of sweep steps (0 if none)
%                      * step.name      : Cell array of swept parameter names
%                      * step.data      : Cell array of numeric parameter value vectors
%                      * step.textstr   : Column cell array of raw .step console strings
%       Console    - Cell array of strings containing the QSPICE simulator console log.
%
%   Example:
%       [Qpath, step, Console] = qsch2qraw('C:\QSPICE\Examples\DelayedPulseTrain.qsch');
%       [Qpath, step, Console] = qsch2qraw('circuit.qsch', 'ascii', 'QSPICE80');
%
%   GitHub : https://github.com/KSKelvin-Github/Qspice
%   Last Updated : 20-Nov-2026

% =========================================================================
% 1. Handle Optional Input Arguments & Set Defaults
% =========================================================================
switch nargin
    case 2
        Qsimulator = 'QSPICE64';    % Default to 64-bit simulator if omitted
    case 1
        Qsimulator = 'QSPICE64';    % Default to 64-bit simulator if omitted
        Qformat = 'binary';         % Default to binary .qraw format if omitted
    otherwise
        % All 3 arguments (Qpathname, Qformat, Qsimulator) were provided
end
display(['qsch2qraw("',Qpathname,'","',Qformat,'","',Qsimulator,'")']);

% =========================================================================
% 2. Normalize Input Path into Qpath Structure
% =========================================================================
% Accept either a direct .qsch file path string or an existing Qpath struct
if ~isstruct(Qpathname)
    Qpath.qsch = Qpathname;
else
    Qpath = Qpathname;
end

% =========================================================================
% 3. Validate Simulator & Output Format Arguments
% =========================================================================
% Fall back to QSPICE64 if an unrecognized simulator name is given
if ~strcmpi(Qsimulator,'qspice64') & ~strcmpi(Qsimulator,'qspice80')
    display('error in qsch2qraw() : incorrect/missing simulator, force Qsimulator to QSPICE64')
    Qsimulator = 'QSPICE64';
end
% Fall back to binary format if an unrecognized file format is given
if ~strcmpi(Qformat,'binary') & ~strcmpi(Qformat,'ascii')
    display('error in qsch2qraw() : incorrect/missing format, force Qformat to BINARY')
    Qformat = 'binary';
end

% =========================================================================
% 4. Locate QSPICE Installation Directory & Verify Executables
% =========================================================================
QspicePath = []; % Stores detected QSPICE installation directory

% Check standard system-wide installation path first
if isfolder('C:\Program Files\QSPICE\')
    QspicePath = 'C:\Program Files\QSPICE\';
end
% Check current user's profile directory if not found in Program Files
if isempty(QspicePath) && isfolder([getenv('USERPROFILE'),'\QSPICE\'])
    QspicePath = [getenv('USERPROFILE'),'\QSPICE\'];
end
% Abort execution if QSPICE installation folder cannot be located
if isempty(QspicePath)
    error('qsch2qraw() error : Qspice path is not found. Check Qspice install path in qsch2qraw()')
end

% Ensure all required QSPICE CLI executables exist in the detected folder
if ~isfile([QspicePath,'QUX.exe']) | ~isfile([QspicePath,'QSPICE64.exe']) | ~isfile([QspicePath,'QSPICE80.exe'])
    error(['qsch2qraw() error : QUX.exe or QSPICE64.exe or QSPICE80.exe does not exist in ',QspicePath, ...
        'Search variable QspicePath in qsch2qraw() and change to your Qspice install path']);
end

% =========================================================================
% 5. Step 1: Export SPICE Netlist (.cir) from Schematic (.qsch) via QUX
% =========================================================================
cmdsep = '&&';                          % Windows command chaining operator
[~, baseName, ~] = fileparts(Qpath.qsch); % Extract schematic filename without folder or extension

% Build Windows CLI command: temporarily add QSPICE to PATH, then run QUX netlister
cmd_str = [
    'path ',QspicePath,...              % Temporarily set PATH to QSPICE folder
    cmdsep,...                          % Chain next command if PATH succeeds
    'QUX -Netlist "',Qpath.qsch,'"',... % Export netlist from input .qsch schematic
    ' -stdout>"',baseName,'".cir'       % Redirect stdout stream to local .cir file
    ];
display('qsch2qraw() : Qspice is generating netlist from schematic')
display(['  system command : ',char(cmd_str)])
[status,Qpath.cir] = system(cmd_str);   % Execute netlist export in OS shell
Qpath.cir = [baseName,'.cir'];          % Store generated .cir filename in Qpath struct
% Read the entire file into a character array
fileText = fileread(Qpath.cir); 
% Check if 'fastmath=0' exists (case-insensitive)
if contains(fileText, 'fastmath=0', 'IgnoreCase', true)
    Qsimulator='QSPICE80';
elseif contains(fileText, 'fastmath=1', 'IgnoreCase', true)
    Qsimulator='QSPICE64';
end

% =========================================================================
% 6. Step 2: Run SPICE Simulation (.cir -> .qraw)
% =========================================================================
% Build Windows CLI command to invoke QSPICE64 or QSPICE80 on the generated .cir file
cmd_str = [
    'path ',QspicePath,...                      % Temporarily set PATH to QSPICE folder
    cmdsep,...                                  % Chain next command
    Qsimulator,' -',Qformat,' "',baseName,'.cir','"'  % Run simulation with selected format (-binary / -ascii)
    ];
display('qsch2qraw() : Qspice Simulator is Running...')
display(['  system command : ',char(cmd_str)])
[status,cmdout] = system(cmd_str);              % Execute simulation and capture console output

% =========================================================================
% 7. Process Console Output & Finalize Output Paths
% =========================================================================
display(' ');
display('## Qspice Console Output')
if ~isempty(cmdout)
    display(char(cmdout));                          % Print raw simulator log to MATLAB Command Window
    Console = textscan(cmdout, '%s', 'delimiter', {'/n'}); % Parse console text into cell array
    Console = Console{1};
else
    % Handle silent execution failure when QSPICE returns no console text
    display('Execution error:');
    display('No console output (cmdout is empty).')
    Console = {'Execution error:';'No console output (cmdout is empty).'};
end

% Derive expected .qraw waveform filename by replacing .cir extension with .qraw
Qpath.qraw = [Qpath.cir(1:end-3),'qraw'];


% =========================================================================
% 8. Extract .step Sweep Metadata & Parameter Values from QSPICE Console Log
% =========================================================================
step.status = false;    % Flag indicating whether .step data was detected in console output
step.TotalStep = 0;     % Total number of sweep steps (0 indicates no .step lines parsed yet)
idx = 1;                % Row counter for storing raw .step text lines

% Iterate through each line of the QSPICE console output
for n = 1: length(Console)
    % Check if the current console line contains a QSPICE .step progress message
    % Example format: '1 of 54 steps:  .step ra=1000 rb=1000 rc=1000'
    if ~isempty(strfind(Console{n},'steps:  .step'))
        Console{n};             % Unassigned reference to current console line
        step.status = true;     % Mark that .step sweep information is present

        % On the first .step line encountered, build the dynamic textscan format string
        if ~step.TotalStep
            str = [];
            paramNo = length(find(Console{1}=='='));    % Count '=' characters to determine number of swept parameters
            for m = 1: paramNo
                str = [str '%s%f'];                     % Append a [param_name, param_value] pair to the format spec
            end
        end

        % Capture the raw parameter assignment substring following '.step'
        C=textscan(Console{n},'%fof%fsteps:  .step%s','delimiter','');
        step.textstr{idx} = char(C{3});                 % Store raw .step text for reference/display
        idx=idx+1;

        % Parse step index, total steps, and all parameter name/value pairs
        % Example input: '1 of 54 steps:  .step ra=1000 rb=1000 rc=1000'
        C=textscan(Console{n},['%fof%fsteps:  .step',str],'delimiter','=');
        % Parsed cell array layout:
        %   C{1}               : Current step index (e.g., 1)
        %   C{2}               : Total number of steps (e.g., 54)
        %   C{3}, C{5}, C{7}.. : Parameter names (e.g., 'ra', 'rb', 'rc')
        %   C{4}, C{6}, C{8}.. : Numeric parameter values (e.g., 1000, 1000, 1000)

        % On the first .step line, initialize total step count and record parameter names
        if ~step.TotalStep
            step.TotalStep = C{2};                      % Store total number of sweep steps
            for m = 1: paramNo
                step.name{m} = char(C{(m-1)*2+3});     % Extract and store each swept parameter name
            end
        end

        % Store each parameter's numeric value at the index corresponding to the current step ID (C{1})
        for m = 1: paramNo
            step.data{m}(C{1}) = C{(m-1)*2+4};
        end

        % Once the final step is reached, transpose textstr into a column cell array for cleaner display
        if step.TotalStep == C{1}
            step.textstr = step.textstr';
        end
    end
end

end