% Open a Qspice schematic file (.qsch) and plot results
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 23-Feb-2024
clc;
close all;
clear all;

% get schematic file .qsch and process for .qraw and .out
%  - output variable
%       [qraw] : simulation data from .qraw, type 'help qraw_parser' for help
%       [step] : .step data from .cir, type 'help qsch2qraw' for help 
%       [out]  : .meas data from .out, type 'help cir2out' for help
[filename filepath] = uigetfile('*.qsch');
[Qpath,step] = qsch2qraw([filepath,filename]);  % process .qraw with QUX and QSPICE
qraw = qraw_parser(Qpath);                      % parser .qraw file
[Qpath] = cir2out(Qpath);                       % process .out with QPOST
out = out_parser(Qpath);                        % parser .out file
delete(Qpath.cir);                              % delete .cir
delete(Qpath.out);                              % delete .out
delete(Qpath.qraw);                             % delete .qraw

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
    ylim("padded");
end

% plot flags=real data with .step
if strcmp(qraw.flags,'real') & qraw.step.status
    [idxx,~] = listdlg('PromptString','Select x-axis expression','SelectionMode','single','ListString',qraw.expr);
    [idxy,~] = listdlg('PromptString','Select y-axis expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
    for n = 1: qraw.step.TotalStep
        plot(qraw.data(qraw.step.rng{n},idxx),qraw.data(qraw.step.rng{n},idxy)); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(qraw.expr{idxy});
    legend(qraw.step.textstr);
    title([filename],'interpreter','none')
    ylim("padded");
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
    ylabel(['|',qraw.expr{idxy},'| (dB)']);
    ylim("padded");
    title([filename],'interpreter','none')
    subplot(2,1,2);
    semilogx(qraw.data(:,idxx),angle(qraw.data(:,idxy))*180/pi);
    xlabel(qraw.expr{idxx});
    ylabel(['',qraw.expr{idxy},' (degree)']);
    ylim("padded");
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
        semilogx(qraw.data(qraw.step.rng{n},idxx),20*log10(abs(qraw.data(qraw.step.rng{n},idxy)))); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(['|',qraw.expr{idxy},'| (dB)']);
    ylim("padded");
    legend(qraw.step.textstr);
    title([filename],'interpreter','none')
    subplot(2,1,2);
    for n = 1: qraw.step.TotalStep
        semilogx(qraw.data(qraw.step.rng{n},idxx),angle(qraw.data(qraw.step.rng{n},idxy))*180/pi); hold on;
    end
    xlabel(qraw.expr{idxx});
    ylabel(['',qraw.expr{idxy},' (degree)']);
    ylim("padded");
    % % nyquist plot
    % figure;
    % polarplot(phase(qraw.data(:,idxy)),abs(qraw.data(:,idxy)));
end

% Contour plot for .meas + .step analysis
if out.status && step.status       % only run 3-D plot if .meas and .step are both available
    % merge step and out (as .out file alone doesn't have .step parameter and value
    out.name = [step.name out.name];
    out.data = [step.data out.data];
    out.meas = [step.name out.meas];

    [idxx,~] = listdlg('PromptString','Select x-axis:','SelectionMode','single','ListString',out.name,'InitialValue',1);
    [idxy,~] = listdlg('PromptString','Select y-axis:','SelectionMode','single','ListString',out.name,'InitialValue',2);
    [idxz,~] = listdlg('PromptString','Select z-axis:','SelectionMode','multiple','ListString',out.name,'InitialValue',3);

    figure;
    xx = linspace(min(out.data{idxx}),max(out.data{idxx}),20);
    yy = linspace(min(out.data{idxy}),max(out.data{idxy}),20);
    [X,Y] = meshgrid(xx,yy);
    [Z] = griddata(out.data{idxx},out.data{idxy},out.data{idxz},X,Y);
    contourf(X,Y,Z); colorbar; colormap jet;
    xlabel(out.name{idxx});
    ylabel(out.name{idxy});
    title({out.name{idxz},out.meas{idxz}},'interpreter','none');
end