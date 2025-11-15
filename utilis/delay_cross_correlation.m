function [cross_correlation, lags] = delay_cross_correlation(sig1, delayed_sig1)
% DELAY_CROSS_CORRELATION Compute and plot cross-correlation between two signals.
%
%   [cross_correlation, lags] = DELAY_CROSS_CORRELATION(sig1, delayed_sig1)
%   computes the cross-correlation sequence between the input signal
%   sig1 and its delayed version delayed_sig1. The function returns the
%   correlation values and the corresponding lag indices. A plot of the
%   cross-correlation function is also generated for visual inspection of
%   the alignment between the two signals.
%
%   INPUTS:
%       sig1          - Original input signal (vector)
%       delayed_sig1  - Time-delayed version of the input signal (vector)
%
%   OUTPUTS:
%       cross_correlation - Cross-correlation values between SIG1 and
%                           DELAYED_SIG1.
%       lags              - Vector of lag indices corresponding to the
%                           cross-correlation values.

    % Cross-correlate the signal and delayed signal
    [cross_correlation, lags] = xcorr(sig1, delayed_sig1);

    % Plot the outcome
    plot(lags, cross_correlation, LineWidth=1.5)
    xlabel('Lag')
    ylabel('Correlation Amplitude')
    title('Cross-Correlation Between the Convolved Signal and Delayed Signal')
    grid on
    xlim([-length(delayed_sig1), length(delayed_sig1)])
end
