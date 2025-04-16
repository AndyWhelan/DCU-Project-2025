%{ 
Setup the parameters for the 3d-plot
%}

% Geometry:
tx_d = 1;
tx_h = 10;
rx_d = 20;
rx_h = 8;
% For now, just have fixed receiver
%rx_init_d = 0;
%rx_init_h = 0;
%rx_final_d = 10 * tx_d;
%rx_final_h = 10 * tx_h;
% For now, assume infinite wall
% len_wall = 3 * tx_d; %TODO: suggest sensible range of values

% Other physical parameters:
n1 = 1; % refractive index of air
n2 = 1.55; % refractive index of plaster wall:
%            https://refractiveindex.info/?shelf=main&book=CaSO4&page=Querry-%CE%B2
perp=true; % EM-wave polarization relative to plane of incidence P.
%            true: radiation oscillates perpendicular to P;
%            false: radiation oscillates parallel to P.
wavelength = 0.6 % interesting to see how the power converges along the wall as
%                  this is varied
wavenumber = 2 * pi/wavelength

% Numerical parameters:
% rx_steps = 200; % number of steps for Rx to move from start to finish
hankel_approx = false % whether or not to use approximation in the 
%                       Green's functions
wall_steps = 500;
wall_end = rx_d + 20;
wall_start = - wall_end % just have symmetrical
delta_wall = ( wall_end - wall_start ) / ( wall_steps - 1 )
wall_positions = linspace( wall_start, wall_end, wall_steps )
