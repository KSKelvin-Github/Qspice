% =========================================================================
% MATLAB-to-QSPICE Interactive Demo Script
% =========================================================================
% Description:
%   Prompts the user to select a QSPICE schematic file (.qsch), runs the
%   simulation via QSPICE, parses the resulting waveform (.qraw) and
%   measurement (.out) data, and interactively plots the results:
%
%   - Real data (e.g., .tran, .dc)       : 2D line plot (single or .step)
%   - Complex data (e.g., .ac)           : Bode magnitude (dB) & phase (deg)
%   - Combined .step + .meas data        : 2D filled contour plot
%
%   Temporary .cir, .out, and .qraw files are automatically cleaned up
%   after parsing.
%
% Dependencies:
%   qsch2qraw.m, qsch2qraw_pwd.m, qraw_parser.m, cir2out.m, out_parser.m
%
% GitHub       : https://github.com/KSKelvin-Github/Qspice
% Last Updated : 20-Nov-2026
% =========================================================================

% Clear Command Window, close all figure windows, and reset workspace variables
clc;
close all;
clear all;

% =========================================================================
% 1. Select Schematic (.qsch), Run QSPICE, and Parse Output Data
% =========================================================================
% Output variables produced in this section:
%   [qraw] : Simulation waveform data from .qraw (type 'help qraw_parser')
%   [step] : .step sweep metadata from console   (type 'help qsch2qraw')
%   [out]  : .meas measurement data from .out    (type 'help cir2out')
[filename, filepath] = uigetfile('*.qsch', 'Select a QSPICE Schematic (.qsch)');
if isequal(filename, 0)
    disp('File selection canceled.');
    return;
end

full_qsch_path = fullfile(filepath, filename);

