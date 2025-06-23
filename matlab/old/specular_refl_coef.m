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
