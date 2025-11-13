% Q10: Carotid Artery Blood Velocity Analysis
% 
% This script applies segmented velocity estimation to carotid artery
% ultrasound data and plots the velocity profile as a function of depth.

% Add utilities to path
addpath('../../utilis');

clear; close all; clc;

%% Load the data
fprintf('========================================\n');
fprintf('CAROTID ARTERY BLOOD VELOCITY ANALYSIS\n');
fprintf('========================================\n\n');
fprintf('Loading carotis.mat...\n');
load('data/carotis.mat');

%% Parameters
fs = 100e6;                  % Sampling frequency: 100 MHz
T_prf = 200e-6;              % Pulse repetition period: 200 microseconds
c = 1540;                    % Speed of sound: 1540 m/s
segment_duration = 2e-6;     % Segment duration: 2 microseconds

fprintf('Data shape: %d samples x %d lines\n', size(data, 1), size(data, 2));
fprintf('\nAcquisition parameters:\n');
fprintf('  Sampling frequency: %.0f MHz\n', fs/1e6);
fprintf('  Pulse repetition period: %.0f μs\n', T_prf*1e6);
fprintf('  Speed of sound: %.0f m/s\n', c);
fprintf('\nSegmentation parameters:\n');
fprintf('  Segment duration: %.0f μs\n', segment_duration*1e6);
fprintf('  Segment size: %d samples\n\n', round(segment_duration*fs));

%% Estimate velocities for segments
% Copy the function here or ensure it's in the path
[velocities, segment_centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration);

fprintf('Number of segments: %d\n\n', length(velocities));
fprintf('Velocity statistics:\n');
fprintf('  Mean:   %.4f m/s (%.2f cm/s)\n', mean(velocities), mean(velocities)*100);
fprintf('  Median: %.4f m/s (%.2f cm/s)\n', median(velocities), median(velocities)*100);
fprintf('  Std:    %.4f m/s (%.2f cm/s)\n', std(velocities), std(velocities)*100);
fprintf('  Min:    %.4f m/s (%.2f cm/s)\n', min(velocities), min(velocities)*100);
fprintf('  Max:    %.4f m/s (%.2f cm/s)\n\n', max(velocities), max(velocities)*100);
fprintf('Depth range: %.2f mm to %.2f mm\n', depths(1)*1000, depths(end)*1000);
fprintf('Total depth: %.2f mm\n\n', (depths(end) - depths(1))*1000);

%% Main Visualization
figure('Position', [100, 100, 1600, 1000]);

