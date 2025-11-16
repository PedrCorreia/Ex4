% Q9: Segmented Blood Velocity Estimation from Plug Flow Data

%% load the data
fprintf('Loading plug_flow.mat...\n');
load('plug_flow.mat');

%% parameters
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

%% estimate velocities for segments
[velocities, segment_centers] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration);

fprintf('Number of segments: %d\n\n', length(velocities));
fprintf('Velocity statistics:\n');
fprintf('  Mean:   %.4f m/s (%.2f cm/s)\n', mean(velocities), mean(velocities)*100);
fprintf('  Std:    %.4f m/s (%.2f cm/s)\n', std(velocities), std(velocities)*100);
fprintf('  Min:    %.4f m/s (%.2f cm/s)\n', min(velocities), min(velocities)*100);
fprintf('  Max:    %.4f m/s (%.2f cm/s)\n\n', max(velocities), max(velocities)*100);

%% visualization
% Figure 1: Velocity vs Segment Number
fig1 = figure('Position', [100, 100, 800, 800]);
plot(0:length(velocities)-1, velocities * 100, 'o-', 'LineWidth', 2, 'MarkerSize', 6, ...
     'MarkerFaceColor', [0 0.4470 0.7410]);
hold on;
hp1 = yline(mean(velocities)*100, 'r--', sprintf('Mean: %.2f cm/s', mean(velocities)*100), ...
      'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
set(hp1, 'HandleVisibility', 'off');
xlabel('Segment Number');
ylabel('Velocity (cm/s)');
title('Q9: Velocity vs Segment Number');
grid on;
saveas(fig1, 'Q9_velocity_segments.png');
fprintf('Saved: Q9_velocity_segments.png\n\n');

%%  velocities
fprintf('First 10 segment velocities:\n');
for i = 1:length(velocities)
    fprintf('  Segment %d: %.2f cm/s\n', i-1, velocities(i)*100);
end
