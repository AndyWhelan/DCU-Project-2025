clc
clear all
close all

addpath( genpath( './matlab_functions')) ;

% Various physical constants and units
MHz = 1.0e6 ; 
epsilon0 = 8.854e-12 ;                            % vacuum permittivity
mu0 = 4.0*pi*1.0e-7 ;                             % vacuum permeability
c0 = 1/sqrt(epsilon0*mu0) ;                       % vacuum speed of light
eta = sqrt(mu0/epsilon0) ;                        % vacuum impedance

eta_1 = eta                                       % first medium is vacuum-like
eta_2 = 0                                         % PEC second medium
mu_r1 = 1                                         % non-magnetic medium 1
mu_r2 = 1                                         % non-magnetic medium 2

% Basic parameters
P0 = 1 ;                                          % initial power of incident wave
f = 300*MHz ;                                     % EM-frequency
S = 0.3 ;                                         % TODO: Mess around later with this

% Related constants
omega = 2.0*pi*f ; 
lambda = c0/f  ;
k0 = 2.0*pi/lambda ;                              % vacuum wavenumber  

% Strip dimensions
w = 40.0*lambda ;                                 % strip length
strip_start_x = 0 ;                               % sum starts at origin 
strip_end_x = 1.5w ;                              % sum a bit more than strip len
disc_per_wavelength = 20 ;                        % 20 samples per wavelength
N_strip = ceil((w/lambda)*disc_per_wavelength) ;  % # of points along strip for sim
delta_x = w/N_strip ; 

# TODO: (P3) Properly justify later. Seems we can just set this to 0... unused for
# now
lambda_strip = w * 100 ;
A_strip = 0 ; 

% Rx position
r_y = 5* lambda ;
% TODO: (P3) justify above later. Maybe use the far-field definition
t_x = 0 ;
t_y = 0.7 * r_y ;

% We assume a cylindrical wave incident field
% the ER contribution will be an integral along the points of the wall.
N_rx  = 1000 ; % TODO: (P3) move this to appropriate param section
spacing_x = (strip_end_x - strip_start_x)/N_rx ; 
for(N_r = 1:N_rx)
   r_x = strip_start_x + (N_r-0.5)*spacing_x ;
   E_r_sq = specular_intensity( eta_1, eta_2, mu_r1, mu_r2, t_x, t_y, r_x, r_y, ...
                                strip_start_x, w, P0 ) ;
   E_s_sq = er_lambertian_intensity( S, eta_1, P0, delta_x, t_x, t_y, r_x, r_y, ...
                                     N_strip )                           
% TODO: (P1):
% 1. Plot some initial graphs,
% 2. Tighten up the formulae,
% 3. Tighten up parameters and rigour
