% this matlab is to convert LTspice A-device into Qspice ¥-device
% only support following A-device conversion
%   - AND, OR, XOR, SRFLOP, DFLOP, SCHMITT
%
% written by - KSKelvin Kelvin Leung
% last update - 9-11-2025
%
% limitation - case sensitive, instance parameter should be e.g. Ref, Vhigh, Vlow etc.

clc; close all; clear all;

% input A-device netlist
LTspice.netlist = [];
%LTspice.netlist = '';
if isempty(LTspice.netlist)
    prompt={'LTspice netlist:'};
    name='LTspice to Qspice netlist conversion (A-device)';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    LTspice.netlist = answer{1};
end

% extract LTspice netlist
C = textscan(LTspice.netlist, '%s', 'delimiter',' ');
LTspice.elements = C{1};
display(['LTspice netlist : ',LTspice.netlist]);

%%
% Device name from A to ¥
C = textscan(LTspice.elements{1}, 'A%d', 'delimiter', ' ');
Qspice.Devicename = ['¥',num2str(C{1})];
Qspice.elements{1}=Qspice.Devicename;

% Vhigh Supply Netname
idx = find(contains(LTspice.elements,'Vhigh')==1);
if(idx)
    display(' - Processing: Instance parameter Vhigh present');
    C = textscan(LTspice.elements{idx}, 'Vhigh=%f', 'delimiter', ' ');
    Qspice.Vhigh = C{1};
    if C{1}>0
        Qspice.Netname_Vhigh = ['p',num2str(abs(C{1})),'v'];
        Qspice.Voltage_Vhigh = ['VQ<n> ',Qspice.Netname_Vhigh,' 0 ',num2str(C{1})];
    elseif C{1}<0
        Qspice.Netname_Vhigh = ['n',num2str(abs(C{1})),'v'];
        Qspice.Voltage_Vhigh = ['VQ<n> ',Qspice.Netname_Vhigh,' 0 ',num2str(C{1})];
    else
        Qspice.Netname_Vhigh = ['0'];
        Qspice.Voltage_Vhigh = [];
    end
else
    Qspice.Netname_Vhigh = ['0'];
    Qspice.Voltage_Vhigh = [];
end
Qspice.elements{2}=Qspice.Netname_Vhigh;

% Vlow Supply Netname
idx = find(contains(LTspice.elements,'Vlow')==1);
if(idx)
    display(' - Processing: Instance parameter Vlow present');
    C = textscan(LTspice.elements{idx}, 'Vlow=%f', 'delimiter', ' ');
    Qspice.Vlow = C{1};
    if C{1}>0
        Qspice.Netname_Vlow = ['p',num2str(abs(C{1})),'v'];
        Qspice.Voltage_Vlow = ['VQ<n> ',Qspice.Netname_Vlow,' 0 ',num2str(C{1})];
    elseif C{1}<0
        Qspice.Netname_Vlow = ['n',num2str(abs(C{1})),'v'];
        Qspice.Voltage_Vlow = ['VQ<n> ',Qspice.Netname_Vlow,' 0 ',num2str(C{1})];
    else
        Qspice.Netname_Vlow = ['0'];
        Qspice.Voltage_Vlow = [];
    end
else
    Qspice.Netname_Vlow = ['0'];
    Qspice.Voltage_Vlow = [];
end
Qspice.elements{3}=Qspice.Netname_Vlow;

% Instance param REF
idx = find(contains(LTspice.elements,'Ref')==1);
if(idx)
    display(' - Processing: Instance parameter Vhigh present');
    C = textscan(LTspice.elements{idx}, 'Ref=%f', 'delimiter', ' ');
    LTspice.REF = C{1};
end

% preset all netname to '¥'
for n = 4: 17
    Qspice.elements{n} = '¥';
end

