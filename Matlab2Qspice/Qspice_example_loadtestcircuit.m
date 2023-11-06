clc;
close all;
clear all;

% Quest Dlg
Qfiletype = questdlg('What file to load?', ...
    'Question', ...
    '.qsch', '.qraw', '.qraw');
switch Qfiletype
    case '.qsch'
        %convert qsch to qraw, and load qraw
        [filename filepath] = uigetfile('*.qsch');
        Qpath = qsch2qraw([filepath,filename]);
        delete(Qpath.cir);      % delete .cir
        qraw = qraw_parser([Qpath.qraw]);
    case '.qraw'
        % load qraw
        [filename filepath] = uigetfile('*.qraw');
        qraw = qraw_parser([filepath,filename]);
end % switch

% quest : delete .qraw
Answer = questdlg('Delete .qraw?', ...
    'Question', ...
    'Yes', 'No', 'No');
switch Answer
    case 'Yes'
        delete(qraw.pathname);
end % switch

% plot flags=real data
if strcmp(qraw.flags,'real')
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','multiple','ListString',qraw.expr,'InitialValue',2);
    plot(qraw.data(:,idxx),qraw.data(:,idxy));
    xlabel(qraw.expr{idxx});
    if length(idxy)==1
        ylabel(qraw.expr{idxy});
    else
        legend(qraw.expr{idxy});
    end
    title([qraw.pathname],'interpreter','none')
end

% plot flags=complex data ; Magnitude and Phase Plot
if strcmp(qraw.flags,'complex')
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
    subplot(2,1,1);
    semilogx(qraw.data(:,idxx),20*log10(abs(qraw.data(:,idxy))));
    xlabel(qraw.expr{idxx});
    ylabel(['|',qraw.expr{idxy},'| (dB)'])
    title([qraw.pathname],'interpreter','none')
    subplot(2,1,2);
    semilogx(qraw.data(:,idxx),phase(qraw.data(:,idxy))*180/pi);
    xlabel(qraw.expr{idxx});
    ylabel(['',qraw.expr{idxy},' (degree)'])
end
