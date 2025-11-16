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
title('Probability Density Function');
grid on;
