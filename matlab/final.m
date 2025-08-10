clear; clc; close all;
rng(126); % set seed for reproducibility
k = 1000;
L = 10;
delta_x = pi/(5*k);
N0 = ceil(L/delta_x);
N0 = 20 * N0; % need more samples to avoid aliasing
N = 2^(ceil(log2(N0))); % want power of 2 for FFT
x = linspace(0, L, N);

% Use a cropping method for a longer sample to avoid symmetric artefacts
N_long = 4*N;
L_long = 4*L;
k_long = linspace(0,N_long/L_long,N_long);
z_long_fine = zeros(1,N_long);
z_long_coarse = zeros(1,N_long);
z_long_aging = zeros(1,N_long);

L_corr_coarse = 5e-2;
L_corr_fine = 1e-3;
H_aging = 0.5;

% PSD: Gaussian for coarse, exponential for fine, and power-law for aging
for(i=2:(N_long/2)+1)
    phase_offset_fine = 2*pi*rand();
    phase_offset_coarse = 2*pi*rand();
    phase_offset_aging = 2*pi*rand();
    S_coarse = exp(-(k_long(i)*L_corr_coarse)^2);
    S_fine = exp(-abs((k_long(i)*L_corr_fine)));
    S_aging = abs(k_long(i))^(-(2*H_aging + 1));
    z_long_coarse(i) = sqrt(S_coarse) * exp(j*phase_offset_coarse);
    z_long_fine(i) = sqrt(S_fine) * exp(j*phase_offset_fine);
    z_long_aging(i) = sqrt(S_aging) * exp(j*phase_offset_aging);
end
for(i=(N_long/2)+2:N_long)
    z_long_coarse(i) = conj(z_long_coarse(N_long-i+2));
    z_long_fine(i) = conj(z_long_fine(N_long-i+2));
    z_long_aging(i) = conj(z_long_aging(N_long-i+2));
end
h_long_coarse = ifft(z_long_coarse, 'symmetric');
h_long_fine = ifft(z_long_fine, 'symmetric');
h_long_aging = ifft(z_long_aging, 'symmetric');
% now crop
h_coarse = h_long_coarse(N+1:2*N);
h_fine = h_long_fine(N+1:2*N);
h_aging = h_long_aging(N+1:2*N);
% take out any negligible imaginary parts
h_coarse = real(h_coarse);
h_fine = real(h_fine);
h_aging = real(h_aging);
% de-mean the pre-processed signals and rescale
h_coarse = h_coarse - mean(h_coarse);
h_fine = h_fine - mean(h_fine);
h_aging = h_aging - mean(h_aging);
sigma_current_coarse = std(h_coarse);
sigma_current_fine = std(h_fine);
sigma_current_aging = std(h_aging);
rms_h_coarse = 5e-3;
rms_h_fine = 1e-3;
rms_h_aging = 2e-3;
if sigma_current_coarse > 0
    h_coarse = h_coarse * (rms_h_coarse/sigma_current_coarse);
end
if sigma_current_fine > 0
    h_fine = h_fine * (rms_h_fine/sigma_current_fine);
end
if sigma_current_aging > 0
    h_aging = h_aging * (rms_h_aging/sigma_current_aging);
end
% use tanh to smooth out peaks or valleys between -1 and 1, choosing a characteristic height scale
peaks_coarse = (h_coarse < 0); % coarse process is additive
peaks_fine = (h_fine > 0); % fine process is subtractive
peaks_aging = (h_aging > 0); % random process is subtractive

h_coarse(peaks_coarse) = rms_h_coarse*tanh(h_coarse(peaks_coarse)/rms_h_coarse);
h_fine(peaks_fine) = rms_h_fine * tanh(h_fine(peaks_fine)/rms_h_fine);
h_aging(peaks_aging) = rms_h_aging * tanh(h_aging(peaks_aging)/rms_h_aging);
h_total = h_aging+h_fine+h_coarse;
%h_total = h_total - mean(h_total);
%rms_total = std(h_total);


