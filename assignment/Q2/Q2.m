%% Q2: Mean removal, rectangular low pass filter with first null at 50 Hz, and PDF analysis
clear; clc; close all;

fs = 1000;          % Hz
N  = 10000;
t  = (0:N-1)/fs;
x  = rand(N,1);     % Uniform(0,1)

% Subtract theoretical mean
x0 = x - 0.5;       % mean of U(0,1) is 0.5 -> now mean ~ 0

% Rectangular low pass filter (moving average (MA)) with first null at 50 Hz
% First null of MA(L) is fs/L -> choose L = fs/50 = 20
L = round(fs/50);     % choose L so first null is at fs/L = 50 Hz
b = ones(1, L) / L;   % rectangular (moving-average) impulse response
a = 1;

% Plot impulse response
n  = 0:L-1;

figure;
stem(n, b, 'filled', 'LineWidth', 1.1); 
hold on;
plot([n(1) n(end)], [1/L 1/L], 'k:', 'LineWidth', 1);   % reference line at 1/L
grid on; 
box on;
xlabel('n'); ylabel('h[n]');
title('Impulse Response');
xlim([0 L]); 
ylim([1/L - 0.0051, 1/L + 0.005]);  % small vertical range around 1/L (≈0.05 for L=20)
yticks([0.045 0.050 0.055]);

% Plot transfer function (magnitude response) of the filter 
% and confirm first null at 50 Hz
% Frequency response (two-sided, centered at 0 Hz)
Nfft = 32768;              % high enough for fine frequency grid
H    = fftshift(fft(b, Nfft));
f    = linspace(-fs/2, fs/2, Nfft);
Hmag = abs(H) / max(abs(H));   % normalize to 1 at DC

figure;
plot(f, Hmag, 'LineWidth', 1.5); 
grid on; 
box on;
xlabel('f(Hz)'); ylabel('|H(f)|');
title('Spectrum');
xlim([-500 500]); ylim([0 1.1]);

% Mark the first nulls at ±fs/L = ±50 Hz
fnull = fs/L;                       % should be 50 Hz
xline( fnull, '--r', '50 Hz', 'LabelVerticalAlignment','bottom');
xline(-fnull, '--r', '-50 Hz', 'LabelVerticalAlignment','bottom'); 


% Causal filtering (introduces delay of (L-1)/2 samples).
y = filter(b, a, x0);

% Plot filtered random signal
figure;
plot(t, y, 'LineWidth', 1.2);
hold on;
grid on; 
box on;
xlim([0 10]);
ylim([-0.25 0.24]);
xlabel('t(s)');
ylabel('Amplitude');
title('Random Signal');

% PDF and plot of the filtered signal
nbins = 100;
[centers, pdf_est, binWidth] = estimate_pdf_plot(y, nbins);
hold on;

% Theoretical Gaussian PDF (CLT approximation: N(0, sigma^2), sigma^2 = (1/12)/L)
sigma = sqrt(1/(12*L));           % variance of average of L Uniform(-0.5,0.5)
ygrid = linspace(-0.5, 0.5, 1000); % cover the same amplitude range
fa_gauss = (1/(sqrt(2*pi)*sigma)) * exp(-0.5*(ygrid/sigma).^2);

% Overlay the Gaussian on the estimated PDF
hold on; % keep the histogram visible
plot(ygrid, fa_gauss, 'r-', 'LineWidth', 2);
xlim([-0.35 0.35]);
ylim([0 7.5])
legend('Estimated PDF', 'Gaussian approx', 'Location', 'best');
grid on;