%%
% A-device AND
if(find(strcmp(LTspice.elements,'AND')==1))
    display(' - Processing: A-device AND is detected');
    netlistSEQ = [7 6 1 2 3 4 5];
    Qspice.Type = 'AND';
    Qspice.elements{18} = Qspice.Type;
end

% A-device OR
if(find(strcmp(LTspice.elements,'OR')==1))
    display(' - Processing: A-device OR is detected');
    netlistSEQ = [7 6 1 2 3 4 5];
    Qspice.Type = 'OR';
    Qspice.elements{18} = Qspice.Type;
end

% A-device OR
if(find(strcmp(LTspice.elements,'XOR')==1))
    display(' - Processing: A-device XOR is detected');
    netlistSEQ = [7 6 1 2 3 4 5];
    Qspice.Type = 'XOR';
    Qspice.elements{18} = Qspice.Type;
end

% A-device BUF
if(find(strcmp(LTspice.elements,'BUF')==1))
    display(' - Processing: A-device BUF is detected');
    netlistSEQ = [7 6 1];
    Qspice.Type = 'OR';
    Qspice.elements{18} = Qspice.Type;
end

% A-device SCHMITT
if(find(strcmp(LTspice.elements,'SCHMITT')==1))
    display(' - Processing: A-device SCHMITT is detected');
    netlistSEQ = [7 6 1 2];
    Qspice.Type = 'HMITT';
    Qspice.elements{18} = Qspice.Type;
    Qspice.elements{8} = Qspice.Netname_Vhigh;
end

% A-device SRFLOP
if(find(strcmp(LTspice.elements,'SRFLOP')==1))
    display(' - Processing: A-device SRFLOP is detected');
    netlistSEQ = [7 6 1 2];
    Qspice.Type = 'SR-FLOP';
    Qspice.elements{18} = Qspice.Type;
end

% A-device DFLOP
if(find(strcmp(LTspice.elements,'DFLOP')==1))
    display(' - Processing: A-device DFLOP is detected');
    netlistSEQ = [7 6 1 3 4 5];
    Qspice.Type = 'D-FLOP';
    Qspice.elements{18} = Qspice.Type;
end

%%
% assign Qspice ¥-device netname
for n = 1:length(netlistSEQ)
    if ~strcmp(LTspice.elements{netlistSEQ(n)+1},'0') | strcmp(Qspice.Type,'HMITT') | strcmp(Qspice.Type,'D-FLOP')
        Qspice.elements{n+3} = LTspice.elements{netlistSEQ(n)+1};
    else
        Qspice.elements{n+3} = '¥';
    end
    % if they are output and LTspice netname is 0, change it to ¥
    if (netlistSEQ(n)==6 | netlistSEQ(n)==7) & strcmp(LTspice.elements{netlistSEQ(n)+1},'0') 
        Qspice.elements{n+3} = '¥';
    end
end

% assign Qspice ¥-device instance parameters
for n = 11:length(LTspice.elements)
    if contains(LTspice.elements{n},'Vhigh') | contains(LTspice.elements{n},'Vlow')
        % remove Vhigh and Vlow instance parameters, as they are external net in Qspice
    elseif contains(LTspice.elements{n},'Ref')
        % REF in Qspice = REF in LTspice - Vlow
        
        idx = length(Qspice.elements);
        Qspice.elements{idx+1} = ['Ref=',num2str(LTspice.REF - Qspice.Vlow)];
    else
        idx = length(Qspice.elements);
        Qspice.elements{idx+1} = LTspice.elements{n};
    end
end

% generate Qspice netlist
Qspice.netlist = Qspice.elements{1};
for n = 2: length(Qspice.elements)
    Qspice.netlist = [Qspice.netlist,' ',Qspice.elements{n}];
end

display(' ');
display('Qspice netlist : equivalent to LTspice netlist');
display(Qspice.Voltage_Vhigh);
if(~isempty(Qspice.Voltage_Vlow))
    display(Qspice.Voltage_Vlow);
end
display(Qspice.netlist);