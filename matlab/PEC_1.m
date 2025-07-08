% Assume a cylindrical wave incident field
% The models used to compare are:
% 1. Effective Roughness (ER) Lambertian model 
%    (overall ER contribution is an integral along the points of the wall), and
% 2. Geometrical Optics  (GO).
%
% Compare the time-averaged power density for the setup:
%                                             
%     (r_x0, r_y) ─────────────────────────── (r_x, r_y) ──────────────── (r_xe, r_y)
%                                                 /        
%                (t_x, t_y)                    /           
%                     \                     /              
%                      \                 /                 
%                       \             /                    
%                        \  ╎      /                       
%                         \ ╎   /                          
%                          \╎/                             
% (w_x0,0) ━━━━━━━━━━━━ (w_x, 0) ━━━━━━━━━━━━━━━━━━━━ (w_xe, 0)
%
function dP = GO_Power_Density( x, ...              % Position along receiver line
                                P0, ...             % Source power
                                r_y, ...            % Rx antenna height
                                t_x, t_y, ...       % Tx antenna positions
                                w_x0, w_xe )        % Start and end of strip
% Formula 1.12 in derivations
   w_spec = t_x + t_y * ( (x - t_x)/(r_y + t_y) );
   if( w_x0 > w_spec || w_spec > w_xe )
      dP = 0;
   else 
      dP = P0 * ( r_y + t_y ) / ...
               ( 2 * pi * ((x - t_x)^2 + (r_y + t_y)^2) );
   end
end

function dP = Lambertian_Power_Density( x, ...
                                        P0, ...
                                        r_y, ...
                                        t_x, t_y, ...
                                        w_x0, w_xe, ...
                                        N_strip )   % # Points along strip
% Formula 1.11 in derivations
   w_len = w_xe - w_x0;
   dx_w = w_len / N_strip;
   dP = 0;
   for( N = 1:N_strip )
      w_x = w_x0 + (N-0.5)*dx_w;
      numerator = t_y * r_y * dx_w;
      denominator = ((t_y)^2 + (w_x - t_x)^2) * ((r_y)^2 + (x - w_x)^2);
      ddP = ( numerator / denominator );
      dP = dP + ddP;
   end
   dP = dP * P0 / (4 * pi);
end

function dP = PO_Power_Density( x, ...
                                P0, ...
                                k, ...
                                r_y, ...
                                t_x, t_y, ...
                                w_x0, w_xe, ...
                                N_strip )   % # Points along strip
% Formula 1.20 in derivations
   w_len = w_xe - w_x0;
   dx_w = w_len / N_strip;
   int1 = 0;
   int2 = 0;
   for( N=1:N_strip )
      w_x = w_x0 + (N-0.5)*dx_w;
      r_TB = sqrt( (w_x - t_x)^2 + (t_y)^2 );
      r_BR = sqrt( (x - w_x)^2 + (r_y)^2 );
      num1 = besselh(1, 1, k*r_TB) * besselh(1, 1, k*r_BR );
      denom1 = r_TB * r_BR;
      num2 = besselh(1, 2, k*r_TB) * besselh( 0, 2, k*r_BR );
      denom2 = r_TB;
      int1 = int1 + dx_w*(num1/denom1);
      int2 = int2 + dx_w*(num2/denom2);
   end
   dP = imag( int1 * int2 );
   dP = - dP * (k*t_y)^2 * P0 * (r_y) / 4.0;
end

function dP = Lambertian_Power_Density_PO( x, ...
                                                   P0, ...
                                                   r_y, ...
                                                   t_x, t_y, ...
                                                   w_x0, w_xe )
% Formula 1.13 in derivations
    dP = (t_y + r_y)/((x - t_x)^2 + (t_y + r_y)^2);
    dP = P0 * dP / 4;%(4*pi);
end

