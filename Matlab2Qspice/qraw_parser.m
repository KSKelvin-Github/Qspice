function [qraw]=qraw_parser(Qpathname)
%qraw_parser    Qspice parser of output data file (.qraw) in binary format
%   [qraw] = qraw_parser(Qpathname)
%       Qpathname : full path and filename of .qraw
%       [qraw] : return .qraw info and data
%           qraw.pathname : .qraw path and filename
%           qraw.info : headerlines in .qraw
%           qraw.format : binary or ascii
%           qraw.flags : data format is real or complex (r+jx)
%           qraw.value64 : raw data
%           qraw.id : expression id
%           qraw.expr : expression name
%           qraw.measure : expression measure
%           qraw.data : expression value in qraw.data(:,id)
%               if flags is real, qraw.data is directly extract
%               if flags is complex, qraw.data is extract as r+jx
%               e.g. qraw.data(:,index) : index is index of an expression
%               e.g. qraw.data(qraw.step.rng{n},index) : dataset of step n
%           qraw.step : step related info (struct)
%               qraw.step.status : .step is available of not : true / false
%               qraw.step.idxParam : index in qraw.expr/.measure/.data
%               qraw.step.TotalStep : total step number
%               qraw.step.name : param name
%               qraw.step.textstr : .step string
%               qraw.step.rng : Range for each .step in qraw.data
%               qraw.step.data : param data
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 23-Feb-2024

% Check Qpath format : assign Qpathname to Qpath.qraw
if ~isstruct(Qpathname)
    Qpath.qraw = Qpathname;
else
    Qpath = Qpathname;
end

% read info and value from .qraw binary format
qraw.pathname = Qpath.qraw;
fid = fopen(qraw.pathname);
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

% reshape qraw.value64 : qraw.value(:,id)
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

% extract .step information
if ~isempty(find(strcmp(qraw.measure,'parameter')))    % if with .step parameter
    qraw.step.status = true;
    qraw.step.idxParam = find(strcmp(qraw.measure,'parameter'));        % find index of parameter
    qraw.step.name = qraw.expr(qraw.step.idxParam);                     % .step param name
    [C,IA,~] = unique(qraw.data(:,qraw.step.idxParam),'row','stable');  % unique of corresponding param data
    qraw.step.TotalStep = length(C);                                    % total .step number = no. of unique param data
    % construct .step text string and qraw.data index range
    for n = 1: qraw.step.TotalStep
        qraw.step.textstr{n} = [];
        for m = 1: length(qraw.step.name)
            if m == 1
                qraw.step.textstr{n} = char([char(qraw.step.textstr{n}),char(qraw.step.name(m)),'=',num2str(C(n,m))]);
            else
                qraw.step.textstr{n} = char([char(qraw.step.textstr{n}),' ',char(qraw.step.name(m)),'=',num2str(C(n,m))]);
            end
        end
        % Range for each .step in qraw.data : IA is from unique index
        if n ~= qraw.step.TotalStep
            qraw.step.rng{n} = [IA(n):IA(n+1)-1];
        else
            qraw.step.rng{n} = [IA(n):length(qraw.data)];
        end
    end
    % extract .step data
    for m = 1: length(qraw.step.name)
        qraw.step.data{m} = C(:,m)';
    end
else
    qraw.step.status = false;
end

end