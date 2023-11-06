function [qraw]=qraw_parser(Qpathname)
%qraw_parser    Qspice parser of output data file (.qraw) in binary format
%   [qraw] = qraw_parser(Qpathname)
%       Qpathname : full path and filename of .qraw
%       [qraw] : return .qraw info and data
%           qraw.pathname : .qraw path and filename
%           qraw.info : headerlines in .qraw
%           qraw.format : binary or ascii
%           qraw.flags : data format is real or complex (R+jX)
%           qraw.value64 : raw data
%           qraw.id : expression id
%           qraw.expr : expression name
%           qraw.measure : expression measure
%           qraw.data : expression value in qraw.data(:,id)
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 6-Nov-2023 12:14pm

% read info and value from .qraw binary format
fid = fopen(Qpathname);
qraw.pathname = Qpathname;
idx = 1;
while true  % loop to read before headerlines in .qraw into qraw.info
    C = textscan(fid, '%s', 1 ,'delimiter','');
    % terminate if empty readback or read 'Binary:' or 'Values:'
    if isempty(C{1}) | strcmp(C{1},'Binary:') | strcmp(C{1},'Values:')
        if strcmp(C{1},'Binary:')
            qraw.format = 'binary';
        elseif strcmp(C{1},'Values:')
            qraw.format = 'ascii';
        end
        break;
    end
    qraw.info(idx) = C{1};
    idx = idx+1;
end
qraw.info = qraw.info';     % store information into qraw.info
% flags : real or complex
if sum(strncmp(qraw.info,'Flags: complex',14))>0
    qraw.flags = 'complex';
else
    qraw.flags = 'real';
end
% get all data and store into qraw.value64
if strcmp(qraw.format,'binary')
    % binary format
    dummy = fread(fid,1,'char');    % discard newline character 0x0a
    qraw.value64 = fread(fid,'*float64');   % values in float64 (8 bytes per value)
elseif strcmp(qraw.format,'ascii')
    % ascii format
    display('qraw_praser() : no data is read to qraw.value64, only support binary format, not ascii format');
    return;
end
fclose(fid);

% expression into qraw.id, qraw.expr and qraw.measure
n = [find(strcmp(qraw.info,'Variables:')==1)+1:1:length(qraw.info)];
for idx = 1: length(n)
    C=textscan(cell2mat(qraw.info(n(idx))),'%d\t%s\t%s');
    qraw.id(idx) = C{1}+1;      % store expression id
    qraw.expr(idx) = C{2};      % store expression name
    qraw.measure(idx) = C{3};      % store expression unit
end

% reshape value64 : qraw.value(:,id)
if strcmp(qraw.flags,'real')
    % process for data type : real (.dc|.tran)
    datacolumn = length(qraw.id);
    qraw.data = reshape(qraw.value64,datacolumn,[])';
elseif strcmp(qraw.flags,'complex')
    % process for data type : complex (.ac)
    datacolumn = length(qraw.id)*2-1;
    temp.data = reshape(qraw.value64,datacolumn,[])';
    idx = 1;
    qraw.data(:,1) = temp.data(:,1);
    for idx = 2: length(qraw.id)
        qraw.data(:,idx) = temp.data(:,(idx-1)*2) + j*temp.data(:,(idx-1)*2+1);
    end
else
end