%---Special Parameter Markings-------------------------------------------------------
%   [!] Interesting
%   [n] Numerical
%------------------------------------------------------------------------------------
clc
clear all
close all
% Rx antennas------------------------------------------------------------------------
r_x0 = -200;                                % [!] First Rx
r_xe = 200;                                 % [!] Last Rx
r_y = 5;                                    % [!] Rx height wrt strip
N_rx  = 200;                                % [n] Number of receivers
r_spread = r_xe - r_x0;                     %     Rx spread
dx_r = r_spread / N_rx;                     %     dx along Rx-line
r_x = zeros(1, N_rx);                       %     Rx positions
for( N = 1:N_rx )
   r_x( N ) = r_x0 + (N-0.5) * dx_r;
end
% Tx antenna-------------------------------------------------------------------------
t_x = 0;                                    %     Tx position
t_y = 2.5;                                  % [!] Tx height wrt strip
% Strip------------------------------------------------------------------------------
w_x0 = -50;                                 % [!] Strip start
w_xe = 50;                                  % [!] Strip end
N_strip = 600;                              % [n] # Calc points along strip
w_len = w_xe - w_x0;                        %     Strip length
% Source waves-----------------------------------------------------------------------
P0 = 1;                                     %     Source power
k_sweet = 2.5e0;                            % [!] Wavenumber, sweetspot
k_low = 0.1 * k_sweet;                      % [>] Wavenumber, low 
k_high = 1600;                              % [!] Wavenumber, high (EHF)
% Models-----------------------------------------------------------------------------
S = sqrt(0.1);                              % [!] Effective Roughness
R = sqrt( 1.0 - (S)^2);                     %     Specular reflectance reduction

Lambertian_Density = zeros(1, N_rx);
Lambertian_Density_PO = zeros(1,N_rx);
PO_Density_Sweet = zeros(1,N_rx);
PO_Density_High = zeros(1,N_rx);
PO_Density_Low = zeros(1,N_rx);
GO_Density = zeros(1, N_rx);
ER_Density = zeros(1, N_rx);
r_spec_start = NaN; %prealloc
r_spec_end = NaN; %prealloc
for(N_r = 1:N_rx)
   x = r_x( N_r );
   this_w_spec = t_x + t_y * ( (x - t_x)/(r_y + t_y) );
   if( w_x0  <= this_w_spec && this_w_spec <= w_xe && isnan(r_spec_start) )
       r_spec_start = x;                                                                                                             
   elseif( w_xe < this_w_spec && isnan(r_spec_end) )
       r_spec_end = x;
   end
   PO_Density_Sweet( N_r ) = PO_Power_Density( x, ...
                                               P0, k_sweet, ...
                                               r_y, ...
                                               t_x, t_y, ...
                                               w_x0, w_xe, ...
                                               N_strip );   % # Points along strip
   PO_Density_High( N_r ) = PO_Power_Density( x, ...
                                              P0, k_high, ...
                                              r_y, ...
                                              t_x, t_y, ...
                                              w_x0, w_xe, ...
                                              N_strip );   % # Points along strip
   PO_Density_Low( N_r ) = PO_Power_Density( x, ...
                                             P0, k_low, ...
                                             r_y, ...
                                             t_x, t_y, ...
                                             w_x0, w_xe, ...
                                             N_strip );   % # Points along strip
   GO_Density( N_r ) = GO_Power_Density( x, ...
                                         P0, r_y, t_x, t_y, ...
                                         w_x0, w_xe );
   Lambertian_Density( N_r ) = Lambertian_Power_Density( x, ...
                                                         P0, r_y, t_x, t_y, ...
                                                         w_x0, w_xe, ...
                                                         N_strip );
   ER_Density( N_r ) = (S^2) * Lambertian_Density( N_r ) + (R^2) * GO_Density( N_r );
   Lambertian_Density_PO( N_r ) = Lambertian_Power_Density_PO( x, ...
                                                               P0, r_y, t_x, t_y, ...
                                                               w_x0, w_xe );
   % Use decibels:
   GO_Density( N_r ) = 10 * log10( GO_Density( N_r ));
   Lambertian_Density( N_r ) = 10 * log10( Lambertian_Density( N_r ));
   ER_Density( N_r ) = 10 * log10( ER_Density( N_r ));
   Lambertian_Density_PO( N_r ) = 10 * log10( Lambertian_Density_PO( N_r ));
   PO_Density_Sweet( N_r ) = 10 * log10( PO_Density_Sweet( N_r ));
   PO_Density_High( N_r ) = 10 * log10( PO_Density_High( N_r ));
   PO_Density_Low( N_r ) = 10 * log10( PO_Density_Low( N_r ));
