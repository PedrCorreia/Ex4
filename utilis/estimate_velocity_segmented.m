function [velocities, segment_centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration)
% ESTIMATE_VELOCITY_SEGMENTED Estimate blood velocity for segments of ultrasound data
% Syntax:
%   [velocities, segment_centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration)
% Inputs:
%   data              - Matrix of ultrasound data (n_samples x n_lines)
%   T_prf             - Pulse repetition period in seconds
%   c                 - Speed of sound in m/s (1540 m/s for human tissue)
%   fs                - Sampling frequency in Hz
%   segment_duration  - Duration of each segment in seconds
% Outputs:
%   velocities        - Array of estimated velocities for each segment (m/s)
%   segment_centers   - Time positions of segment centers (seconds)
%   depths            - Depth positions of segment centers (meters)

    [n_samples, n_lines] = size(data);
    segment_size = round(segment_duration * fs);
    n_segments = floor(n_samples / segment_size);

    velocities = zeros(n_segments, 1);
    segment_centers = zeros(n_segments, 1);
    depths = zeros(n_segments, 1);
    
    % Process each segment
    for seg_idx = 1:n_segments
        start_idx = (seg_idx - 1) * segment_size + 1;
        end_idx = start_idx + segment_size - 1;
        segment_data = data(start_idx:end_idx, :);
        
        center_sample = (start_idx + end_idx) / 2;
        center_time = center_sample / fs;
        segment_centers(seg_idx) = center_time;
        depths(seg_idx) = center_time * c / 2;
        
        correlations = [];
        for i = 1:(n_lines - 1)
            signal1 = segment_data(:, i);
            signal2 = segment_data(:, i + 1);
            [corr, lags] = xcorr(signal2, signal1);
            correlations = [correlations; corr'];
        end
        
        avg_correlation = mean(correlations, 1);
        [~, max_idx] = max(avg_correlation);
        delay_samples = lags(max_idx);
        t_s = delay_samples / fs;
        velocities(seg_idx) = (t_s * c) / (2 * T_prf);
    end
end