%figure(1);
%hold on;
%plot(x*1000, h_coarse*1000, 'DisplayName', '$h_{\mathrm{coarse}}$');
%title('Coarse Manufacturing Defects [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%yline(rms_h_coarse*1000,'k:', 'DisplayName','$\sigma_{\mathrm{coarse}}$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,10000]);
%ylim([-15,15]);
%
%figure(2);
%hold on;
%plot(x*1000, h_coarse*1000, 'DisplayName', '$h_{\mathrm{coarse}}$');
%title('Coarse Manufacturing Defects [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%yline(rms_h_coarse*1000,'k:', 'DisplayName','$\sigma_{\mathrm{coarse}}$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,100]);
%ylim([-15,15]);
%
%figure(3);
%hold on;
%plot(x*1000, h_fine*1000, 'DisplayName', '$h_{\mathrm{fine}}$');
%title('Fine Manufacturing Defects [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%yline(-rms_h_fine*1000,'k:', 'DisplayName','$\sigma_{\mathrm{fine}}$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,10000]);
%ylim([-15,15]);
%
%figure(4);
%hold on;
%plot(x*1000, h_fine*1000, 'DisplayName', '$h_{\mathrm{fine}}$');
%title('Fine Manufacturing Defects [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%yline(-rms_h_fine*1000,'k:', 'DisplayName','$\sigma_{\mathrm{fine}}$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,100]);
%ylim([-15,15]);
%
%figure(5);
%hold on;
%plot(x*1000, h_aging*1000, 'DisplayName', '$h_{\mathrm{aging}}$');
%title('Aging Defects [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%yline(-rms_h_aging*1000,'k:', 'DisplayName','$\sigma_{\mathrm{aging}}$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,10000]);
%ylim([-15,15]);
%
%figure(6);
%hold on;
%plot(x*1000, (h_total)*1000, 'DisplayName', '$h$');
%title('Wall Height [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%%yline(rms_total*1000,'k:', 'DisplayName','$\sigma$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,10000]);
%ylim([-15,15]);
%
%figure(7);
%hold on;
%plot(x*1000, (h_total)*1000, 'DisplayName', '$h$');
%title('Wall Height [mm]', 'Interpreter', 'latex', 'FontSize', 16);
%ylabel('height', 'Interpreter', 'latex', 'FontSize',14);
%xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
%yl = yline(0, 'k--');
%yl.Annotation.LegendInformation.IconDisplayStyle = 'off';
%%yline(rms_total*1000,'k:', 'DisplayName','$\sigma$', 'Interpreter','latex', 'FontSize',14);
%legend('show', 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 16);
%xlim([0,100]);
%ylim([-15,15]);

% --- FIGURE 1: THE COMPOSITION STORY (REVISED) ---
figure('Position', [100, 100, 1200, 800]);
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
title(t, 'Surface Height Composition', 'Interpreter', 'latex', 'FontSize', 18);

% Define a common zoom window for high-frequency components
zoom_start_mm = 4500;
zoom_end_mm = 4600;
zoom_indices = (x*1000 >= zoom_start_mm) & (x*1000 <= zoom_end_mm);

% --- Plot 1: Coarse Component (Full View) ---
ax1 = nexttile;
plot(x*1000, h_coarse*1000, 'Color', [0.6 0.6 0.6],'LineWidth',0.1);
hold on; grid on;
yline(0, 'k--');
title('Coarse Component (Full 10m View)','Interpreter','latex');
ylabel('Height [mm]','Interpreter','latex');
xlim([0, 10000]); % MUST show full view for coarse signal
ylim([-15, 15]);

% --- Plot 2: Fine Component (Zoomed View) ---
ax2 = nexttile;
plot(x(zoom_indices)*1000, h_fine(zoom_indices)*1000, 'Color', [0.6 0.6 0.6],'LineWidth',0.1);
hold on; grid on;
yline(0, 'k--');
title('Fine Component (Representative 100mm Section)','Interpreter','latex');
ylim([-15,15]);
xlim([zoom_start_mm, zoom_end_mm]);

% --- Plot 3: Aging Component (Zoomed View) ---
ax3 = nexttile;
plot(x*1000, h_aging*1000, 'Color', [0.6 0.6 0.6],'LineWidth',0.1);
hold on; grid on;
yline(0, 'k--');
title('Aging Component (Full 10m View)','Interpreter','latex');
xlabel('Position $x$ [mm]','Interpreter','latex');
ylabel('Height [mm]','Interpreter','latex');
ylim([-15,15]);
xlim([0,10000]);

% --- Plot 4: Total Combined Surface (Full View) ---
ax4 = nexttile;
h_total = h_aging + h_fine + h_coarse;
plot(x*1000, h_total*1000, 'Color', [0.6 0.6 0.6],'LineWidth',0.1);
hold on; grid on;
yline(0, 'k--');
title('Total = Coarse + Fine + Aging (Full 10m View)','Interpreter','latex');
xlabel('Position $x$ [mm]','Interpreter','latex');
ylim([-15, 15]);
xlim([0, 10000]);