% Route to qsch2qraw_pwd() if the schematic is in a write-protected folder
if ~startsWith(filepath, 'C:\Program Files\', 'IgnoreCase', true)
    [Qpath, step] = qsch2qraw(full_qsch_path);      % Generate .cir and .qraw in source folder
else
    [Qpath, step] = qsch2qraw_pwd(full_qsch_path);  % Generate .cir and .qraw in current folder (pwd)
end

% Parse waveform data (.qraw) and post-process .meas results (.out)
qraw  = qraw_parser(Qpath);                         % Parse .qraw waveform file
Qpath = cir2out(Qpath);                             % Process .out with QPOST
out   = out_parser(Qpath);                          % Parse .out measurement file

% Safely delete temporary simulation files if they exist
if isfile(Qpath.cir),  delete(Qpath.cir);  end
if isfile(Qpath.out),  delete(Qpath.out);  end
if isfile(Qpath.qraw), delete(Qpath.qraw); end

% =========================================================================
% 2. Plot Real Data Without .step (e.g., .tran, .dc)
% =========================================================================
if strcmp(qraw.flags, 'real') && ~qraw.step.status
    [idxx, idxy, ~, ok] = selectAxesDialog(qraw.expr, '2D', true);
    if ok
        figure('Color', 'w', 'Position', [100, 100, 900, 500]);
        plot(qraw.data(:, idxx), qraw.data(:, idxy), 'LineWidth', 1.5);
        grid on;
        box on;
        set(gca, 'FontSize', 11, 'LineWidth', 1);
        xlabel(qraw.expr{idxx}, 'Interpreter', 'none', 'FontWeight', 'bold');
        if length(idxy) == 1
            ylabel(qraw.expr{idxy}, 'Interpreter', 'none', 'FontWeight', 'bold');
        else
            ylabel('Amplitude', 'FontWeight', 'bold');
            legend(qraw.expr{idxy}, 'Interpreter', 'none', 'Location', 'best');
        end
        title(filename, 'Interpreter', 'none', 'FontSize', 13, 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');
    end
end

% =========================================================================
% 3. Plot Real Data With .step Sweep
% =========================================================================
if strcmp(qraw.flags, 'real') && qraw.step.status
    [idxx, idxy, ~, ok] = selectAxesDialog(qraw.expr, '2D', false);
    if ok
        figure('Color', 'w', 'Position', [100, 100, 980, 520]);
        hold on;
        for n = 1:qraw.step.TotalStep
            plot(qraw.data(qraw.step.rng{n}, idxx), qraw.data(qraw.step.rng{n}, idxy), 'LineWidth', 1.5);
        end
        hold off;
        grid on;
        box on;
        set(gca, 'FontSize', 11, 'LineWidth', 1);
        xlabel(qraw.expr{idxx}, 'Interpreter', 'none', 'FontWeight', 'bold');
        ylabel(qraw.expr{idxy}, 'Interpreter', 'none', 'FontWeight', 'bold');
        legend(qraw.step.textstr, 'Interpreter', 'none', 'Location', 'eastoutside');
        title(filename, 'Interpreter', 'none', 'FontSize', 13, 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');
    end
end

% =========================================================================
% 4. Plot Complex Data Without .step (Bode Magnitude & Phase)
% =========================================================================
if strcmp(qraw.flags, 'complex') && ~qraw.step.status
    [idxx, idxy, ~, ok] = selectAxesDialog(qraw.expr, '2D', false);
    if ok
        figure('Color', 'w', 'Position', [100, 100, 900, 620]);
        t = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
        title(t, filename, 'Interpreter', 'none', 'FontSize', 13, 'FontWeight', 'bold');

        % Top tile: Magnitude (dB)
        ax1 = nexttile;
        semilogx(qraw.data(:, idxx), 20 * log10(abs(qraw.data(:, idxy))), 'LineWidth', 1.5);
        grid on; grid minor;
        box on;
        set(ax1, 'FontSize', 11, 'LineWidth', 1);
        ylabel(['|', qraw.expr{idxy}, '| (dB)'], 'Interpreter', 'none', 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');

        % Bottom tile: Phase (degrees)
        ax2 = nexttile;
        semilogx(qraw.data(:, idxx), angle(qraw.data(:, idxy)) * 180 / pi, 'LineWidth', 1.5);
        grid on; grid minor;
        box on;
        set(ax2, 'FontSize', 11, 'LineWidth', 1);
        xlabel(qraw.expr{idxx}, 'Interpreter', 'none', 'FontWeight', 'bold');
        ylabel(['\angle ', qraw.expr{idxy}, ' (deg)'], 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');

        % Synchronize frequency zoom/pan across Magnitude and Phase
        linkaxes([ax1, ax2], 'x');

        % Optional Nyquist plot:
        % figure('Color', 'w');
        % polarplot(angle(qraw.data(:, idxy)), abs(qraw.data(:, idxy)), 'LineWidth', 1.5);
    end
end

% =========================================================================
% 5. Plot Complex Data With .step Sweep (Bode Magnitude & Phase)
% =========================================================================
if strcmp(qraw.flags, 'complex') && qraw.step.status
    [idxx, idxy, ~, ok] = selectAxesDialog(qraw.expr, '2D', false);
    if ok
        figure('Color', 'w', 'Position', [100, 100, 980, 640]);
        t = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
        title(t, filename, 'Interpreter', 'none', 'FontSize', 13, 'FontWeight', 'bold');

        % Top tile: Magnitude (dB) across all .step runs
        ax1 = nexttile;
        hold on;
        for n = 1:qraw.step.TotalStep
            semilogx(qraw.data(qraw.step.rng{n}, idxx), 20 * log10(abs(qraw.data(qraw.step.rng{n}, idxy))), 'LineWidth', 1.5);
        end
        hold off;
        grid on; grid minor;
        box on;
        set(ax1, 'FontSize', 11, 'LineWidth', 1);
        ylabel(['|', qraw.expr{idxy}, '| (dB)'], 'Interpreter', 'none', 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');
        lgd = legend(qraw.step.textstr, 'Interpreter', 'none');
        lgd.Layout.Tile = 'east';

        % Bottom tile: Phase (degrees) across all .step runs
        ax2 = nexttile;
        hold on;
        for n = 1:qraw.step.TotalStep
            semilogx(qraw.data(qraw.step.rng{n}, idxx), angle(qraw.data(qraw.step.rng{n}, idxy)) * 180 / pi, 'LineWidth', 1.5);
        end
        hold off;
        grid on; grid minor;
        box on;
        set(ax2, 'FontSize', 11, 'LineWidth', 1);
        xlabel(qraw.expr{idxx}, 'Interpreter', 'none', 'FontWeight', 'bold');
        ylabel(['\angle ', qraw.expr{idxy}, ' (deg)'], 'FontWeight', 'bold');
        xlim('tight');
        ylim('padded');

        % Synchronize frequency zoom/pan across Magnitude and Phase
        linkaxes([ax1, ax2], 'x');

        % Optional Nyquist plot:
        % figure('Color', 'w');
        % polarplot(angle(qraw.data(:, idxy)), abs(qraw.data(:, idxy)), 'LineWidth', 1.5);
    end
end

% =========================================================================
% 6. Contour Plot for Combined .meas + .step Analysis
% =========================================================================
if out.status && step.status    % Only run contour plot if both .meas and .step are available
    % Merge .step parameter arrays into 'out' (.out alone does not store .step values)
    out.name = [step.name, out.name];
    out.data = [step.data, out.data];
    out.meas = [step.name, out.meas];

    [idxx, idxy, idxz, ok] = selectAxesDialog(out.name, '3D', false);
    if ok
        figure('Color', 'w', 'Position', [100, 100, 820, 600]);
        xx = linspace(min(out.data{idxx}), max(out.data{idxx}), 100);
        yy = linspace(min(out.data{idxy}), max(out.data{idxy}), 100);
        [X, Y] = meshgrid(xx, yy);
        Z = griddata(out.data{idxx}, out.data{idxy}, out.data{idxz}, X, Y);

        contourf(X, Y, Z, 20, 'LineColor', [0.25 0.25 0.25], 'LineWidth', 0.5);
        hold on;
        plot(out.data{idxx}, out.data{idxy}, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 4);
        hold off;

        colormap(turbo);
        cb = colorbar;
        cb.Label.String = out.name{idxz};
        cb.Label.Interpreter = 'none';
        cb.Label.FontWeight = 'bold';
        cb.Label.FontSize = 11;

        grid on;
        box on;
        set(gca, 'FontSize', 11, 'LineWidth', 1);
        xlabel(out.name{idxx}, 'Interpreter', 'none', 'FontWeight', 'bold');
        ylabel(out.name{idxy}, 'Interpreter', 'none', 'FontWeight', 'bold');
        title({out.name{idxz}, out.meas{idxz}}, 'Interpreter', 'none', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

% =========================================================================
% Local Helper Function: Single Unified Axis Selection Dialog
% =========================================================================
function [idxx, idxy, idxz, ok] = selectAxesDialog(itemList, mode, multiY)
    % Initialize outputs
    idxx = []; idxy = []; idxz = []; ok = false;
    nItems  = numel(itemList);
    idxData = 1:nItems;

    % Size dialog based on mode and whether Y uses a multi-select listbox
    is3D = strcmpi(mode, '3D');
    if multiY
        figH = 340;
    elseif is3D
        figH = 220;
    else
        figH = 175;
    end

    % Create modal dialog window
    fig = uifigure('Name', 'Select Plot Axes', 'Position', [400, 300, 380, figH], ...
                   'Resize', 'off', 'WindowStyle', 'modal');
    fig.CloseRequestFcn = @(~, ~) onCancel();

    % Configure grid layout
    if is3D
        gl = uigridlayout(fig, [4, 2]);
        gl.RowHeight = {30, 30, 30, 36};
    elseif multiY
        gl = uigridlayout(fig, [3, 2]);
        gl.RowHeight = {30, '1x', 36};
    else
        gl = uigridlayout(fig, [3, 2]);
        gl.RowHeight = {30, 30, 36};
    end
    gl.ColumnWidth = {90, '1x'};
    gl.Padding     = [15, 15, 15, 15];
    gl.RowSpacing  = 10;

    % --- X-Axis (Dropdown) ---
    lblX = uilabel(gl, 'Text', 'X-Axis:', 'FontWeight', 'bold');
    lblX.Layout.Row = 1; lblX.Layout.Column = 1;
    ddX = uidropdown(gl, 'Items', itemList, 'ItemsData', idxData, 'Value', 1);
    ddX.Layout.Row = 1; ddX.Layout.Column = 2;

    % --- Y-Axis (Multi-select Listbox OR Dropdown) ---
    lblY = uilabel(gl, 'Text', 'Y-Axis:', 'FontWeight', 'bold', 'VerticalAlignment', 'top');
    lblY.Layout.Row = 2; lblY.Layout.Column = 1;
    if multiY
        ctrlY = uilistbox(gl, 'Items', itemList, 'ItemsData', idxData, ...
                          'Multiselect', 'on', 'Value', min(2, nItems));
    else
        ctrlY = uidropdown(gl, 'Items', itemList, 'ItemsData', idxData, ...
                           'Value', min(2, nItems));
    end
    ctrlY.Layout.Row = 2; ctrlY.Layout.Column = 2;

    % --- Z-Axis (Dropdown, 3D Contour Mode Only) ---
    ddZ = [];
    if is3D
        lblZ = uilabel(gl, 'Text', 'Z-Axis:', 'FontWeight', 'bold');
        lblZ.Layout.Row = 3; lblZ.Layout.Column = 1;
        ddZ = uidropdown(gl, 'Items', itemList, 'ItemsData', idxData, ...
                         'Value', min(3, nItems));
        ddZ.Layout.Row = 3; ddZ.Layout.Column = 2;
        btnRow = 4;
    else
        btnRow = 3;
    end

    % --- OK / Cancel Buttons ---
    btnGrid = uigridlayout(gl, [1, 2], 'Padding', [0, 0, 0, 0]);
    btnGrid.Layout.Row = btnRow;
    btnGrid.Layout.Column = [1, 2];

    uibutton(btnGrid, 'Text', 'OK', 'FontWeight', 'bold', 'ButtonPushedFcn', @(~, ~) onOK());
    uibutton(btnGrid, 'Text', 'Cancel', 'ButtonPushedFcn', @(~, ~) onCancel());

    % Pause execution until user clicks OK, Cancel, or closes the dialog
    uiwait(fig);

    function onOK()
        idxx = ddX.Value;
        idxy = ctrlY.Value;
        if is3D
            idxz = ddZ.Value;
        end
        ok = true;
        delete(fig);
    end

    function onCancel()
        ok = false;
        delete(fig);
    end
end