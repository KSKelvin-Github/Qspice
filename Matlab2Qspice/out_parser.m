function [out]=out_parser(Qpathname)
%out_parser    Qspice parser of qpost (.out)
%   [out] = out_parser(Qpathname)
%       Qpathname : full path and filename of .qraw
%       [out] : return .out info and data
%           out.pathname : .out path and filename
%           out.status : .out contains .meas directive
%           out.text : text string in .out
%           out.step : step status (true / false)
%           out.meas : .meas directive
%           out.name : name in .meas
%           out.flags : data format is real or complex (r+jx)
%           out.data : data of .meas
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 23-Feb-2024

% Check Qpath format : assign Qpathname to Qpath.out
if ~isstruct(Qpathname)
    Qpath.out = Qpathname;
else
    Qpath = Qpathname;
end

% read info and value from .out
out.pathname = Qpath.out;
fid = fopen(out.pathname);
C = textscan(fid, '%s', 'delimiter', '' ,'ReturnOnError', false);
out.text = C{1};
fclose(fid);

% index (idx) of line with .meas
idx = find(strncmp(out.text,'.meas',5));
% return if no .meas in .out file
if isempty(idx)
    out.status = false;
    return;
end
out.status = true;

% range (rng) of line with data of .meas
for n = 1: length(idx)
    if n ~= length(idx)
        rng{n} = [idx(n)+1:idx(n+1)-1];
    else
        rng{n} = [idx(n)+1:length(out.text)];
    end
end

% determine if data is from .step : not .step if range of data is 1 line only
out.step = true;
if length(rng{1})==1
    out.step = false;
end

% get .meas data
for n = 1: length(idx)
    % get .meas statement and headers name
    out.meas{n} = char(out.text{idx(n)});
    idx_space = find(out.meas{n}==' ',2);
    out.name{n} = out.meas{n}(idx_space(1)+1:idx_space(2)-1);
    % extract data
    for m = 1: length(rng{n})
        msg = out.text{rng{n}(m)};  % msg as .meas dataline
        % get complex or real format data
        if strfind(msg,',') % complex data with ( real , imag )
            out.flags = 'complex';  % complex data format
            D = textscan(msg, '%f%f%f', 'delimiter', {'\t','(',')',','});
            if out.step
                % .step is true : D{1} is step index, D{2} and D{3} are (real,imag) .meas output
                out.data{n}(m) = D{2}+D{3}*j;
            else
                % .step is false : D{1} and D{2} are (real,imag) .meas output
                out.data{n}(m) = D{1}+D{2}*j;
            end
        else
            out.flags = 'real'; % real data format
            D = textscan(msg, '%f%f%f', 'delimiter', '\t');
            if out.step
                % .step is true : D{1} is step index, D{2} is .meas output
                out.data{n}(m) = D{2};
            else
                % .step is false : D{1} is .meas output
                out.data{n}(m) = D{1};
            end
        end
    end
end

end