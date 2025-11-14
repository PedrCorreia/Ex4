%% Q5
% Plot the signal. Is it possible to see the sinusoidal signal?
% Make a loop that adds 100 realizations of g and divide the resulting signal by 100. 
% Plot this new signal and compare it to the first g. 
% The last term in the signal is Gaussian noise added to the sinusoid. 
% Is this noise correlated with the signal? 
% Why does this procedure for getting a better signal-to-noise ratio work?
close all; clear; clc;

% Parameters
f0=6; %Hz  
fs=1000; %Hz
Ts = 1/fs;

% Given Sinusoid
g = sin (2*pi*f0*(0:2000)/fs) + 2*randn(1,2001); %in Matlab
axis = 0:Ts:(length(g)-1)*Ts;

plot(axis,g, LineWidth=1.5)
grid on
ylabel('Sinusoid g(t)', FontSize=22)
xlabel('Time (s)', FontSize=22)
title('Sinusoid from Parameters', FontSize=24)


%%
close all; clc;

% Make 100 realisations on the g(t)
g_100_real = g;
teljari = 0;
for k = 1:100
        temp_g = sin (2*pi*f0*(0:2000)/fs) + 2*randn(1,2001);
        g_100_real(1,:) = g_100_real(1,:) + temp_g; %in Matlab
    teljari = teljari +1
end

% divide the realised sinusoid
g_100_real = g_100_real/100;

figure
plot(axis,g_100_real, LineWidth=1.5)
grid on
ylabel('Sinusoid g(t)', FontSize=22)
xlabel('Time (s)', FontSize=22)
title('Sinusoid after 100 realisations', FontSize=24)