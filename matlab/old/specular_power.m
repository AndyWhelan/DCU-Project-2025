function P = specular_power( eta_1, eta_2, mu_r1, mu_r2, t_x, t_y, r_x, r_y, ...
                             x_start, len_strip, P0 )
   %TODO: double-check the below! NB!
   P = 0 ;
   theta_i = specular_angle( t_x, t_y, r_x, r_y ) ;
   spec_shear = r_y * tan( theta_i ) ;
   if( spec_shear <= r_x && r_x <= spec_shear + len_strip )
      dist = sqrt( (r_x - t_x)^2 + (r_y + t_y)^2 ) ; % total specular distance
      P = P0 * ( 1 / dist ) * ...
               specular_refl_coef( eta_1, eta_2, mu_r1, mu_r2, theta_i ) ;
   end
end

function R = specular_refl_coef( eta_1, eta_2, mu_r1, mu_r2, theta_i )
   % s-polarized incident (E-field perp to plane of incidence, i.e. z-direction)
   theta_t = specular_transmission_angle( eta_1, eta_2, mu_r1, mu_r2, theta_i ) ;
   R = abs( gamma_s( eta_1, eta_2, theta_i, theta_t )) ;
   R = R * R ;
end

function G = gamma_s( eta_1, eta_2, theta_i, theta_t )
   G = ( eta_2 * cos( theta_i ) - eta_1 * cos( theta_t ) ) / ...
         ( eta_2 * cos(theta_i) + eta_1 * cos (theta_t) ) ;
end

function theta_t = specular_transmission_angle( eta_1, eta_2, mu_r1, mu_r2, theta_i )
   theta_t = asin( sqrt( (mu_r1 * eta_2 )/(mu_r2 * eta_1) ) * ...
                   sin( theta_i )) ;
end

function theta_r = specular_angle( t_x, t_y, r_x, r_y )
   theta_r = atan( (r_y + t_y)/(r_x - t_x) ) ; 
end
