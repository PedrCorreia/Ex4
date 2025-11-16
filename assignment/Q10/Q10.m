% Q10: Carotid Artery Blood Velocity Analysis
% 
% This script applies segmented velocity estimation to carotid artery
% ultrasound data and plots the velocity profile as a function of depth.


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
[velocities, segment_centers] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration);

fprintf('Number of segments: %d\n\n', length(velocities));
fprintf('Velocity statistics:\n');
fprintf('  Mean:   %.4f m/s (%.2f cm/s)\n', mean(velocities), mean(velocities)*100);
fprintf('  Median: %.4f m/s (%.2f cm/s)\n', median(velocities), median(velocities)*100);
fprintf('  Std:    %.4f m/s (%.2f cm/s)\n', std(velocities), std(velocities)*100);
fprintf('  Min:    %.4f m/s (%.2f cm/s)\n', min(velocities), min(velocities)*100);
fprintf('  Max:    %.4f m/s (%.2f cm/s)\n\n', max(velocities), max(velocities)*100);

% Calculate depths from segment centers
depths = segment_centers * c / 2;
fprintf('Depth range: %.2f mm to %.2f mm\n', depths(1)*1000, depths(end)*1000);
fprintf('Total depth: %.2f mm\n\n', (depths(end) - depths(1))*1000);

%% Visualization - three square figures
% Figure 1: Velocity vs Depth
fig1 = figure('Position', [100, 100, 800, 800]);
plot(depths * 1000, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 6, ...
     'MarkerFaceColor', [0 0.4470 0.7410]);
hold on;
hp1 = yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
set(hp1, 'HandleVisibility', 'off');
xlabel('Depth (mm)');
ylabel('Velocity (cm/s)');
title('Q10: Velocity vs Depth');
grid on;
saveas(fig1, 'Q10_velocity_depth.png');
fprintf('Saved: Q10_velocity_depth.png\n');

% Figure 2: Velocity vs Time (2 µs intervals)
fig2 = figure('Position', [150, 150, 800, 800]);
plot(segment_centers * 1e6, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 6, ...
     'MarkerFaceColor', [0 0.4470 0.7410]);
hold on;
hp2 = yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
set(hp2, 'HandleVisibility', 'off');
xlabel('Time (µs)');
ylabel('Velocity (cm/s)');
title('Q10: Velocity vs Time (2 µs intervals)');
grid on;
saveas(fig2, 'Q10_velocity_time.png');
fprintf('Saved: Q10_velocity_time.png\n');

% Figure 3: Color Flow Map
fig3 = figure('Position', [200, 200, 800, 800]);
n_lines = size(data, 2);
n_segments = length(velocities);
% Create velocity map: rows = segments (depth), columns = lines
velocity_map = repmat(velocities * 100, 1, n_lines);
imagesc(1:n_lines, depths * 1000, velocity_map);
colormap(jet);
cb = colorbar;
ylabel(cb, 'Velocity (cm/s)');
xlabel('Line Number');
ylabel('Depth (mm)');
title('Q10: Color Flow Map');
axis xy;
saveas(fig3, 'Q10_color_flow_map.png');
fprintf('Saved: Q10_color_flow_map.png\n\n');
