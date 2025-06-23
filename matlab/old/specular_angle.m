function theta_r = specular_angle( t_x, t_y, r_x, r_y )
   theta_r = atan( (r_y + t_y)/(r_x - t_x) ) ; 
end
