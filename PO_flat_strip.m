clc
clear all
close all

%   Code to compute scattering from a strip of width w 
%   2D problem

% Various physical constants and units
MHz = 1.0e6 ; 
epsilon0 = 8.854e-12 ;      % vacuum permittivity
mu0 = 4.0*pi*1.0e-7 ;       % vacuum permeability
c0 = 1/sqrt(epsilon0*mu0) ; % vacuum speed of light
eta = sqrt(mu0/epsilon0) ;  % vacuum impedance

% Basic parameters
E0 = 1 ;                    % amplitude of incident wave equals 1
f = 300*MHz ;               % EM-frequency, TODO: tried with different
                                            % frequencies (30, 30000MHz.)
                                            % Why not matching as well?
% Related constants
omega = 2.0*pi*f ; 
lambda = f/c0  ; 
k0 = 2.0*pi/lambda ;        % vacuum wavenumber  

% We assume a plane wave incident field
% Propagation vector for incoming wave
alpha_i = 3.0*pi/4.0 ;  
ki_vec_x = -k0*cos(alpha_i) ;    % propagation direction is rotated 180 (-1 factor)
ki_vec_y = -k0*sin(alpha_i) ;
% Propagation vector for reflected wave
alpha_r = pi/2.0 - (alpha_i - pi/2.0) ;
kr_vec_x = -k0*cos(alpha_r) ; 
kr_vec_y = -k0*sin(alpha_r) ; 
% Angle of incidence
theta = pi/2.0  - alpha_r ; 

% Strip dimensions
w = 40.0*lambda ; % TODO: confirm why 40 was chosen... Heuristic?
strip_start = 0.0 ; 
strip_end = w ;

% Compute and plot incident fields on surface 
disc_per_wavelength = 20 ;  % TODO: confirm why 20 was chosen... Heuristic?
N = ceil((w/lambda)*disc_per_wavelength) ; 
delta_x = w/N ; 
% Strip runs from (0,0) to (w,0) ; 
for(ct = 1:N) 
    strip_x(ct) = strip_start + (ct-0.5)*delta_x ; 
    strip_y(ct) = 0.0 ; 
    % Incident field at centre ct
    E_inc_z(ct,1) = E0*exp(-j*(ki_vec_x*strip_x(ct) + ki_vec_y*strip_y(ct))) ; 
    % Physical optics current at centre ct
    J_PO_z(ct,1) = -2.0 * ((E0*ki_vec_y)/(omega*mu0)) ...
                   * exp(-j*(ki_vec_x*strip_x(ct) + ki_vec_y*strip_y(ct)));  
end

% Now make the MoM matrix 
% TODO: elaborate a bit on this? Why the 1.781, and what basis functions?
% The diagonal needs us to compute the field from a basis function 
% at the centre of the same basis function. This involves integrating over
% an integrable singularity. So a special case for the diagonal terms
self = -1.0*delta_x*(1.0 - j*(2.0/pi)*log(1.781*k0*delta_x/(4.0*exp(1.0)))) ; 
for(ct1 = 1:N) 
    for(ct2 = 1:N) 
        Rx = strip_x(ct1)  - strip_x(ct2) ; 
        Ry = strip_y(ct1)  - strip_y(ct2) ; 
        R = sqrt(Rx*Rx + Ry*Ry) ;
        the_hank = (besselj(0,k0*R) - j*bessely(0,k0*R)) ; 
        % Off diagonal terms
        if( ct1 ~= ct2) 
            Z(ct1,ct2) = (k0*eta/4.0)*the_hank*delta_x ;
        else
            Z(ct1,ct2) = -(k0*eta/4.0)*self ; % diagonal term
        end
    end
end
J = inv(Z)*E_inc_z ; 

% Now compute the scattered field along a line in the x direction 
y_line = 5*lambda ; 
x_start = 0 ; 
x_end = 1.5*w ; 
no_of_scatter_points  = 1000  ; 
spacing_x = (x_end - x_start)/no_of_scatter_points ; 
for(ct1 = 1:no_of_scatter_points)
    x_point(ct1) = x_start + (ct1-0.5)*spacing_x ;
    y_point(ct1) = y_line ;

    the_PO_field(ct1) = 0.0; 
    the_exact_field(ct1) = 0.0; 

    % Now do the PO sum 
    for(ct2 = 1:N)
        x_diff = strip_x(ct2) - x_point(ct1) ; 
        y_diff = strip_y(ct2) - y_point(ct1) ; 
        R = sqrt(x_diff*x_diff + y_diff*y_diff) ; 
        the_hank = besselj(0,k0*R) - 1j*bessely(0,k0*R) ; 
        the_PO_field(ct1) = the_PO_field(ct1) + the_hank*J_PO_z(ct2)*delta_x ; 
        the_exact_field(ct1) = the_exact_field(ct1) + the_hank*J(ct2)*delta_x ; 
    end
    the_PO_field(ct1) = the_PO_field(ct1)*k0*eta/4 ; 
    the_exact_field(ct1) = the_exact_field(ct1)*k0*eta/4 ; 
    the_ref_field(ct1) =  0.0 ; 
    if( x_point(ct1) > x_start + y_line*tan(theta) ) 
        if( x_point(ct1) < w  + y_line*tan(theta) ) 
            the_ref_field(ct1) = E0*exp( -1j* (kr_vec_x*x_point(ct1) + ...
                                               kr_vec_y*y_point(ct1))) ; 
        end
    end
end

figure
plot(strip_x,real(J_PO_z)) ; 
hold on
plot(strip_x,real(J),'r') ; 
legend('PO','J') ; 
grid on
xlabel('x') ; 
ylabel('real(J)') 
title('PO versus J - real part')  ;

figure
plot(strip_x,abs(J_PO_z)) ; 
hold on
plot(strip_x,abs(J),'r') ; 
legend('PO','J') ; 
grid on
xlabel('x') ; 
ylabel('abs(J)') 
title('PO versus J - abs part')  ;

figure
plot(x_point,real(the_PO_field))
grid on
hold on
plot(x_point,real(the_ref_field),'r')
plot(x_point,real(the_exact_field),'k')
title('The scattered field (Real)')
xlabel('x')
ylabel('E_ref')
legend('PO','reflected','Exact')
