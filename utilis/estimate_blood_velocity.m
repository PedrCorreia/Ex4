function velocity = estimate_blood_velocity(signal1, signal2, T_prf, c, fs)
% ESTIMATE_BLOOD_VELOCITY Estimate blood velocity from two ultrasound signals
% Syntax:
%   velocity = estimate_blood_velocity(signal1, signal2, T_prf, c, fs)
% Inputs:
%   signal1 - First ultrasound signal (column or row vector)
%   signal2 - Second ultrasound signal (column or row vector)
%   T_prf   - Pulse repetition period in seconds (time between measurements)
%   c       - Speed of sound in m/s (1540 m/s for human tissue)
%   fs      - Sampling frequency in Hz
% Output:
%   velocity - Estimated blood velocity in m/s

    [correlation, lags] = xcorr(signal1, signal2);
    [~, max_idx] = max(correlation);
    delay_samples = lags(max_idx);
    t_s = delay_samples / fs;
    velocity = (t_s * c) / (2 * T_prf);
    
end
