clear; clc; close all;
k = 1000;
L = 10;
delta_x = pi/(5*k);
N0 = ceil(L/delta_x);
N0 = 20 * N0; % Need more samples to avoid aliasing
N = 2^(ceil(log2(N0))); % want power of 2 for FFT
x = linspace(0, L, N);

A_fine = 3e-4;
lambda_fine = 1.5e-3;
h_fine = A_fine * (2 * mod(x/lambda_fine,1) -1);

A_coarse = 3e-3;
lambda_coarse = 1.5e-1;
k_coarse = 2*pi / lambda_coarse;
phase_offset = 2*pi*rand();
h_coarse = A_coarse * sin(k_coarse*x + phase_offset);
% now smooth it out
sigma_kernel = lambda_fine / 50;
kx = x - L/2; % Create coordinates centered at 0
gaussian_kernel = exp(-kx.^2 / (2 * (sigma_kernel)^2));
gaussian_kernel = gaussian_kernel/sum(gaussian_kernel); % Normalize kernel so that convolution doesn't change amplitude
gaussian_kernel_shifted = fftshift(gaussian_kernel); % Shift center to first element for FFT
fft_h_fine = fft(h_fine);
fft_kernel = fft(gaussian_kernel_shifted);
fft_smoothed = fft_h_fine .* fft_kernel;
h_fine_smoothed = ifft(fft_smoothed);
h_fine_smoothed = real(h_fine_smoothed); % to take out tiny imaginary parts

sigma_rms = A_coarse / 3;
H = 0.7;
L_c = 5e-2;
exponent = -(2*H+1);
k_min = 0;
k_max = N/L;
k = linspace(k_min, k_max, N);
z = zeros(1, N);

N_long = 4*N;
L_long = 4*L;
k_long = linspace(0,N_long/L_long,N_long);
z_long = zeros(1,N_long);
rng(123);
for(i=2:(N_long/2)+1)
    phase_offset = 2*pi*rand();
    %S = abs(k_long(i))^exponent;
    S = exp(-(k_long(i)*L_c)^2);
    z_long(i) = sqrt(S) * exp(j*phase_offset);
end
for(i=(N_long/2)+2:N_long)
    z_long(i) = conj(z_long(N_long-i+2));
end
h_rand_long = ifft(z_long, 'symmetric');
h_rand_cropped = h_rand_long(N+1:2*N);
%h_rand = real(h_rand); % again, taking out any tiny imaginary parts
h_rand = real(h_rand_cropped); % again, taking out any tiny imaginary parts
h_rand = h_rand - mean(h_rand);
sigma_h = std(h_rand);
h_rand = (sigma_rms/sigma_h) * h_rand;

h_total = h_fine_smoothed + h_coarse + h_rand;

num_plot_points = N;
h_total_plot = h_total(1:num_plot_points);
h_rand_plot = h_rand(1:num_plot_points);
h_det_plot = h_coarse(1:num_plot_points) + h_fine_smoothed(1:num_plot_points);
x_plot = x(1:num_plot_points);

figure(1);
hold on;
%plot(x*1000,h_rand*1000, 'DisplayName', '$h_{\mathrm{defect}}$');
%plot(x*1000,h_fine_smoothed*1000, 'DisplayName', '$h_{\mathrm{fine}}$');
%plot(x*1000,h_fine_smoothed*1000 + h_rand*1000, 'DisplayName', '$h_{\mathrm{fine}} + h_{\mathrm{defect}}$');
h_rand =  0.5 + 0.5.*tanh(1000.*h_rand./2);
sigma_h_rand = std(h_rand);
h_rand = (1e3*sigma_rms/sigma_h_rand).*h_rand;
h_rand = h_rand - mean(h_rand)
plot(x*1000,(h_rand), 'DisplayName', '$h_{\mathrm{defect}}$');
title('Manufacturing Defects [mm]', 'Interpreter','latex', 'FontSize', 16);
subtitle("$l_{\mathrm{corr}} = $" + L_c * 1e3, 'Interpreter','latex', 'FontSize',14);
ylabel('height', 'Interpreter','latex', 'FontSize',14);
xlabel('$x$', 'Interpreter','latex', 'FontSize',14);
ax=gca;
yl = yline(0, 'k--');
yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
yl2=yline(sigma_rms*1000,'k:');
yl2.Annotation.LegendInformation.IconDisplayStyle = 'off';
yline(-sigma_rms*1000,'k:', 'DisplayName','$\sigma_{\mathrm{RMS}}$');
legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%ylim([-A_coarse*1e3, A_coarse*1e3]);
xlim([0,1000]);
