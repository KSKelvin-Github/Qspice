function [Qpath]=cir2out(Qpathname)
%cir2out    Qspice from netlist (.cir) to post processor (.out)
%   [Qpath]=cir2out(Qpathname,Qswitch)
%       Qpathname : full path and filename of .cir
%           format #1 : Qpathname = [filepath filename]
%           format #2 : Qpathname.cir = [filepath filename]
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 23-Feb-2024

% Check Qpath format : assign Qpathname to Qpath.cir
if ~isstruct(Qpathname)
    Qpath.cir = Qpathname;
else
    Qpath = Qpathname;
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

% system command : QPOST : .out file for console output
cmd_str = [
    'path ',QspicePath,...                                  % path C:\Program Files\QSPICE\
    cmdsep,...                                              % command seqparator '&&'
    'QPOST "',Qpath.cir,'" -o "',Qpath.cir(1:end-4),'.out"' % QPOST "C:\...\*.cir" -o "C:\...\*.out"
    ];
display('cir2out() : QPOST Post Processing is Running...')
display(['  system command : ',char(cmd_str)])
[status,cmdout] = system(cmd_str);                          % execute operating system command
Qpath.out = [Qpath.cir(1:end-4),'.out'];

% system command : QPOST : Console output only
if false
    cmd_str = [
        'path ',QspicePath,...          % path C:\Program Files\QSPICE\
        cmdsep,...                      % command seqparator '&&'
        'QPOST "',Qpath.cir,'"'         % QPOST "C:\...\*.cir"
        ];
    [status,cmdout] = system(cmd_str);  % execute operating system command
    display(' ');
    display('## QPOST Console Output')
    display(char(cmdout));              % print console output in command window
end

end