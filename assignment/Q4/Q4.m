%% Q4
% Download the ultrasound signal from DTULearn (ult_sig2.mat). Load the file into Matlab with
% load <file_name> or into Python with scipy.io.loadmat(<file_name>). Find the probability density 
% of this signal ult_sig2 and compare it to a Gaussian distribution with the mean value estimated 
% from the signal using the Matlab procedure mean (np.mean in Python) and the
% standard deviation determined by the Matlab procedure std (np.std in Python)
close all; clear; clc;

%%

close all;
load("ult_sig2.mat");

x = ult_sig2(:);
N = length(x);

mean_ult = mean(x);
std_ult = std(x);

% Number of bins 
nbins = 100;

% Define range (handles positive and negative)
xmin = -abs(max(x));
xmax = abs(max(x));

axis_x = linspace(-abs(max(x)), abs(max(x)), nbins);
% Compute bin edges and width
edges = linspace(xmin, xmax, nbins+1);
dx = edges(2) - edges(1);

% Count number of points in each bin
counts = histcounts(x, edges);

% Convert to probability density
pdf_vals = counts / (N * dx);

% Plot
figure;
bar(axis_x, pdf_vals, 1, 'EdgeColor', 'k', 'FaceColor', [0.3 0.6 0.9])
grid on
xlabel('Ultrasound Value (Hz)', FontSize=22)
ylabel('Probability Density', FontSize=22)
title('Probability Density Function of Ultrasound', FontSize=24)
xlim([-abs(max(x)) abs(max(x))])

hold on;

% Make the PDF from the parmeters
x = linspace(min(ult_sig2), max(ult_sig2), length(ult_sig2));
pdf_rep = normpdf (x, mean_ult, std_ult);

plot(x,pdf_rep, LineWidth=2)