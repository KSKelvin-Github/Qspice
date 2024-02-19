function [Qpath]=qsch2qraw(Qpathname,Qformat,Qsimulator)
%qsch2qraw    Qspice from schematic (.qsch) to output data (.qraw)
%   [Qpath]=qsch2qraw(Qpathname,Qformat,Qsimulator)
%       Qpathname : full path and filename of .qsch
%       Qformat : binary (default) | ascii
%       Qsimulator : QSPICE64 (default) | QSPICE80
%       [Qpath] : return path of .qsch, .cir, .qraw
%
%**Important Note
%   If Qspice is not installed into C:\Program Files\QSPICE\
%   Search variable QspicePath and change to your Qspice install path
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 20-Feb-2024 12:30pm

% Input arguments assignment
switch nargin
    case 2
        Qsimulator = 'QSPICE64';    % default 64bits Simulator
    case 1
        Qsimulator = 'QSPICE64';    % default 64bits Simulator
        Qformat = 'binary';         % default binary file format
    otherwise
end
Qpath.qsch = Qpathname;

% verify input arguments
if ~strcmpi(Qsimulator,'qspice64') & ~strcmpi(Qsimulator,'qspice80')
    display('error in qsch2qraw() : incorrect/missing simulator, force Qsimulator to QSPICE64')
    Qsimulator = 'QSPICE64';
end
if ~strcmpi(Qformat,'binary') & ~strcmpi(Qformat,'ascii')
    display('error in qsch2qraw() : incorrect/missing format, force Qformat to BINARY')
    Qformat = 'binary';
end

% Qspice Path and Windows Command Separator
QspicePath = 'C:\Program Files\QSPICE\';    % Depends on Installation Path
% verify Qspice path contains QUX.exe, QSPICE64.exe and QSPICE80.exe
if ~isfile([QspicePath,'QUX.exe']) | ~isfile([QspicePath,'QSPICE64.exe']) | ~isfile([QspicePath,'QSPICE80.exe'])
    display(['qsch2qraw() error : QUX.exe or QSPICE64.exe or QSPICE80.exe does not exist in ',QspicePath]);
    display(['  Location variable QspicePath in qsch2qraw() to confirm Qspice Installation Path'])
    return;
end
% Windows command separator
if ~exist('cmdsep')     % before Matlab 2023b
    cmdsep = '&&';      % windows command separator
end

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

end