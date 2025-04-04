%{
Geometry setup: 2d wall of fixed length; fixed Tx; mobile Rx:

                  tx = (tx_d,tx_h)                                              
                                                                          
                         \                                                
                          \         rx_init = (rx_init_d,rx_init_h)                  
                           \                                              
                            \                 /                           
                             \               /                            
                              \             /                             
                               \           /                              
                                \         /                               
                  +--------------\       /                                
                  |               \     /                                 
                  | pi/2-angle_inc \   /                                  
                  |                 \ /                                   
      (0,0) -------------------- (refl_d,0) ------------------ (len_wall,0)
%}
function D = spec_refl_point(tx_d,tx_h,rx_d,rx_h)
    % No check yet that the line joining image to Rx intersects the wall
    img_d = tx_d;
    img_h = -tx_h;
    % Equation of line joining image to Rx, setting y to 0
    D = img_d - img_h * ((rx_d-img_d)/(rx_h-img_h));
end
function A = spec_angle_inc(tx_d,tx_h,rx_d,rx_h)
    refl_d = spec_refl_point(tx_d,tx_h,rx_d,rx_h);
    A = pi/2 - atan(rx_h/refl_d);
end
function T = spec_angle_tran(tx_d,tx_h,rx_d,rx_h,n1,n2)
    % n1 and n2 are refractive indices
    angle_i = spec_angle_inc(tx_d,tx_h,rx_d,rx_h);
    T = asin((n1*sin(angle_i))/n2);
end
function R = spec_refl_coeff(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp)
    % perp is a bool, deciding the EM-wave polarization relative to plane
    % of incidence. TODO: elaborate a little.
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
function R = spec_reflectance(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp)
    R = spec_refl_coeff(tx_d,tx_h,rx_d,rx_h,n1,n2,len_wall,perp);
    mag_r = abs(R);
    R = mag_r * mag_r;
end

% 3d-plot a range of values for spec_reflectance for varying rx_d,rx_h
tx_d = 2;
tx_h = 10;
n1 = 1;
n2 = 1.5; % e.g. plaster wall. TODO: reference
len_wall = 3*tx_d; %TODO: suggest sensible range of values
perp=true; % polarization. TODO: elaborate

steps = 200;
%TODO: rethink scaling
rx_init_d = 0;
rx_final_d = 10*tx_d;
rx_init_h = 0;
rx_final_h = 0.99*tx_h;

rx_d = linspace(rx_init_d,rx_final_d,steps);
rx_h = linspace(rx_init_h,rx_final_h,steps);
% populate refl matrix
refl = zeros(steps,steps);
for i=1:steps
    for j=1:steps
        refl(i,j) = spec_reflectance(tx_d,tx_h,rx_d(i),rx_h(j),n1,n2,len_wall,perp);    
    end
end
surf(rx_d,rx_h,refl);
title('Spectral Reflectance Coefficient for Varying Rx Position')
%TODO: clean up subtitle
subtitle(['Tx wall-position: ' int2str(tx_d), ', Tx wall-distance: ' int2str(tx_h)]);
xlabel('Rx wall-position')
ylabel('Rx wall-distance')
%TODO: sensibility checks for graph
