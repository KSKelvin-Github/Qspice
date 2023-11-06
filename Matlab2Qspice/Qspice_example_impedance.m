clc;
close all;
clear all;

% messsage box for this example
str = {
    'example to calculate impedance and gamma'
    ''
    '1. load "impedance (.ac).qsch from folder "test circuit"'
    '2. select V(in) as voltage'
    '3. select I(V1) as current'
    '4. select -ve for current direction'
    };
waitfor(msgbox(str));

% load Qspice schematic (.qsch) and convert to output data (.qraw)
% .qraw is store into matlab variable qraw
[filename filepath] = uigetfile('*.qsch');
Qpath = qsch2qraw([filepath,filename]);
delete(Qpath.cir);      % delete .cir
qraw = qraw_parser([Qpath.qraw]);
delete(qraw.pathname);  % delete .qraw

% only process if data is complex format
if ~strcmp(qraw.flags,'complex')
    display('error : this is not a .ac analysis')
    return;
end

% assign index for frequency, voltage and current for impedance calculation
idxF = 1;
[idxV,~] = listdlg('PromptString','Select Voltage expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',2);
[idxI,~] = listdlg('PromptString','Select Current expression','SelectionMode','single','ListString',qraw.expr,'InitialValue',3);

% confirm current direction is +ve or -ve
ButtonName = questdlg('Current Direction?', ...
    'Question', ...
    '+ve', '-ve', '-ve');
switch ButtonName
    case '-ve'
        Isign = -1;
    case '+ve'
        Isign = +1;
end % switch

% assign freq, V and I
freq = qraw.data(:,idxF);
V = qraw.data(:,idxV);
I = Isign*qraw.data(:,idxI);
if Isign == 1
    Zexpr = [cell2mat(qraw.expr(idxV)),'/',cell2mat(qraw.expr(idxI))]
else
    Zexpr = [cell2mat(qraw.expr(idxV)),'/-',cell2mat(qraw.expr(idxI))]
end

% calculate impedance (Z) and gamma (S)
Z = V./I;
Zo = 50;    % characteristic impedance
S = (Z-Zo)./(Z+Zo);

% calculate Rs-Cs or Rs-Ls model parameters
Rs = real(Z);
XC = imag(Z);
XL = imag(Z);
Cs = -1/2/pi./freq./XC;
Ls = XL/2/pi./freq;

% frequency scale and unit
if max(freq)/1e9 > 1
    fscale = 1e9;
    funit = 'GHz';
elseif max(freq)/1e6 > 1
    fscale = 1e6;
    funit = 'MHz';
elseif max(freq)/1e3 > 1
    fscale = 1e3;
    funit = 'kHz';
else
    fscale = 1;
    funit = 'Hz';
end

% plot SmithChart and Impedance
hfig = figure;
set(hfig,'position',[188 142 560 560]);
subplot(2,2,1);
plot(real(S),imag(S),'.','MarkerSize',10); hold on;
func_smithchart;
axis([-1 1 -1 1]);
title({[filename],'S-parameter Gamma'},'interpreter','none')
subplot(2,2,2);
plot(real(Z),imag(Z),'.','MarkerSize',10);
xlabel('re(Gamma)'); ylabel('im(Gamma)');
title(['Impedance Z=',Zexpr])
subplot(2,2,[3 4]);
plot(freq/fscale,real(Z)); hold on;
plot(freq/fscale,imag(Z));
legend('R','jX','location','best');
xlabel(['Frequency (',funit,')'])
title(['Impedance Z=',Zexpr,' vs Frequency'])

% plot Rs-Cs or Rs-Ls
hfig = figure;
set(hfig,'position',[788 142 460 560]);
ax(1)=subplot(3,1,1);
semilogx(freq/fscale,Rs);
ylabel('Rs (ohms)');
title('Rs-Cs or Rs-Ls Equivalent Circuit Parameters')
ax(2)=subplot(3,1,2);
semilogx(freq/fscale,Cs);
ylabel('Cs (F)');
ax(3)=subplot(3,1,3);
semilogx(freq/fscale,Ls);
ylabel('Ls (H)');
xlabel(['Frequency (',funit,')'])
linkaxes(ax,'x')

% SmithChart function
function func_smithchart();
Zo = 50;
ratio = 2;
for Zrr = Zo*[0 1/ratio 1 ratio];
    Zr = Zrr + linspace(-2000,2000,1000)*j;
    gamma_Zr = (Zr - Zo)./(Zr + Zo);
    plot(real(gamma_Zr),imag(gamma_Zr),'k:');
    hold on;
end
for Zii = Zo*[-ratio -1 -1/ratio 0 1/ratio 1 ratio]
    Zi = linspace(0,2000,1000) + Zii*j;
    gamma_Zi = (Zi - Zo)./(Zi + Zo);
    plot(real(gamma_Zi),imag(gamma_Zi),'k:');
    hold on;
end
axis square;
xlabel(['Zo=',num2str(Zo),', Line: 0,',num2str(Zo/ratio),',50,',num2str(Zo*ratio),' Ohms']);
end

