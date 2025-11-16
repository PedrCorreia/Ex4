% Q8: Blood Velocity Estimation from Plug Flow Data
% 

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

[n_samples, n_lines] = size(data);
fprintf('Number of samples per line: %d\n', n_samples);
fprintf('Number of lines: %d\n\n', n_lines);

%% Estimate velocity using averaged cross-correlation
velocity = estimate_velocity_averaged(data, T_prf, c, fs);

fprintf('Estimated blood velocity: %.4f m/s\n', velocity);
fprintf('Estimated blood velocity: %.2f cm/s\n\n', velocity*100);

%% Visualization - save each subplot as a separate square image
% Plot first two lines as a square image
fig1 = figure('Position', [100, 100, 800, 800]);
% time axis in seconds
t = (0:n_samples-1) / fs;
plot(t, data(:, 1), 'LineWidth', 1.5);
hold on;
plot(t, data(:, 2), 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Q8: First Two Lines');
legend('Line 1', 'Line 2');
grid on;
saveas(fig1, 'Q8_line12.png');
fprintf('Saved: Q8_line12.png\n');

% Plot all lines as an image 
fig2 = figure('Position', [150, 150, 800, 800]);
% imagesc with time axis (seconds) on y-axis
imagesc(1:n_lines, t, data);
colormap(gray);
xlabel('Line Number');
ylabel('Time (s)');
title('Q8: All Lines (image)');
axis xy; axis image; colorbar;
saveas(fig2, 'Q8_all_lines.png');
fprintf('Saved: Q8_all_lines.png\n');

% averaged cross-correlation
correlations = [];
for i = 1:(n_lines - 1)
    [corr, lags] = xcorr(data(:, i), data(:, i+1));
    correlations = [correlations; corr'];
end
avg_correlation = mean(correlations, 1);
[max_val, max_idx] = max(avg_correlation);
lag_sec = lags / fs; % convert lags to seconds
lag_usec = lags / fs * 1e6; % convert lags to microseconds

% Plot averaged cross-correlation
fig3 = figure('Position', [200, 200, 800, 800]);
plot(lag_usec, avg_correlation, 'LineWidth', 1.5);
hold on;
hp = xline(lag_usec(max_idx), 'r--', sprintf('Max at %.3f µs', lag_usec(max_idx)), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
set(hp, 'HandleVisibility', 'off');
xlabel('Lag (µs)');
ylabel('Cross-correlation');
title('Q8: Averaged Cross-Correlation Function');
grid on;
saveas(fig3, 'Q8_avg_correlation.png');
fprintf('Saved: Q8_avg_correlation.png\n');

% print peak info to console
fprintf('Averaged cross-correlation peak at lag = %d samples (%.6f µs), value = %.6e\n', lags(max_idx), lag_usec(max_idx), max_val);
v_est_from_lag = (lag_sec(max_idx) * c) / (2 * T_prf);
fprintf('Estimated velocity from peak lag: %.6f m/s (%.2f cm/s)\n\n', v_est_from_lag, v_est_from_lag*100);

% Zoomed view around maximum 
fig4 = figure('Position', [250, 250, 800, 800]);
plot(lag_usec, avg_correlation, 'LineWidth', 1.5);
hold on;
hp2 = xline(lag_usec(max_idx), 'r--', sprintf('Max at %.3f µs', lag_usec(max_idx)), ...
      'LineWidth', 2, 'LabelVerticalAlignment', 'bottom');
set(hp2, 'HandleVisibility', 'off');
xlabel('Lag (µs)');
ylabel('Cross-correlation');
title('Q8: Zoomed Cross-Correlation (around maximum)');
grid on;
window_usec = 500 / fs * 1e6;  % convert 500 samples to microseconds
xlim([lag_usec(max_idx) - window_usec, lag_usec(max_idx) + window_usec]);
saveas(fig4, 'Q8_zoom_correlation.png');
fprintf('Saved: Q8_zoom_correlation.png\n');
