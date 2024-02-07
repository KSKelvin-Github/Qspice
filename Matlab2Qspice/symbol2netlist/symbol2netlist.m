%% symbol2netlist
%   convert Qspice .subckt or .model embedded symbol to netlist
%
%   author : KSKelvin (last update : 2-8-2024)
clc;
close all;
clear all;

%% read .qsym into text
[filename filepath]=uigetfile('*.qsym');
fid = fopen([filepath filename]);
C = textscan(fid, '%s', 'delimiter' ,'');
qsym.text = C{1};
fclose(fid);

%% identify line of library file
str = '«library file: |';
idx=find(strncmp(qsym.text,str,length(str))==1);
qsym.libraryfile = char(qsym.text(idx));
qsym.libraryfile = qsym.libraryfile(length(str)+1:end-1);   % remove extra character
if isempty(qsym.libraryfile)
    display(['// ',filename,' : library file content is not .subckt or .model']);
    display('// No netlist is extracted, operation terminate');
    return;
end

%% extract netlist in library file
qsym.netlist = textscan(qsym.libraryfile,'%s','delimiter',{'\\n'});
qsym.netlist = qsym.netlist{1};

%% write netlist into a .txt file
netlistfilename = [filename(1:end-5),'.txt'];
fileID=fopen(netlistfilename,'w','n',"ISO-8859-1"); % encoding ANSI
if ~(fileID==-1)
    display(['// netlist file is created : ',netlistfilename]);
    display(char(qsym.netlist));
    for n = 1: length(qsym.netlist)
        fprintf(fid,'%s\n',qsym.netlist{n});
    end
else
    display('// netlist file cannot be created! (may be write protected)');
end
fclose('all');