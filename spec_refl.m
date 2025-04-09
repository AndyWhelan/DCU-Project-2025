%{
Geometry setup: 2d wall of fixed length; fixed Tx; mobile Rx:

                   (tx_d,tx_h)                                              
                                                                          
                         \                                                
                          \          (rx_init_d,rx_init_h)                  
                           \                                              
                            \                 /                           
                             \               /                            
                              \             /                             
                               \           /                              
                                \         /                               
                  +--------------\       /                                
                  |               \     /                                 
                  | pi/2-angle_i   \   /                                  
                  |                 \ /                                   
      (0,0) -------------------- (refl_d,0) ------------------ (len_wall,0)
%}
function R = spec_refl(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp) % reflected power
    % perp decides the EM-wave polarization relative to plane of incidence P.
    % If true, oscillation is perpendicular to P; if false, it's parallel.
    R = spec_refl_coeff(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp);
    mag_r = abs(R);
    R = mag_r * mag_r;
end
function R = spec_refl_coeff(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp) % reflection coefficients
    refl_d = spec_refl_point(tx_d,tx_h,rx_d,rx_h);
    if refl_d > len_wall
        R = 0; % since there won't be a real reflection point
    else
        angle_i = spec_angle_inc(tx_d,tx_h,rx_d,rx_h);
        angle_t = spec_angle_tran(tx_d,tx_h,rx_d,rx_h,n1,n2);
        if perp
            R = -(sin(angle_i - angle_t))/(sin(angle_i + angle_t));
        else
            R = (tan(angle_i - angle_t))/(tan(angle_i + angle_t));
        end
    end
end
function T = spec_angle_tran(tx_d,tx_h,rx_d,rx_h,n1,n2) % angle of transmission
    % n1 and n2 are refractive indices
    angle_i = spec_angle_inc(tx_d,tx_h,rx_d,rx_h);
    T = asin((n1*sin(angle_i))/n2);
end
function A = spec_angle_inc(tx_d,tx_h,rx_d,rx_h) % angle of incidence
    refl_d = spec_refl_point(tx_d,tx_h,rx_d,rx_h);
    A = pi/2 - atan(rx_h/refl_d);
end
function D = spec_refl_point(tx_d,tx_h,rx_d,rx_h) % reflected point wall position
    % No check yet that the line joining image to Rx intersects the wall
    img_d = tx_d;
    img_h = -tx_h;
    % Equation of line joining image to Rx, setting y to 0
    D = img_d - img_h * ((rx_d-img_d)/(rx_h-img_h));
end
