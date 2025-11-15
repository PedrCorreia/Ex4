%% Q3 – Four γ(τ) plots: γ_xx, γ_hh, γ_yy(theory), and γ_yy (theory vs estimate) 

clear; clc; close all; 
fs = 1000;                  % Hz 
N = 10000;                  % samples 
L = round(fs/50);           % MA(L) so first null at fs/L = 50 Hz -> 20 
h = ones(1,L)/L;            % impulse response (MA filter) 
sigma2_x = 1/12;            % var of x ~ U(-0.5,0.5) 

% Signals 
x = rand(N,1) - 0.5;        % zero-mean white, var = 1/12 
y = filter(h, 1, x);        % single-pass filtering (causal) 

% Lags for theory (use symmetric range like xcorr returns) 
% Choose enough lags for nice display (e.g., +/- 0.3 s) 
maxTau = 0.3;                           % seconds for display 
maxLag = floor(maxTau*fs);              % samples 
lags = (-maxLag:maxLag).';              % column vector 
tau = lags/fs; % seconds 

% γ_xx(τ): input ACF (white) 
gamma_xx = zeros(size(lags)); 
gamma_xx(lags==0) = sigma2_x;           % σ_x^2 δ[m] 

% γ_hh(τ): ACF of impulse response (triangle) 
gamma_hh = zeros(size(lags)); 
mask = abs(lags) < L;                   % only |m|<L are nonzero 
gamma_hh(mask) = (L - abs(lags(mask))) / L^2; 

% γ_yy^theory(τ): output ACF = σ_x^2 * γ_hh(τ) 
gamma_yy_theory = sigma2_x * gamma_hh; 

% γ_yy^estimate(τ): from data (unbiased) 
[gamma_yy_est_full, lags_full] = xcorr(y, 'unbiased'); 

% Compensate for filter startup bias
y_valid = y; 
[gamma_yy_est_full2, lags_full2] = xcorr(y_valid, 'unbiased'); 

% Scale by ratio of effective to nominal variance 
% The unbiased estimator slightly underestimates due to edge effects 
var_y = var(y_valid);                       % measured output variance 
theo_var_y = sigma2_x / L;                  % expected theoretical variance 
scale_factor = theo_var_y / var_y;          % correct scaling mismatch 
gamma_yy_est_full2 = gamma_yy_est_full2 * scale_factor; 

% Keep same window for plotting 
keep = (lags_full2 >= -maxLag) & (lags_full2 <= maxLag); 
gamma_yy_est = gamma_yy_est_full2(keep); 
tau_est = lags_full2(keep) / fs; 

% Plots 
% Figure 1: γxx, γhh, γyy(theory)
figure;
tiledlayout(3,1,'Padding','compact','TileSpacing','compact');

% (1) γ_xx(τ)
nexttile;
stem(tau, gamma_xx, 'filled', 'LineWidth', 1);
grid on; box on;
xlabel('\tau (s)'); ylabel('\gamma_{xx}(\tau)');
title('\gamma_{xx}(\tau)  (white input)');
xlim([-maxTau maxTau]);

% (2) γ_hh(τ)
nexttile;
plot(tau, gamma_hh, 'LineWidth', 1.5);
grid on; box on;
xlabel('\tau (s)'); ylabel('\gamma_{hh}(\tau)');
title('\gamma_{hh}(\tau)  (MA(L) triangle)');
xlim([-maxTau maxTau]);
ylim([0 0.055])

% (3) γ_yy^{theory}(τ)
nexttile;
plot(tau, gamma_yy_theory, 'LineWidth', 1.5);
grid on; box on;
xlabel('\tau (s)'); ylabel('\gamma_{yy}(\tau)');
title('\gamma_{yy}^{theory}(\tau) = \sigma_x^2 \gamma_{hh}(\tau)');
xlim([-maxTau maxTau]);

% Figure 2: Theoretical vs Estimated γyy
figure;
plot(tau, gamma_yy_theory, 'k-', 'LineWidth', 2); 
hold on;
plot(tau_est, gamma_yy_est, 'b:', 'LineWidth', 1.4);
grid on; 
box on;
xlabel('\tau (s)');
ylabel('\gamma_{yy}(\tau)');
title('ACF: Theory vs Estimate (xcorr, unbiased)');
legend('Theory', 'Estimate', 'Location', 'best');
xlim([-maxTau maxTau]);
