function [rf_data, params, rf_long] = simulate_ultrasound_data(vz, Ntrials)
% SIMULATE_ULTRASOUND_DATA Generate simulated ultrasound RF data with motion
% Syntax:
%   [rf_data, params] = simulate_ultrasound_data(vz, Ntrials)
% Inputs:
%   vz       - Blood velocity in m/s
%   Ntrials  - Number of lines to generate
% Outputs:
%   rf_data  - Simulated RF data (n_samples x Ntrials)
%   params   - Structure containing all simulation parameters

    %  parameters from the  Jørgen Arendt Jensen book
    f0 = 3.0e6;        % Center frequency (Hz)
    M = 4;             % Sine periods in pulse
    fs = 96e6;         % Sampling frequency (Hz)
    c = 1540;          % Speed of sound (m/s)
    fprf = 5e3;        % PRF (Hz)
    lg = 1e-3;         % Range gate length (m)
    Nc = 8;            % Lines for one estimate
    
    % derived parameters
    T_prf = 1 / fprf;                        % Pulse repetition period (s)
    lambda = c / f0;                         % Wavelength (m)
    
    % number of samples in range gate (final output)
    n_samples = round(2 * lg * fs / c);
    
    % generate longer signal to avoid circular wrapping
    total_duration = 1;  % 1 seconds total
    n_total_samples = round(total_duration * fs);
    
    % window within the longer signal (centered)
    window_start_sample = round(n_total_samples / 4);  % Start at 25% of total
    window_end_sample = window_start_sample + n_samples - 1;
    t = (0:n_samples-1)' / fs;
    
    % transducer pulse (Gaussian-modulated sinusoid)
    pulse_duration = M / f0;
    pulse_samples = round(pulse_duration * fs);
    t_pulse = (0:pulse_samples-1)' / fs;
    
        % gaussian envelope
        sigma = pulse_duration / 4;
        t_center = pulse_duration / 2;
        envelope = exp(-((t_pulse - t_center).^2) / (2 * sigma^2));
    
        % pulse-echo impulse response
        pulse = envelope .* sin(2 * pi * f0 * t_pulse);
        pulse = pulse / max(abs(pulse));  % Normalize

    % Time shift = 2 * vz * T_prf / c
    time_shift_per_line = 2 * vz * T_prf / c;
    sample_shift_per_line = time_shift_per_line * fs;
    
    % Initialize output RF data
    rf_data = zeros(n_samples, Ntrials);
    
    % step 1: generate base scattering signal 
    scatterers = randn(n_total_samples, 1);
    % step 2: convolve with pulse-echo impulse response
    rf_base = conv(scatterers, pulse, 'same');
    % step 3: generate RF data for each line using circshift
    for line_idx = 1:Ntrials
        shift_samples = round(sample_shift_per_line * (line_idx - 1));
        rf_shifted = circshift(rf_base, shift_samples);
        rf_data(:, line_idx) = rf_shifted(window_start_sample : window_start_sample + n_samples - 1);
    end
    
    % Store parameters in output structure
    params.vz = vz;
    params.Ntrials = Ntrials;
    params.f0 = f0;
    params.M = M;
    params.fs = fs;
    params.c = c;
    params.fprf = fprf;
    params.T_prf = T_prf;
    params.lg = lg;
    params.Nc = Nc;
    params.lambda = lambda;
    params.n_samples = n_samples;
    params.n_total_samples = n_total_samples;
    params.window_start_sample = window_start_sample;
    params.sample_shift_per_line = sample_shift_per_line;
    params.time_shift_per_line = time_shift_per_line;
    params.pulse = pulse;
    params.t = t;
    params.scatterers = scatterers;
    % Return the long (pre-window) RF base so callers can reuse it
    rf_long = rf_base;
end
