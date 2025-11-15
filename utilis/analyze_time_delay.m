function [time_delayed, nr_delays, corr_max, x] = analyze_time_delay(corr, fs)
% ANALYZE_TIME_DELAY Computes and prints timing information from a correlation signal
%
%   [time_delayed, nr_delays, corr_max, x] = ANALYZE_TIME_DELAY(corr, fs)
%
%   Inputs:
%       corr  - Cross-correlation vector between two signals
%       fs    - Sampling frequency (Hz)
%
%   Outputs:
%       time_delayed - Estimated time delay between the signals (seconds)
%       nr_delays    - Number of sample delays
%       corr_max     - Maximum absolute correlation value
%       x            - Index at which the maximum correlation occurs
%
%   This function finds the position of maximum correlation, determines how
%   far this is from the center of the correlation sequence, converts the
%   delay into time, and prints a formatted summary table.

    % Find where the highest correlation is located
    corr_max = max(abs(corr));
    x = find(abs(corr) == corr_max, 1);   % Only first index if ties

    % Length of the correlation signal midpoint
    longer_M = (length(corr) + 1) / 2;

    % Number of sample delays from the midpoint
    nr_delays = longer_M - x;

    % Convert to time delay
    time_delayed = nr_delays / fs;

    % ---- Pretty Printed Table ----
    fprintf('\n=========== Time Delay Analysis ===========\n');
    fprintf('Maximum correlation value:        %.2f\n', corr_max);
    fprintf('Index of max correlation:         %d\n', x);
    fprintf('Signal midpoint index:            %d\n', longer_M);
    fprintf('Number of sample delays:          %d samples\n', nr_delays);
    fprintf('Time delay:                       %.3e s\n', time_delayed);
    fprintf('===========================================\n\n');
end