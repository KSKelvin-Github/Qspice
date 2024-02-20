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
        [Qpath,step] = qsch2qraw([filepath,filename]);  % process .qraw with QUX and QSPICE
        cir2out(Qpath.cir);                         % process .out with QPOST
        delete(Qpath.cir);                          % delete .cir
        qraw = qraw_parser([Qpath.qraw]);           % parser .qraw file
    case '.qraw'
        % load qraw
        [filename filepath] = uigetfile('*.qraw');  % parser .qraw file
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

% plot flags=real data without .step
if strcmp(qraw.flags,'real') & ~qraw.step.status
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','multiple','ListString',qraw.expr,'InitialValue',2);
    plot(qraw.data(:,idxx),qraw.data(:,idxy));
    xlabel(qraw.expr{idxx});
    if length(idxy)==1
        ylabel(qraw.expr{idxy});
    else
        legend(qraw.expr{idxy});
    end
    title([filename],'interpreter','none')
end

% plot flags=real data with .step
if strcmp(qraw.flags,'real') & qraw.step.status
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
    for n = 1: qraw.step.TotalStep
        plot(qraw.data(qraw.step.Rng{n},idxx),qraw.data(qraw.step.Rng{n},idxy)); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(qraw.expr{idxy});
    legend(qraw.step.textstr);
    title([filename],'interpreter','none')
end

% plot flags=complex data ; Magnitude and Phase Plot without .step
if strcmp(qraw.flags,'complex') & ~qraw.step.status
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
    % magnitude and phase plot
    figure;
    subplot(2,1,1);
    semilogx(qraw.data(:,idxx),20*log10(abs(qraw.data(:,idxy))));
    xlabel(qraw.expr{idxx});
    ylabel(['|',qraw.expr{idxy},'| (dB)'])
    title([filename],'interpreter','none')
    subplot(2,1,2);
    semilogx(qraw.data(:,idxx),phase(qraw.data(:,idxy))*180/pi);
    xlabel(qraw.expr{idxx});
    ylabel(['',qraw.expr{idxy},' (degree)'])
    % % nyquist plot
    % figure;
    % polarplot(phase(qraw.data(:,idxy)),abs(qraw.data(:,idxy)));
end

% plot flags=complex data ; Magnitude and Phase Plot with .step
if strcmp(qraw.flags,'complex') & qraw.step.status
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
    % magnitude and phase plot
    figure;
    subplot(2,1,1);
    for n = 1: qraw.step.TotalStep
        semilogx(qraw.data(qraw.step.Rng{n},idxx),20*log10(abs(qraw.data(qraw.step.Rng{n},idxy)))); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(['|',qraw.expr{idxy},'| (dB)'])
    legend(qraw.step.textstr);
    title([filename],'interpreter','none')
    subplot(2,1,2);
    for n = 1: qraw.step.TotalStep
        semilogx(qraw.data(qraw.step.Rng{n},idxx),phase(qraw.data(qraw.step.Rng{n},idxy))*180/pi); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(['',qraw.expr{idxy},' (degree)'])
    % % nyquist plot
    % figure;
    % polarplot(phase(qraw.data(:,idxy)),abs(qraw.data(:,idxy)));
end