end
% handle -inf for dB graphs
for(N_r = 1:N_rx)
    % replace complex values with -inf
    if( imag(PO_Density_Sweet(N_r)) > 1e-12 )
        PO_Density_Sweet(N_r) = -inf;
    else
        PO_Density_Sweet(N_r) = real(PO_Density_Sweet(N_r));
    end
    if( imag(PO_Density_High(N_r)) > 1e-12 )
        PO_Density_High(N_r) = -inf;
    else
        PO_Density_High(N_r) = real(PO_Density_High(N_r));
    end
    if( imag(PO_Density_Low(N_r)) > 1e-12 )
        PO_Density_Low(N_r) = -inf;
    else
        PO_Density_Low(N_r) = real(PO_Density_Low(N_r));
    end
end
all_data = [ GO_Density(:), Lambertian_Density(:), ER_Density(:), ...
             PO_Density_Sweet(:), PO_Density_High(:), PO_Density_Low(:) ];
finite_values = all_data(isfinite(all_data));
min_finite_val = min( finite_values );
max_finite_val = max( finite_values );
inf_display_val = min_finite_val - 0.5 * ( max_finite_val - min_finite_val );
for(N_r = 1:N_rx)
    if( GO_Density(N_r) == -inf )
        GO_Density(N_r) = inf_display_val;
    end
    if( Lambertian_Density(N_r) == -inf )
        Lambertian_Density(N_r) = inf_display_val;
    end
    if( ER_Density(N_r) == -inf )
        ER_Density( N_r ) = inf_display_val;
    end
    if( PO_Density_Sweet(N_r) == -inf )
        PO_Density_Sweet( N_r ) = inf_display_val;
    end
    if( PO_Density_High(N_r) == -inf )
        PO_Density_High( N_r ) = inf_display_val;
    end
    if( PO_Density_Low(N_r) == -inf )
        PO_Density_Low( N_r ) = inf_display_val;
    end
end

% default color ordering
new_colors = colororder; 
figure;
%plot( r_x, GO_Density, ...
%      'b', ...
%      'LineWidth', 1.5, ...
%      'DisplayName', 'GO (Specular)' );
hold on;
plot( r_x, Lambertian_Density, ...
      'Color', 'k', ...
      'LineWidth', 2.5, ...
      'DisplayName', 'Lambertian' );
plot( r_x, GO_Density, '--', ...
      'Color', new_colors(6,:), ...
      'LineWidth', 1.5, ...
      'DisplayName', "Geometrical Optics" );
plot( r_x, Lambertian_Density_PO, '--', ...
      'Color', new_colors(2,:), ...
      'LineWidth', 1.5, ...
      'DisplayName', 'Lambertian (limiting case)' );
plot( r_x, PO_Density_Sweet, ':', ...
      'Color', new_colors(3,:), ...
      'LineWidth',2.0, ...
      'DisplayName', "Physical Optics, k = " + k_sweet );
plot( r_x, PO_Density_High, ...
      'Color', new_colors(4,:), ...
      'LineWidth', 1.5, ...
      'DisplayName', "Physical Optics, k = " + k_high );
plot( r_x, PO_Density_Low, ...
      'Color', new_colors(5,:), ...
      'LineWidth', 2.0, ...
      'DisplayName', "Physical Optics, k = " + k_low );
grid on;
ylim([min_finite_val*1.1, max_finite_val*0.9]);
title_string = "Power Density [dB]"
title( title_string, ...
       'FontSize', 17, ...
       'FontWeight', 'bold' )
ax = gca;
special_locations = [ w_x0, w_xe ];
special_labels = { 'Strip Start',  'Strip end' };
[ sorted_locations, sort_order] = sort(special_locations);
sorted_labels = special_labels(sort_order);
ax.XTick = sorted_locations;
ax.XTickLabel = sorted_labels;
ax.XTickLabelRotation = 45;
ax.YTick = [ min_finite_val, max_finite_val ];
hold off;
legend;
