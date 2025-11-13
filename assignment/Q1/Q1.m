%% Q1: Random signal, time plot, PDF estimate, and comparison to theory

% Parameters
N  = 10000;       % number of samples
fs = 1000;        % Hz
t  = (0:N-1)/fs;  % seconds

% Random signal ~ Uniform(0,1)
x = rand(N,1);

% Time-domain plot
figure;
plot(t, x, 'LineWidth', 1);
xlabel('t(s)');
ylabel('Amplitude');
title('Random Signal');
ylim([-0.1 1.1])
grid on;

% Estimate PDF with 100 bins and plot
nbins = 100;
[binCenters, pdf_est, binWidth] = estimate_pdf_plot(x, nbins); 

% Theoretical Uniform(0,1) PDF
hold on;
x_theory = [min(x)-0.1, 0, 0, 1, 1, max(x)+0.1];
y_theory = [0, 0, 1, 1, 0, 0];
plot(x_theory, y_theory, 'r-', 'LineWidth', 1.6);
legend('Estimated PDF','Theoretical Uniform(0,1)','Location','best');
title(sprintf('Estimated PDF (bin width = %.4g) vs Theoretical', binWidth));
grid on;

%% Function for estimating the probability density for the signal amplitude
function [centers, density, binWidth] = estimate_pdf_plot(x, nbins)
%estimate_pdf_plot Estimate and plot the probability density of a signal.
%   [centers, density, binWidth] = estimate_pdf_plot(x, nbins)
%   builds a histogram-based PDF estimate (area = 1) using nbins bins and
%   plots it as a bar chart.
%
%   Inputs:
%     x      - column vector of samples (double)
%     nbins  - number of amplitude bins (positive integer, default 100)
%
%   Outputs:
%     centers  - bin centers (1 x nbins)
%     density  - estimated probability density at each center (1 x nbins)
%     binWidth - scalar bin width (difference between consecutive edges)

    % Validate input arguments and set defaults
    arguments
        % Input signal: column vector of doubles
        x (:,1) double
        % Number of bins (positive integer, default=100)
        nbins (1,1) {mustBeInteger,mustBePositive} = 100
    end

    N = numel(x);       % Total number of samples
    xmin = min(x);      % Minimum amplitude
    xmax = max(x);      % Maximum amplitude
    if xmax == xmin
        error('All samples are identical; cannot estimate a density.');
    end

    % Bin edges
    % If data looks like Uniform(0,1), force exact [0,1] edges
    if all(x >= 0) && all(x <= 1)
        edges = linspace(0, 1, nbins+1);
    else
        % General case: cover the observed range
        edges = linspace(xmin, xmax, nbins+1);
    end

    % Histogram counts and PDF scaling
    counts   = histcounts(x, edges);        % counts per bin
    binWidth = edges(2) - edges(1);         % uniform bin width
    density  = counts / (N * binWidth);     % PDF: area ≈ 1
    centers  = (edges(1:end-1) + edges(2:end)) / 2;

    % Plot bar chart
    figure;
    bar(centers, density, 1, ...            % full bin width bars
        'EdgeColor', [0.2 0.2 0.2], ...
        'FaceColor', [0.2 0.45 0.85], ...
        'LineWidth', 0.5);
    grid on; box on;
    xlabel('Amplitude of x');
    ylabel('pdf(x)');
    title('Probability Density Function');

    % Axes
    xlim([edges(1) edges(end)]);
    if all(x >= 0) && all(x <= 1)
        xlim([-0.1 1.1]);
        ylim([0 1.4]);
    end
end
