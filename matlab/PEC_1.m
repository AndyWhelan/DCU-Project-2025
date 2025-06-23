% Compare the squared magnitude of the electric field phasor for the setup:
%                                             
%  (r_x0, r_y) ────────────────────────────── (r_x, r_y) ──────────────── (r_xe, r_y)
%                                                 /        
%                (t_x, t_y)                    /           
%                     \                     /              
%                      \                 /                 
%                       \             /                    
%                        \  ╎      /                       
%                         \ ╎   /                          
%                          \╎/                             
% (0,0) ━━━━━━━━━━━━━━━ (w_x, 0) ━━━━━━━━━━━━━━━━━━━━ (w, 0)
% 
% We assume a cylindrical wave incident field
% The models used to compare are:
% 1. Effective Roughness (ER) Lambertian model 
%    (overall ER contribution is an integral along the points of the wall), and
% 2. Geometrical Optics  (GO).
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
for(N_r = 1:N_rx)
   r_x = strip_start_x + (N_r-0.5)*spacing_x             ; % Rx position calc
   E_r_sq = specular_intensity( eta_1, eta_2, mu_r1, ...
                                mu_r2, t_x, t_y, ...
                                r_x, r_y, ...
                                strip_start_x, w, ...
                                spec_refl( N_r ), P0 )   ; % specular intensity calc
   E_s_sq = er_lambertian_intensity( S, eta_1, P0, ...
                                     delta_x, t_x, ...
                                     t_y, r_x, r_y, ...
                                     N_strip )           ; % er lamb intensity calc
%                                                                                     TODO: (P1):
%                                                                                     1. Plot some initial graphs,
%                                                                                     2. Tighten up the formulae,
%                                                                                     3. Tighten up parameters and rigor.

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

   % STRIP DIMENSIONS:
   P.w = 40.0*P.lambda                                    ; % STRIP LENGTH
   P.strip_start_x = 0                                    ; % sum starts at origin    TODO: (P1) rename properly to tie in with diagram above
   P.strip_end_x = 1.5*P.w                                ; % more than strip len     TODO: (P1) ```

                                                                                     
   % WALL SHAPE:                                                                      TODO: (P3) Currently unused. To use later when model generalised a bit
   P.lambda_strip = P.w * 100                             ; % WALL PROFILE WAVELENGTH
   P.A_strip = 0                                          ; % PROFILE AMPLITUDE

   % NUMERICAL PARAMETERS:
   P.disc_per_wavelength = 20                             ; % samples per wavelength
   P.N_strip = ceil((P.w/P.lambda)*P.disc_per_wavelength) ; % # sim-points on strip
   P.delta_x = P.w/P.N_strip                              ;
   P.N_rx  = 1000                                         ; % NUMBER OF RECEIVERS
   P.spacing_x = (P.strip_end_x - P.strip_start_x)/P.N_rx ; %

   % ANTENNA POSITIONS
   P.r_y = 5* P.lambda                                    ; % RX HEIGHT :             TODO: (P3) justify later. Maybe use the far-field definition
   P.t_x = 0                                              ; % TX POS    :  0
   P.t_y = 0.7 * P.r_y                                    ; % TX HEIGHT :             TODO: (P3) ```

   % ER-MODEL:                                                                        TODO: (P2) vary the ER-model param
   P.P_p = 0                                              ; % TRANSMITTED POWER       TODO: (P3) tie the transmitted power in with the constitutive parameters
   P.S = 0.1                                              ; % SCATTERED POWER (sqrt)
   P.Gamma = zeros(1, P.N_rx)                             ; % FRESNEL COEFFICIENTS
   P.R = zeros(1, P.N_rx)                                 ; % SPECULAR POWER (sqrt)
   for(P.N_r = 1:P.N_rx)
      P.spec_refl = specular_reflectance(  eta_1, ...
                                           eta_2, ...
                                           mu_r1, ...
                                           mu_r2, ...
                                           t_x, t_y, ...
                                           r_x, r_y )     ;
      P.Gamma( P.N_r ) = sqrt( P.spec_refl )              ;
      P.R( P.n_r ) = sqrt( 1 - (P.S)^2 - (P.P_p / P.P_0) ) / ...
                        P.Gamma( P.N_r )
   end
end

function I = er_lambertian_intensity( S, ...
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
   dI = ( ((S^2) * eta_1 * P0 * ( cos( theta_i )) * (cos(theta_s)) * delta_x ) / ...
          (2*pi*dist_i*dist_s) )
   I = I + dI 
end
end
%
function I = specular_intensity( eta_1, eta_2, mu_r1, mu_r2, t_x, t_y, r_x, r_y, ...
                                 x_start, len_strip, reflectance, P0 )
   I = 0 ;
   theta_i = atan( (r_y + t_y)/(r_x - t_x) ) ;
   spec_shear = r_y * tan( theta_i ) ;
   if( spec_shear <= r_x && r_x <= spec_shear + len_strip )
      dist = sqrt( (r_x - t_x)^2 + (r_y + t_y)^2 ) ; % total specular distance
      I = 2 * eta_1 * P0 * ( 1 / dist ) * reflectance ;
   end
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
      f       (1,1) {mustBeNumeric, mustBeReal, mustBePositive} = []
   end
   if sigma > 0 && isempty(f)
      % --- Case 0: Incorrect usage ---
      error('For a lossy medium (sigma > 0), frequency argument ''f'' must be ...
            provided.') ;
   end
   if sigma == 0
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
      f       (1,1) {mustBeNumeric, mustBeReal, mustBePositive} = []
   end
   if sigma > 0 && isempty(f)
      if( sigma == 5.8e7 ) % This is PEC, ok
         eta = 0 ;
      else
         error('For a lossy medium (sigma > 0), frequency argument ''f'' must be ...
               provided.') ;
      end
   end
   if sigma == 0
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
