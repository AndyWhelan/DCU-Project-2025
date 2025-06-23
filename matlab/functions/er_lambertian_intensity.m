function I = er_lambertian_intensity( S, ...
                                      eta_1, P0, ...
                                      delta_x, ...
                                      t_x, t_y, r_x, r_y, ...
                                      N_strip )
I = 0 ;
for( N_i = 1:N_strip )
   x_i_diff = (N_i - 0.5) * delta_x ;
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
