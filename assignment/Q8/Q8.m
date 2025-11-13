% Q8: Blood Velocity Estimation from Plug Flow Data
% 
% This script analyzes ultrasound data from plug_flow.mat using averaged
% cross-correlation to estimate blood velocity.

% Add utilities to path
addpath('../../utilis');

clear; close all; clc;

%% Load the data
fprintf('Loading plug_flow.mat...\n');
load('plug_flow.mat');

%% Parameters
fs = 100e6;        % Sampling frequency: 100 MHz
T_prf = 200e-6;    % Pulse repetition period: 200 microseconds
c = 1540;          % Speed of sound: 1540 m/s

fprintf('Data shape: %d samples x %d lines\n', size(data, 1), size(data, 2));
fprintf('Sampling frequency: %.0f MHz\n', fs/1e6);
fprintf('Pulse repetition period: %.0f μs\n', T_prf*1e6);
fprintf('Speed of sound: %.0f m/s\n\n', c);

%% Estimate velocity using averaged cross-correlation
velocity = estimate_velocity_averaged(data, T_prf, c, fs);

fprintf('Estimated blood velocity: %.4f m/s\n', velocity);
fprintf('Estimated blood velocity: %.2f cm/s\n\n', velocity*100);

%% Visualization
figure('Position', [100, 100, 1200, 800]);

% Plot first two lines
subplot(2, 2, 1);
plot(data(:, 1), 'LineWidth', 1.5);
hold on;
plot(data(:, 2), 'LineWidth', 1.5);
xlabel('Sample');
ylabel('Amplitude');
title('First Two Lines');
legend('Line 1', 'Line 2');
grid on;

% Plot all lines as an image
subplot(2, 2, 2);
imagesc(data);
colormap(gray);
xlabel('Line Number');
ylabel('Sample');
title('All Lines');
colorbar;

% Compute and plot averaged cross-correlation
[n_samples, n_lines] = size(data);
correlations = [];
for i = 1:(n_lines - 1)
    [corr, lags] = xcorr(data(:, i+1), data(:, i));
    correlations = [correlations; corr'];
end
avg_correlation = mean(correlations, 1);
[max_val, max_idx] = max(avg_correlation);

subplot(2, 2, 3);
plot(lags, avg_correlation, 'LineWidth', 1.5);
hold on;
xline(lags(max_idx), 'r--', sprintf('Max at lag=%d', lags(max_idx)), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
xlabel('Lag (samples)');
ylabel('Cross-correlation');
title('Averaged Cross-Correlation Function');
grid on;

% Zoomed view around maximum
subplot(2, 2, 4);
window = 500;
start_idx = max(1, max_idx - window);
end_idx = min(length(lags), max_idx + window);
plot(lags(start_idx:end_idx), avg_correlation(start_idx:end_idx), 'LineWidth', 1.5);
hold on;
xline(lags(max_idx), 'r--', sprintf('Max at lag=%d', lags(max_idx)), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
xlabel('Lag (samples)');
ylabel('Cross-correlation');
title('Zoomed Cross-Correlation (around maximum)');
grid on;

sgtitle(sprintf('Q8: Plug Flow Analysis - Velocity = %.2f cm/s', velocity*100), ...
        'FontSize', 14, 'FontWeight', 'bold');

% Save figure
saveas(gcf, 'Q8_analysis.png');
fprintf('Plot saved as Q8_analysis.png\n');
