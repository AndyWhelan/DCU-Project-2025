# Discussion for Meeting on 11-06-2025

1. I looked back at the papers and believe I have a grasp of what they're doing (see
   [next section](#effective-roughness-er-model) and discuss)
2. Given you agree with this, 

- I looked back at the papers

# Effective Roughness (ER) Model
## Assumptions
In the original ER model<sup>[[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf) ,[2](./papers/1.A_diffuse_scattering_model.pdf), [3](./papers/2.Measurement_and_Modelling_of_Scattering.pdf)]</sup>, the following assumptions are made (I use $dW$ instead of $dS$ for clarity, since we have the scattering parameter $S$)

1.  > ...consider a ray tube of solid angle $d \Omega$ impinging on the surface
    element ($dW$). Part of the power is reflected in the specular ray tube... part
    is transmitted and part is reflected toward the desination point $D$

    $$
    E = E_i + E_r + E_s + E_t,
    $$
    where
    - $E$ is the total electric field,
    - $E_i$ is the ***i***ncident field, 
    - $E_r$ is the specularly ***r***eflected component of the scattered field,
    - $E_s$ is the diffusely ***s***cattered component of the scattered field, and
    - $E_t$ is the ***t***ransmitted component of the scattered field. 
    
2.  Lambertian local diffuse scattering: 
    $$
    ert E_s ert_{dW} \propto \sqrt{    $$
    where $	heta_s$ is the scattering angle relative to the wall normal.
3.
    > $S$ ... defined as the ratio between local scattered field and incident field
    ... can be determined from scattered field measurements

    $$
    S:= rac{ert E_s ert }{ert E_i ert}ert_{dW} \ \ 	ext{is assumed to be constant for a given wall.}
    $$

4.  The far-field is sufficiently close so that diffusely scattered waves interfere
    incoherently:
    $$
    ert E_s ert = \int_W ert E_s ert_{dW} \ dW.
    $$

## Model Measures - Derivations
### Local Scattering Power Balance

Using the solid angle formula $d \Omega = rac{dW assumption 2, we equate the total power density (scaled by $ta$, intrinsic 
impedance) of the scattered field, with respect to $E_i$ ($ert E_s ert_{dW}^2 \ r_i^2 \ d \Omega$) and $E_s$ ($ \iint_{\Omega} ert E_s ert_{dW}^2 \ r_s^2 d \Omega $), obtaining  

$$
ert E_s ert_{dW} = S \sqrt{rac{dW ert E_i ert_{dW}.
$$

Since $	heta_s$ will determine $	heta_i$ given fixed antenna positions, we can use
the above to compute the
- **Total Power** for a given setup (by utilising assumption 4),
- **Power-Angle Profile**, and
- **Scattering-angle Spread**

Expressing $r_s$, $	heta_i$ and $	heta_s$ in terms of setup parameters ( $(x_{Tx},y_{Tx}), (x_{Rx},y_{Rx})$ ) and distance along the wall $x$:
- $r_s = \sqrt{y^2_{Rx} + (x_{Rx} - x_{Tx} - x)^2}$,
- $- $
we can also derive:

$$
ert E_s ert_{dW} = S \sqrt{ rac{dW \ y_{Rx} \ y_{Tx}}{\pi \ \left(y^2_{Tx}+x^2ight)^{rac{1}{2}} \ \left(y^2_{Rx} + (x_{Rx} - x_{Tx} - x)^2ight)^{rac{3}{4}}} } \ ert E_i ert_{dW}.
$$

This can be used to directly compute the
- **Power-Distance Profile**, and
- **Path-length Spread**,

### Path Delay Conversion
Additionally, by converting each path distance to a delay, we can compute
- **Power-Delay Profile**, and 
- **Delay Spread**

The procedure for the conversion is as follows:
- Use coordinate system in [[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf)] translating the origin to the specular point of reflection $x 	o x' = x - \left( x_i + y_i rac{x_s - x_i}{y_s + y_i} ight)$
- $ct = \sqrt{(x'_i)^2 + (y_i)^2} + \sqrt{(x'_s)^2 + (y_s)^2}$, noting that $y' = y$,
- Square the above twice to remove all radicals,
- Reduce quartic to quadratic due to symmetry, and solve for $x'$,
- Retransform $x' 	o x$.

<!-- {{{ MATLAB Code -->
# [MATLAB Code](./flat_strip_setup.m)
The code linked above uses functions from [./matlab_functions](./matlab_functions). The full, inlined version is pasted below:
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