% Main plot: Velocity vs Depth
subplot(2, 3, [1 4]);
plot(depths * 1000, velocities * 100, 'b-o', 'LineWidth', 2, 'MarkerSize', 5);
hold on;
yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
yline(0, 'k-', 'LineWidth', 0.5);
% Fill area under curve
area(depths * 1000, velocities * 100, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
xlabel('Depth (mm)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Blood Velocity (cm/s)', 'FontSize', 12, 'FontWeight', 'bold');
title('Carotid Artery Velocity Profile vs Depth', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
legend('Velocity profile', 'Mean velocity', 'Location', 'best');

% Velocity vs Segment Number
subplot(2, 3, 2);
plot(0:length(velocities)-1, velocities * 100, 'g-o', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(mean(velocities)*100, 'r--', 'LineWidth', 2);
xlabel('Segment Number', 'FontSize', 11);
ylabel('Velocity (cm/s)', 'FontSize', 11);
title('Velocity vs Segment Number', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

% Velocity vs Time
subplot(2, 3, 3);
plot(segment_centers * 1e6, velocities * 100, 'm-o', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
yline(mean(velocities)*100, 'r--', 'LineWidth', 2);
xlabel('Time (μs)', 'FontSize', 11);
ylabel('Velocity (cm/s)', 'FontSize', 11);
title('Velocity vs Time', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

% Histogram
subplot(2, 3, 5);
histogram(velocities * 100, 40, 'EdgeColor', 'black', 'FaceAlpha', 0.7, 'FaceColor', [0.3 0.7 0.9]);
hold on;
xline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
xline(median(velocities)*100, 'g--', sprintf('Median: %.2f', median(velocities)*100), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'top');
xlabel('Velocity (cm/s)', 'FontSize', 11);
ylabel('Frequency', 'FontSize', 11);
title('Velocity Distribution', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

% RF data visualization
subplot(2, 3, 6);
imagesc(1:size(data, 2), (1:size(data, 1))/fs*1e6, data);
colormap(gray);
xlabel('Line Number', 'FontSize', 11);
ylabel('Time (μs)', 'FontSize', 11);
title('Raw RF Data', 'FontSize', 12, 'FontWeight', 'bold');
colorbar;

sgtitle(sprintf('Q10: Carotid Artery Analysis - Mean Velocity = %.2f cm/s', mean(velocities)*100), ...
        'FontSize', 16, 'FontWeight', 'bold');

% Save figure
saveas(gcf, 'Q10_carotid_analysis.png');
fprintf('Plot saved as Q10_carotid_analysis.png\n\n');

%% Detailed Velocity Profile Plot
figure('Position', [150, 150, 1200, 600]);

% Calculate moving average for smoothing
window_size = 5;
if length(velocities) >= window_size
    velocities_smooth = movmean(velocities, window_size);
    plot(depths * 1000, velocities_smooth * 100, 'r-', 'LineWidth', 3, 'DisplayName', 'Smoothed velocity');
    hold on;
end

plot(depths * 1000, velocities * 100, 'b.', 'MarkerSize', 8, 'DisplayName', 'Measured velocity');
yline(0, 'k-', 'LineWidth', 1);
area(depths * 1000, velocities * 100, 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', '');

xlabel('Depth (mm)', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Blood Velocity (cm/s)', 'FontSize', 13, 'FontWeight', 'bold');
title('Carotid Artery - Detailed Velocity Profile', 'FontSize', 15, 'FontWeight', 'bold');
grid on;
legend('Location', 'best', 'FontSize', 11);

% Save figure
saveas(gcf, 'Q10_detailed_profile.png');
fprintf('Detailed plot saved as Q10_detailed_profile.png\n\n');

%% Print detailed segment information
fprintf('========================================\n');
fprintf('DETAILED SEGMENT INFORMATION\n');
fprintf('========================================\n\n');
fprintf('%-5s %-12s %-12s %-15s\n', 'Seg', 'Depth (mm)', 'Time (μs)', 'Velocity (cm/s)');
fprintf('------------------------------------------------------------\n');

% Print every 5th segment to avoid clutter
step = max(1, floor(length(velocities) / 20));
for i = 1:step:length(velocities)
    fprintf('%-5d %10.2f  %10.2f  %13.2f\n', ...
            i-1, depths(i)*1000, segment_centers(i)*1e6, velocities(i)*100);
end

%% Analyze velocity changes
fprintf('\n========================================\n');
fprintf('VELOCITY PROFILE ANALYSIS\n');
fprintf('========================================\n\n');

% Find peak velocity
[max_vel, max_idx] = max(abs(velocities));
fprintf('Peak velocity:\n');
fprintf('  Value: %.2f cm/s\n', velocities(max_idx)*100);
fprintf('  At depth: %.2f mm\n', depths(max_idx)*1000);
fprintf('  At segment: %d\n\n', max_idx-1);

% Analyze velocity gradient
velocity_gradient = gradient(velocities * 100, depths * 1000);
fprintf('Velocity gradient statistics:\n');
fprintf('  Mean gradient: %.2f (cm/s)/mm\n', mean(velocity_gradient));
fprintf('  Max gradient: %.2f (cm/s)/mm\n', max(velocity_gradient));
fprintf('  Min gradient: %.2f (cm/s)/mm\n\n', min(velocity_gradient));

fprintf('========================================\n');
fprintf('Analysis complete!\n');
fprintf('========================================\n');
