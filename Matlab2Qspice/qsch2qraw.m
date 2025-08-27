function [Qpath,step,Console]=qsch2qraw(Qpathname,Qformat,Qsimulator)
%qsch2qraw    Qspice from schematic (.qsch) to output data (.qraw)
%   [Qpath,Console]=qsch2qraw(Qpathname,Qformat,Qsimulator)
%       Qpathname : full path and filename of .qsch
%           format #1 : Qpathname = [filepath filename]
%           format #2 : Qpathname.qsch = [filepath filename]
%       Qformat : binary (default) | ascii
%       Qsimulator : QSPICE64 (default) | QSPICE80
%       [Qpath] : return path of .qsch, .cir, .qraw
%       [step] : return step information from console
%           step.status : .step is available of not : true / false
%           step.TotalStep : total step number
%           step.name : param name
%           step.data : param data
%           step.textstr : .step string
%       [Console] : return console text
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 23-Feb-2024

% Input arguments assignment
switch nargin
    case 2
        Qsimulator = 'QSPICE64';    % default 64bits Simulator
    case 1
        Qsimulator = 'QSPICE64';    % default 64bits Simulator
        Qformat = 'binary';         % default binary file format
    otherwise
end

% Check Qpath format : assign Qpathname to Qpath.qsch
if ~isstruct(Qpathname)
    Qpath.qsch = Qpathname;
else
    Qpath = Qpathname;
end

% verify input arguments
if ~strcmpi(Qsimulator,'qspice64') & ~strcmpi(Qsimulator,'qspice80')
    display('error in qsch2qraw() : incorrect/missing simulator, force Qsimulator to QSPICE64')
    Qsimulator = 'QSPICE64';
end
if ~strcmpi(Qformat,'binary') & ~strcmpi(Qformat,'ascii')
    display('error in qsch2qraw() : incorrect/missing format, force Qformat to BINARY')
    Qformat = 'binary';
end

% find Qspice path
QspicePath = []; % Depends on Installation Path
if isfolder('C:\Program Files\QSPICE\')
    QspicePath = 'C:\Program Files\QSPICE\';
end
if isempty(QspicePath) && isfolder([getenv('USERPROFILE'),'\QSPICE\'])
    QspicePath = [getenv('USERPROFILE'),'\QSPICE\'];
end
if isempty(QspicePath)
    error('qsch2qraw() error : Qspice path is not found. Check Qspice install path in qsch2qraw()')
end

% verify Qspice path contains QUX.exe, QSPICE64.exe and QSPICE80.exe
if ~isfile([QspicePath,'QUX.exe']) | ~isfile([QspicePath,'QSPICE64.exe']) | ~isfile([QspicePath,'QSPICE80.exe'])
    error(['qsch2qraw() error : QUX.exe or QSPICE64.exe or QSPICE80.exe does not exist in ',QspicePath, ...
        'Search variable QspicePath in qsch2qraw() and change to your Qspice install path']);
end
% Windows command separator
if ~exist('cmdsep')     % before Matlab 2023b
    cmdsep = '&&';      % windows command separator
end
cmdsep = '&&';

% system command : QUX -Netlist : Generate .cir from .qsch
cmd_str = [
    'path ',QspicePath,...              % path C:\Program Files\QSPICE\
    cmdsep,...                          % command seqparator '&&'
    'QUX -Netlist "',Qpath.qsch,'"'     % e.g. QUX -Netlist "C:\....\*.qsch"
    ];
display('qsch2qraw() : Qspice is generating netlist from schematic')
display(['  system command : ',char(cmd_str)])
[status,Qpath.cir] = system(cmd_str);   % execute operating system command

% system command : QSPICE64 or QSPICE80 : Generate .qraw from .cir
cmd_str = [
    'path ',QspicePath,...                      % path C:\Program Files\QSPICE\
    cmdsep,...                                  % command seqparator '&&'
    Qsimulator,' -',Qformat,' "',Qpath.cir,'"'  % e.g. Qspice64 -binary "C:\....\*.cir"
    ];
display('qsch2qraw() : Qspice Simulator is Running...')
display(['  system command : ',char(cmd_str)])
[status,cmdout] = system(cmd_str);              % execute operating system command
display(' ');
display('## Qspice Console Output')
display(char(cmdout));                          % print console output in command window
Qpath.qraw = [Qpath.cir(1:end-3),'qraw'];
Console = textscan(cmdout, '%s', 'delimiter', {'/n'});
Console = Console{1};

% extract .step information from Console output into [step]
step.status = false;
step.TotalStep = 0;   % assume no step information
idx = 1;
for n = 1: length(Console)                              % processing console output
    if ~isempty(strfind(Console{n},'steps:  .step'))	% .step is found
        Console{n}
        step.status = true;
        % if first time find a .step, identify number of param and prepare
        % format of textscan based on number of param
        if ~step.TotalStep
            str = [];
            paramNo = length(find(Console{1}=='='));    % identify number of param by number of '='
            for m = 1: paramNo
                str = [str '%s%f'];                     % for textscan based on number of param
            end
        end

        % get text str only
        C=textscan(Console{n},'%fof%fsteps:  .step%s','delimiter','');
        step.textstr{idx} = char(C{3});
        idx=idx+1;

        % processing each .step statement
        % e.g. '1 of 54 steps:  .step ra=1000 rb=1000 rc=1000'
        C=textscan(Console{n},['%fof%fsteps:  .step',str],'delimiter','=');
        % C{1} : step ID
        % C{2} : Total number of step
        % C{3},C{5},C{7},... : param name
        % C{4},C{6},C{8},... : param value

        % if first time find a .step
        if ~step.TotalStep
            step.TotalStep = C{2};                     % Total number of step
            for m = 1: paramNo
                step.name{m} = char(C{(m-1)*2+3});    % param name
            end
        end
        for m = 1: paramNo
            step.data{m}(C{1}) = C{(m-1)*2+4};         % param data
        end

        % if last .step
        if step.TotalStep == C{1}
            step.textstr = step.textstr';               % rotate for display purpose only
        end
    end
end

end