% Assume a cylindrical wave incident field
% The models used to compare are:
% 1. Effective Roughness (ER) Lambertian model 
%    (overall ER contribution is an integral along the points of the wall), and
% 2. Geometrical Optics  (GO).
%
% Compare the squared magnitude of the electric field phasor for the setup:
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
% The following are the expectations:
% a. Small scattering parameters (S ~ 0, R ~ 1) result in close agreement
% b. As S↑, R↓, we see a smoothed out step function.

% Setup parameters in local workspace (WS), with cleanup
cleanup_env()                                            ;
p = setup_parameters()                                   ;
fnames = fieldnames(p)                                   ;
for k = 1:numel(fnames)
   assignin('base', fnames{k}, p.(fnames{k}))            ;
end
clear p fnames k                                         ;
I_GO = zeros( 1, N_rx )                                  ;
I_ER_Lamb = zeros( 1, N_rx )                             ;
I_GO_log = zeros( 1, N_rx )                              ;
I_ER_Lamb_log = zeros( 1, N_rx )                         ;
for(N_r = 1:N_rx)
   E_r_sq = specular_intensity( eta_1, eta_2, mu_r1, ...
                                mu_r2, t_x, t_y, ...
                                r_x( N_r ), r_y, ...
                                r_x0, r_xe, ...
                                w_x0, w_xe, ...
                                spec_refl( N_r ), P0 )   ; % specular intensity calc
   E_s_sq = er_lamb_scattering_intensity( S, eta_1, P0, ...
                                          delta_xw, t_x, ...
                                          t_y, r_x( N_r ), r_y, ...
                                          N_strip )           ; % er lamb intensity calc
   I_GO( N_r ) = E_r_sq                                  ;
   I_ER_Lamb( N_r ) = E_s_sq + ...
                      (R( N_r ))^2 * E_r_sq                   ;
                      %E_r_sq * (R( N_r ))^2             ;
   I_GO_log( N_r ) = 10*log(I_GO(N_r))                   ;
   I_ER_Lamb_log( N_r ) = 10*log(I_ER_Lamb(N_r))         ;
end
figure                                                   ;
plot( r_x, I_GO, ...
      'b--', ...
      'LineWidth', 1.5, ...
      'DisplayName', 'GO (specular)' )                   ;
hold on                                                  ;
plot( r_x, I_ER_Lamb, ...
      'r:', ...
      'LineWidth', 1.5, ...
      'DisplayName', 'ER (Lambertian)' )                 ;
hold off                                                 ;
title( 'Comparison of GO and ER Scattering Models', ...
       'FontSize', 14, ...
       'FontWeight', 'bold' )                            ;
%                                                                                     TODO: (P1):
%                                                                                     1. Revise Energy conservation (think fresnel should be in the scattered portion somehow)
%                                                                                     2. Tighten up the formulae.

function cleanup_env()
   clc
   clear all
   close all
end

