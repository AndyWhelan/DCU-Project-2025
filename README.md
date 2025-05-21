The main repo for 2025 MECE Project.
<!-- {{{ Literature Review -->
# [Literature Review](./literature_review/main.pdf)
<!-- }}} -->
<!-- {{{ MATLAB Code -->
# [MATLAB Code](./flat_strip_setup.m)
The code linked above uses functions from [./matlab_functions](./matlab_functions).The full, inlined version is pasted below:
```matlab
clc
clear all
close all

%   Code to compute scattering from a strip of width w 
%   2D problem..

addpath( genpath( './matlab_functions'));

% Various physical constants and units
MHz = 1.0e6 ; 
epsilon0 = 8.854e-12 ;      % vacuum permittivity
mu0 = 4.0*pi*1.0e-7 ;       % vacuum permeability
c0 = 1/sqrt(epsilon0*mu0) ; % vacuum speed of light
eta = sqrt(mu0/epsilon0) ;  % vacuum impedance

% Basic parameters
E0 = 1 ;                    % amplitude of incident wave equals 1
f = 300*MHz ;               % EM-frequency

% Related constants
omega = 2.0*pi*f ; 
lambda = c0/f  ;
k0 = 2.0*pi/lambda ;        % vacuum wavenumber  

% We assume a plane wave incident field
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
w = 40.0*lambda ;
strip_start = 0.0 ; 
strip_end = w ;
lambda_w = w/10 ;
A_w = 8 ;

% Compute and plot incident fields on surface 
disc_per_wavelength = 20 ;
N = ceil((w/lambda)*disc_per_wavelength) ; 
delta_x = w/N ; 
% Strip runs from (0,0) to (w,0) ; 
for(ct = 1:N) 
    strip_x(ct) = strip_start + (ct-0.5)*delta_x ; 
    strip_y(ct) = 0.0 ; 
    n_v{ct} = normal_vector( ct, lambda_w, A_w );
    % Incident field at centre ct
    E_inc_z(ct,1) = E0*exp(-j*(ki_vec_x*strip_x(ct) + ki_vec_y*strip_y(ct))) ; 
    H_inc{ct} = ((E0)/(omega*mu0)) * ...
                exp(-j*(ki_vec_x*strip_x(ct) + ki_vec_y*strip_y(ct))) * ...
                [ ki_vec_y ; -ki_vec_x ; 0 ] ;
    J_PO{ct} = 2 * cross( n_v{ct}, H_inc{ct})
    % Physical optics current at centre ct
    J_PO_z(ct,1) = J_PO{ct}(3);
end

% Now make the MoM matrix 
% The diagonal needs us to compute the field from a basis function 
% at the centre of the same basis function. This involves integrating over
% an integrable singularity. So a special case for the diagonal terms
self = -1.0*delta_x*(1.0 - j*(2.0/pi)*log(1.781*k0*delta_x/(4.0*exp(1.0)))) ; 
for(ct1 = 1:N)
    for(ct2 = 1:N) 
        Rx = strip_x(ct1) - strip_x(ct2) ; 
        Ry = strip_y(ct1) - strip_y(ct2) ; 
        R = sqrt(Rx*Rx + Ry*Ry) ;
        the_hank = (besselj(0,k0*R) - j*bessely(0,k0*R)) ; 
        % Off diagonal terms
        if(ct1 ~= ct2) 
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


% ===== Inlined Functions =====


% ---- Inlined: normal_vector ----

function nv = normal_vector( ct, lambda_wall, A_wall )
    % Assume wall is of form A_wall * sin( 2pi*ct/lambda_wall )
    % So derivative is A_wall * (2*pi/lambda_wall) * cos( 2*pi*ct/lambda_wall )
    m_tangent =  A_wall * ( 2*pi/lambda_wall ) * cos( 2*pi*ct/lambda_wall ) ;
    if m_tangent==0
       nv = [ 0; 1; 0 ] ; 
    else
       m_normal = 1/m_tangent ;
       if m_normal > 0
          x_normal = 1 / sqrt( 1 + m_normal^2 );
       else
          x_normal = -1 / sqrt( 1 + abs( m_normal^2 ));
       end
       y_normal = abs( m_normal ) * abs( x_normal ); % normal always upward-pointing
       nv = [ x_normal, y_normal, 0 ] ;
    end
end


```
<!-- }}} -->
# Files
## [`PO_flat_strip.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/PO_flat_strip.m)
Fork of Conor's code for 2d PEC setup.
## [`Project.pdf`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/Project.pdf)
Work so far.

## [`functions/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/functions/)
(Possibly deprecate) MATLAB files with function definitions for calculations.

## [`supplementary_files/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/supplementary_files/)
### [`literature_review/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/literature_review/)
### [`meetings/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/meetings/)
### [`papers/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/papers)
### [`presentation/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/presentation)
### [`various_notes/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/various_notes)
