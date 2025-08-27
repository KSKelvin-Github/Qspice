% QSPICE_AC2POLAR_TXT Transform QSPICE AC simulation data from rectangular to polar form
%   - Code is verified in MatLab 2024a and Octave 10.1.0
%
% Description:
%   Converts single-frequency AC simulation results from QSPICE from complex
%   (real + imaginary) representation to polar (magnitude + phase) format.
%
% Requirements:
%   - QSPICE simulation must use single-frequency AC analysis:
%       .ac list <frequency>  (e.g., .ac list 1kHz)
%
% Workflow:
%   1. Run AC simulation in QSPICE
%   2. In Waveform Viewer:
%       a. Select File > Export Data
%       b. Save results as .txt file
%   3. Run this MATLAB script and select the exported .txt file
%   4. View converted results in MATLAB Command Window
%
% Output Format:
%   Displays three representations of the data:
%   1. Rectangular form (real + j*imag)
%   2. Polar form (magnitude ∠ phase)
%   3. Polar form with dB magnitude (20*log10(mag) ∠ phase)
%
% Example:
%   Typical output format:
%       Frequency = 1000.00 Hz
%       V(out)    =   70.71 ∠  -45.00°
%       I(R1)     =    1.41 ∠   30.00°

clc; close all; clear;

% Get file and read first line
[filename, filepath] = uigetfile('*.txt');
fid = fopen(fullfile(filepath, filename));
firstLine = textscan(fid, '%s', 1, 'Delimiter', '');

% Check if AC Analysis file
if ~strcmp(firstLine{1}, 'AC Analysis')
    fprintf('%s is NOT Qspice AC Analysis, Abort!\n', filename);
    fclose(fid);
    return;
end

fprintf('Load file "%s"\n', filename);

% Read data (simplified parsing)
data = textscan(fid, '%s%f%f', 'Delimiter', ', ', 'MultipleDelimsAsOne', true);
fclose(fid);

% Organize data
exclude = {'Frequency', 'Freq', 'Omega'};
keep = ~ismember(data{1}, exclude);

txt = struct();
txt.trace = data{1}(keep);
txt.complex = data{2}(keep) + 1i*data{3}(keep);
txt.freq = data{2}(strcmp(data{1}, 'Frequency'));

% Display parameters
varWidth = 8;       % Width for variable names
numWidth = 8;       % Width for numbers
numPrec = 2;        % Decimal precision

% Display in rectangular form (real + imaginary)
fprintf('\nRectangular form (real + j*imag):\n');
fprintf('Frequency = %.*f Hz\n', numPrec, txt.freq);
arrayfun(@(n) fprintf('%-*s = %+*.*f + j*(%+*.*f)\n', ...
       varWidth, txt.trace{n}, ...
       numWidth, numPrec, real(txt.complex(n)), ...
       numWidth, numPrec, imag(txt.complex(n))), 1:numel(txt.trace));

% Display in polar form (magnitude and phase)
fprintf('\nPolar form (magnitude ∠ phase):\n');
fprintf('Frequency = %.*f Hz\n', numPrec, txt.freq);
arrayfun(@(n) fprintf('%-*s = %*.*f ∠ %+*.*f°\n', ...
       varWidth, txt.trace{n}, ...
       numWidth, numPrec, abs(txt.complex(n)), ...
       numWidth, numPrec, rad2deg(angle(txt.complex(n)))), 1:numel(txt.trace));

% Display in polar form with dB magnitude
fprintf('\nPolar form (dB magnitude ∠ phase):\n');
fprintf('Frequency = %.*f Hz\n', numPrec, txt.freq);
arrayfun(@(n) fprintf('%-*s = %*.*f dB ∠ %+*.*f°\n', ...
       varWidth, txt.trace{n}, ...
       numWidth, numPrec, 20*log10(abs(txt.complex(n))), ...  % Convert to dB
       numWidth, numPrec, rad2deg(angle(txt.complex(n)))), 1:numel(txt.trace));