function P = setup_parameters()
   c = setup_global_constants()                           ;

   % CONSTITUTIVE PARAMETERS:
   P.epsilon_1 = c.epsilon_0                              ; % STRIP-EXTERIOR: vacuum
   P.mu_1 = c.mu_0                                        ; % ```
   P.mu_r1 = P.mu_1 / c.mu_0                              ; % ```
   P.sigma_1 = c.sigma_0                                  ; % ```
   P.eta_1 = c.eta_0                                      ; % ```
   P.c_1 = c.c_0                                          ; % ```
   P.epsilon_2 = c.epsilon_pec                            ; % STRIP-INTERIOR: PEC
   P.mu_2 = c.mu_pec                                      ; % ```
   P.mu_r2 = P.mu_2 / c.mu_0                              ; % ```
   P.sigma_2 = c.sigma_pec                                ; % ```
   P.eta_2 = c.eta_pec                                    ; % ```

   % SOURCE-WAVE:
   P.P0 = 1                                               ; % POWER: normalised
   P.f = 300*c.MHz                                        ; % FREQUENCY               TODO: (P3) justify using a certain value
   P.omega = 2.0*pi*P.f                                   ; % ANGULAR FREQUENCY       TODO: (P3) generalise formula via a function
   P.lambda = P.c_1 / P.f                                 ; % WAVELENGTH              TODO: (P3) ```

   % ANTENNA POSITIONS / SETUP GEOMETRY:
   P.N_rx  = 80                                           ; % NUMBER OF RECEIVERS
   P.r_y = 5* P.lambda                                    ; % RX HEIGHT :             TODO: (P3) justify later. Maybe use the far-field definition
   P.t_y = 0.7 * P.r_y                                    ; % TX HEIGHT :             TODO: (P3) ```
   P.r_x = zeros(1, P.N_rx)                               ; % RX POS    : Prealloc
   P.t_x = 0                                              ; % TX POS    : 0
   P.w_len= 40.0*P.lambda                                 ; % STRIP LENGTH
   P.r_len= P.w_len * 5                                   ; % RECEIVER LINE LENGTH
   P.w_x0 = 0                                             ; % STRIP START
   P.r_x0 = P.t_x + 10                                  ; % RX LINE START
   P.w_xe = P.w_x0 + P.w_len                              ; % STRIP END
   P.r_xe = P.r_x0 + P.r_len                              ; % RX LINE END

                                                                                     
   % WALL SHAPE:                                                                      TODO: (P3) Currently unused. To use later when model generalised a bit
   P.lambda_strip = ( P.w_len * 100 )                     ; % WALL PROFILE WAVELENGTH
   P.A_strip = 0                                          ; % PROFILE AMPLITUDE

   % NUMERICAL PARAMETERS:
   P.disc_per_wavelength = 8                              ; % samples per wavelength
   P.N_strip = ceil( (P.w_len/P.lambda)* ...
                     P.disc_per_wavelength)               ; % # sim-points on strip
   P.delta_xw = P.w_len/P.N_strip                         ; % 
   P.spacing_rx = (P.r_xe - P.r_x0)/P.N_rx                ; % RECEIVER SPACING

   % ER-MODEL:                                                                        TODO: (P2) vary the ER-model param
   P.P_p = 0                                              ; % TRANSMITTED POWER       TODO: (P3) tie the transmitted power in with the constitutive parameters
   P.S = 0.8                                              ; % SCATTERED POWER (sqrt)
   P.spec_refl = zeros(1, P.N_rx)                         ; % SPEC REFLECTANCE
   P.Gamma = zeros(1, P.N_rx)                             ; % FRESNEL COEFFICIENTS
   P.R = zeros(1, P.N_rx)                                 ; % SPECULAR POWER (sqrt)
   for( n_r = 1:P.N_rx )
      P.r_x( n_r ) = P.r_x0 + (n_r-0.5)*P.spacing_rx  ;
      P.spec_refl( n_r ) = specular_reflectance( P.eta_1, ...
                                                 P.eta_2, ...
                                                 P.mu_r1, ...
                                                 P.mu_r2, ...
                                                 P.t_x, P.t_y, ...
                                                 P.r_x( n_r ), P.r_y )  ;
      P.Gamma( n_r ) = sqrt( P.spec_refl( n_r ) )         ;
      P.R( n_r ) = sqrt( 1 - (P.S)^2 - (P.P_p / P.P0) ) / ...
                        P.Gamma( n_r ) ;
   end
   P.Gamma_min = min( P.Gamma )                           ;
   if( P.S > P.Gamma_min )
       error('S should be strictly less than all values of Gamma') ;
   end
end

function I = er_lamb_scattering_intensity( S, ...
                                           eta_1, P0, ...
                                           delta_x, ...
                                           t_x, t_y, r_x, r_y, ...
                                           N_strip )
I = 0 ;
for( w_x = 1:N_strip )
   x_i_diff = (w_x - 0.5) * delta_x ;
   y_i_diff = t_y ;
   x_s_diff = r_x - x_i_diff ;
   y_s_diff = r_y ;
   dist_i = sqrt( (y_i_diff)^2 + (x_i_diff)^2 ) ;
   dist_s = sqrt( (y_s_diff)^2 + (x_s_diff)^2 ) ;
   theta_i = acos( r_y / dist_s ) ;
   theta_s = acos( t_y / dist_i ) ;
   % Formula 1.3 in derivations:
   dI = ((S^2) * eta_1 * P0 * ( cos( theta_i )) * (cos(theta_s)) * delta_x ) / ...
          (2*pi*dist_i*dist_s) ;
   I = I + dI 
end
end
%
function I = specular_intensity( eta_1, eta_2, mu_r1, mu_r2, t_x, t_y, r_x, r_y, ...
                                 r_x0, r_xe, w_x0, w_xe, reflectance, P0 )
   I = 0 ;
   theta_i = pi/2 - atan( (r_y + t_y)/(r_x - t_x) ) ;
   x_rec_line = t_x + (r_y+t_y)*tan(theta_i) ;
   x_spec = t_y * tan( theta_i ) + t_x ;
   hits_wall = w_x0 <= x_spec && x_spec <= w_xe ;
   hits_recv = r_x0 <= x_rec_line && x_rec_line <= r_xe ;
   if( hits_wall && hits_recv )
      dist = sqrt( (x_rec_line - t_x)^2 + (r_y + t_y)^2 ) ; % total specular distance
      I = (eta_1 / pi ) * P0 * ( 1 / dist ) * reflectance ;
   end
   %keyboard ;
end

function R = specular_reflectance( eta_1, eta_2, mu_r1, mu_r2, t_x, t_y, r_x, r_y )
   % s-polarized incident (E-field perp to plane of incidence, i.e. z-direction)
   theta_i = atan( (r_y + t_y)/(r_x - t_x) ) ;
   theta_t = asin( sqrt( (mu_r1 * eta_2 )/(mu_r2 * eta_1) ) * ...
                   sin( theta_i )) ;
   R = abs( gamma_s( eta_1, eta_2, theta_i, theta_t )) ;
   R = R * R ;
end

function G = gamma_s( eta_1, eta_2, theta_i, theta_t )
   G = ( eta_2 * cos( theta_i ) - eta_1 * cos( theta_t ) ) / ...
         ( eta_2 * cos(theta_i) + eta_1 * cos (theta_t) ) ;
end

function C = setup_global_constants()
   C.MHz = 1.0e6                                     ;
                                                     % VACUUM:
   C.epsilon_0 = 8.854e-12                           ;  %    permittivity
   C.mu_0 = 4.0*pi*1.0e-7                            ;  %    permeability
   C.sigma_0 = 0                                     ;  %    conductivity
   C.c_0 = wave_phase_velocity( C.epsilon_0, ...        %    EM-wave phase-velocity
                                C.mu_0, ...             %    ```
                                C.sigma_0 )          ;  %    ```
   C.eta_0 = wave_impedance( C.epsilon_0, ...           %    EM-wave impedance
                             C.mu_0, ...                %    ```
                             C.sigma_0 )             ;  %    ```
                                                     % PEC:
   C.epsilon_pec = C.epsilon_0                       ;  %    permittivity
   C.mu_pec = C.mu_0                                 ;  %    permeability
   C.sigma_pec = 5.8e7                               ;  %    conductivity (copper)
   C.c_pec = wave_phase_velocity( C.epsilon_pec, ...    %    EM-wave phase-velocity
                                  C.mu_pec, ...         %    ```
                                  C.sigma_pec )      ;  %    ```
   C.eta_pec = wave_impedance( C.epsilon_pec, ...       %    EM-wave impedance
                               C.mu_pec, ...            %    ```
                               C.sigma_pec )         ;  %    ```
end

function vp = wave_phase_velocity(epsilon, mu, sigma, f)
% Phase velocity of an EM wave in a medium.
   arguments
      % Required positional args + validation:
      epsilon (1,1) {mustBeNumeric, mustBeReal, mustBePositive}
      mu      (1,1) {mustBeNumeric, mustBeReal, mustBePositive}
      sigma   (1,1) {mustBeNumeric, mustBeReal, mustBeNonnegative}
      % Optional args + validation:
      f       (1,1) {mustBeNumeric, mustBeReal} = NaN
   end
   if sigma > 0 && isnan(f)
      % --- Case 0: Default f / invalid options ---
      if( sigma >= 5.8e7 ) % This is PEC, ok
         vp = 0 ;
      else
         error('For a lossy medium (sigma > 0), frequency argument ''f'' must be provided.') ;
      end
   elseif sigma == 0
      % --- Case 1: Lossless Medium (Perfect Dielectric) ---
      vp = 1 / sqrt(epsilon * mu) ;
   else
      % --- Case 2: Lossy Medium (Conducting Medium) ---
      omega = 2 * pi * f ;
      loss_tangent_sq = (sigma / (omega * epsilon))^2 ;
      beta = omega * sqrt( (mu * epsilon / 2) * (sqrt(1 + loss_tangent_sq) + 1) ) ;
      vp = omega / beta ;
   end
end

function eta = wave_impedance(epsilon, mu, sigma, f)
% Intrinsic EM-wave impedance of a medium.
   arguments
      % Required positional args + validation:
      epsilon (1,1) {mustBeNumeric, mustBeReal, mustBePositive}
      mu      (1,1) {mustBeNumeric, mustBeReal, mustBePositive}
      sigma   (1,1) {mustBeNumeric, mustBeReal, mustBeNonnegative}
      % Optional args + validation:
      f       (1,1) {mustBeNumeric, mustBeReal} = NaN
   end
   if( sigma > 0 && isnan(f) )
      % --- Case 0: Default f / invalid options ---
      if( sigma >= 5.8e7 ) % This is PEC, ok
         eta = 0 ;
      else
         error('For a lossy medium (sigma > 0), frequency argument ''f'' must be provided.') ;
      end
   elseif( sigma == 0 )
      % --- Case 1: Lossless Medium (Perfect Dielectric) ---
      eta = sqrt(mu / epsilon);
   else
      % --- Case 2: Lossy Medium (Conducting Medium) ---
      omega = 2 * pi * f;
      numerator = 1j * omega * mu;
      denominator = sigma + 1j * omega * epsilon;
      eta = sqrt(numerator / denominator);
   end
end
