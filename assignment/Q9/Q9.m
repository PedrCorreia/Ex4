% Q9: Segmented Blood Velocity Estimation from Plug Flow Data
% 
% This script divides RF data into 2 microsecond segments and estimates
% velocity within each segment.

% Add utilities to path
addpath('../../utilis');

clear; close all; clc;

%% Load the data
fprintf('Loading plug_flow.mat...\n');
load('plug_flow.mat');

%% Parameters
fs = 100e6;                  % Sampling frequency: 100 MHz
T_prf = 200e-6;              % Pulse repetition period: 200 microseconds
c = 1540;                    % Speed of sound: 1540 m/s
segment_duration = 2e-6;     % Segment duration: 2 microseconds

fprintf('Data shape: %d samples x %d lines\n', size(data, 1), size(data, 2));
fprintf('Sampling frequency: %.0f MHz\n', fs/1e6);
fprintf('Pulse repetition period: %.0f μs\n', T_prf*1e6);
fprintf('Speed of sound: %.0f m/s\n', c);
fprintf('Segment duration: %.0f μs\n', segment_duration*1e6);
fprintf('Segment size: %d samples\n\n', round(segment_duration*fs));

%% Estimate velocities for segments
[velocities, segment_centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration);

fprintf('Number of segments: %d\n\n', length(velocities));
fprintf('Velocity statistics:\n');
fprintf('  Mean:   %.4f m/s (%.2f cm/s)\n', mean(velocities), mean(velocities)*100);
fprintf('  Std:    %.4f m/s (%.2f cm/s)\n', std(velocities), std(velocities)*100);
fprintf('  Min:    %.4f m/s (%.2f cm/s)\n', min(velocities), min(velocities)*100);
fprintf('  Max:    %.4f m/s (%.2f cm/s)\n\n', max(velocities), max(velocities)*100);
fprintf('Depth range: %.2f mm to %.2f mm\n\n', depths(1)*1000, depths(end)*1000);

%% Visualization
figure('Position', [100, 100, 1400, 1000]);

% Plot velocity vs segment number
subplot(2, 2, 1);
plot(0:length(velocities)-1, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
xlabel('Segment Number');
ylabel('Velocity (cm/s)');
title('Velocity vs Segment Number');
grid on;

% Plot velocity vs depth
subplot(2, 2, 2);
plot(depths * 1000, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
xlabel('Depth (mm)');
ylabel('Velocity (cm/s)');
title('Velocity vs Depth');
grid on;

% Plot velocity vs time
subplot(2, 2, 3);
plot(segment_centers * 1e6, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
xlabel('Time (μs)');
ylabel('Velocity (cm/s)');
title('Velocity vs Time');
grid on;

% Plot histogram
subplot(2, 2, 4);
histogram(velocities * 100, 30, 'EdgeColor', 'black', 'FaceAlpha', 0.7);
hold on;
xline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
xlabel('Velocity (cm/s)');
ylabel('Frequency');
title('Velocity Distribution');
grid on;

sgtitle(sprintf('Q9: Segmented Plug Flow Analysis - Mean Velocity = %.2f cm/s', mean(velocities)*100), ...
        'FontSize', 14, 'FontWeight', 'bold');

% Save figure
saveas(gcf, 'Q9_analysis.png');
fprintf('Plot saved as Q9_analysis.png\n\n');

%% Print first few velocities
fprintf('First 10 segment velocities:\n');
for i = 1:min(10, length(velocities))
    fprintf('  Segment %d: %.2f cm/s at depth %.2f mm\n', ...
            i-1, velocities(i)*100, depths(i)*1000);
end
