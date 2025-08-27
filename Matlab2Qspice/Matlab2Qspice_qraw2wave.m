clc;
close all;
clear all;

[qrawname,qrawpath] = uigetfile('*.qraw');
qraw = qraw_parser([qrawpath qrawname]);

idxx = 1;   % time
[idxyL,~] = listdlg('PromptString','Select LEFT channel:','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
[idxyR,~] = listdlg('PromptString','Select RIGHT channel:','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);

% re-sample signal with user-defined sampling frequency
Fs = 44100;     % sampling at 44.1kHz
eTime = [qraw.data(1,idxx):1/Fs:qraw.data(end,idxx)];
channelL = interp1(qraw.data(:,idxx),qraw.data(:,idxyL),eTime);
channelR = interp1(qraw.data(:,idxx),qraw.data(:,idxyR),eTime);
% normalize to value in the range -1.0 and 1.0
if max(abs(channelL)) > 1
    channelL = channelL/max(abs(channelL));
end

figure;
ax(1)=nexttile;
plot(qraw.data(:,idxx),qraw.data(:,idxyL));
xlabel([qraw.expr{idxx},' (',qraw.measure{idxx},')']);
ylabel([qraw.expr{idxyL},' (',qraw.measure{idxyL},')']);
title(['Qspice data file : ',qrawname],'interpreter','none');
ax(2)=nexttile;
plot(qraw.data(:,idxx),qraw.data(:,idxyR));
xlabel([qraw.expr{idxx},' (',qraw.measure{idxx},')']);
ylabel([qraw.expr{idxyR},' (',qraw.measure{idxyR},')']);
title(['Qspice data file : ',qrawname],'interpreter','none');
ax(3)=nexttile;
plot(eTime,channelL);
xlabel('Time (s)');
ylabel(['Channel L (Fs @',num2str(Fs),'Hz)']);
title(['Re-sampled Signal for .wav file'])
ax(4)=nexttile;
plot(eTime,channelR);
xlabel('Time (s)');
ylabel(['Channel R (Fs @',num2str(Fs),'Hz)']);
title(['Re-sampled Signal for .wav file'])
linkaxes(ax,'x');

filename = [qrawname(1:end-5),'.wav'];
audiowrite([qrawpath,filename],[channelL' channelR'],Fs);
