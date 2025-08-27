% Open a Qspice FFT qraw data (.fft.qraw) and plot results
%
%Github : https://github.com/KSKelvin-Github/Qspice
%last update : 12-Mar-2024

clc;
close all;
clear all;

[filename filepath] = uigetfile('*.fft.qraw');
[qraw] = qraw_parser([filepath filename]);
% frequency data in Hz: qraw.data(:,1)
% fft data in complex format : qraw.data(:,n), where n is n-th parameter

h=figure;
set(h,'position',[488,142,700 550]);
for n = 2 : qraw.id(end)
    ax(1)=subplot(2,1,1);
    semilogx(qraw.data(:,1),abs(qraw.data(:,n))); hold on;
    xlabel('Frequency (Hz)'); ylabel('Magnitude')
    ax(2)=subplot(2,1,2);
    semilogx(qraw.data(:,1),20*log10(abs(qraw.data(:,n)))); hold on;
    xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)')
end
subplot(2,1,1);
legend(qraw.expr{2:end},'location','bestoutside');
title(['Filename : ',filename],'interpreter','none');
subplot(2,1,2);
legend(qraw.expr{2:end},'location','bestoutside');
linkaxes(ax,'x');
xlim tight;