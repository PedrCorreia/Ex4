function velocity = estimate_velocity_averaged(data, T_prf, c, fs)
% ESTIMATE_VELOCITY_AVERAGED Estimate blood velocity using averaged cross-correlation
% Syntax:
%   velocity = estimate_velocity_averaged(data, T_prf, c, fs)
% Inputs:
%   data    - Matrix of ultrasound data (n_samples x n_lines)
%   T_prf   - Pulse repetition period in seconds
%   c       - Speed of sound in m/s (1540 m/s for human tissue)
%   fs      - Sampling frequency in Hz
% Output:
%   velocity - Estimated blood velocity in m/s

    [n_samples, n_lines] = size(data);
    correlations = [];
    % Cross-correlate consecutive lines
    for i = 1:(n_lines - 1)
        signal1 = data(:, i);
        signal2 = data(:, i + 1);
        [corr, lags] = xcorr(signal1, signal2);
        correlations = [correlations; corr'];
    end
    
    avg_correlation = mean(correlations, 1);
    [~, max_idx] = max(avg_correlation);
    delay_samples = lags(max_idx);
    t_s = delay_samples / fs;
    
    velocity = (t_s * c) / (2 * T_prf);
end
