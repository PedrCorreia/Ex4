%% Q3 – Four γ(τ) plots: γ_xx, γ_hh, γ_yy(theory), and γ_yy (theory vs estimate)
clear; clc; close all;

fs = 1000;                    % Hz
N  = 10000;                   % samples
L  = round(fs/50);            % MA(L) so first null at fs/L = 50 Hz -> 20
h  = ones(1,L)/L;             % impulse response (MA filter)
sigma2_x = 1/12;              % var of x ~ U(-0.5,0.5)

% Signals
x = rand(N,1) - 0.5;          % zero-mean white, var = 1/12
y = filter(h, 1, x);          % single-pass filtering (causal)

% Lags for theory (use symmetric range like xcorr returns)
% Choose enough lags for nice display (e.g., +/- 0.3 s)
maxTau = 0.3;                               % seconds for display
maxLag = floor(maxTau*fs);                  % samples
lags   = (-maxLag:maxLag).';                % column vector
tau    = lags/fs;                           % seconds

% γ_xx(τ): input ACF (white)
gamma_xx = zeros(size(lags));
gamma_xx(lags==0) = sigma2_x;               % σ_x^2 δ[m]

% γ_hh(τ): ACF of impulse response (triangle)
gamma_hh = zeros(size(lags));
mask = abs(lags) < L;                       % only |m|<L are nonzero
gamma_hh(mask) = (L - abs(lags(mask))) / L^2;

% γ_yy^theory(τ): output ACF = σ_x^2 * γ_hh(τ)
gamma_yy_theory = sigma2_x * gamma_hh;

% γ_yy^estimate(τ): from data (unbiased)
[gamma_yy_est_full, lags_full] = xcorr(y, 'unbiased');  % full-length
% Keep only the window we want for display:
keep = (lags_full >= -maxLag) & (lags_full <= maxLag);
gamma_yy_est = gamma_yy_est_full(keep);
tau_est      = lags_full(keep) / fs;

% Plots

figure;
tiledlayout(2,3,'Padding','compact','TileSpacing','compact');

% Top-left: γ_xx(τ)
nexttile([1 1]);
stem(tau, gamma_xx, 'filled', 'LineWidth', 1); 
hold on; 
grid on; 
box on;
xlim([-maxTau maxTau]);
xlabel('\tau (in secs)'); 
ylabel('\gamma_{xx}(\tau)');
title('\gamma_{xx}(\tau)  (white input)');

% Top-middle: γ_hh(τ)
nexttile([1 1]);
plot(tau, gamma_hh, 'LineWidth', 1.5); 
grid on; 
box on;
xlim([-maxTau maxTau]);
xlabel('\tau (in secs)'); 
ylabel('\gamma_{hh}(\tau)');
title('\gamma_{hh}(\tau)  (MA(L) triangle)');

% Top-right: γ_yy^{theory}(τ)
nexttile([1 1]);
plot(tau, gamma_yy_theory, 'LineWidth', 1.5); 
grid on; 
box on;
xlim([-maxTau maxTau]);
xlabel('\tau (in secs)'); 
ylabel('\gamma_{yy}(\tau)');
title('\gamma_{yy}(\tau) = \sigma_x^2 \gamma_{hh}(\tau)');

% Bottom: overlay theory vs estimate for γ_yy(τ)
nexttile([1 3]);
plot(tau, gamma_yy_theory, 'k-', 'LineWidth', 2); 
hold on;
plot(tau_est, gamma_yy_est, 'b:', 'LineWidth', 1.4);
grid on; 
box on;
xlabel('\tau (in secs)'); 
ylabel('\gamma_{yy}(\tau)');
title('ACF: Theory vs Estimate (xcorr, unbiased)');
legend('Theory', 'Estimate', 'Location', 'best');
xlim([-maxTau maxTau]);

% Optional: tighten y-limits around main lobe for clarity
% ylim([min(gamma_yy_est)*1.1, max(gamma_yy_theory)*1.1]);
