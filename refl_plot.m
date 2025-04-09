%{
1. Calculate the reflection power coefficients for a range of values
2. 3d-plot it for varying rx_d,rx_h
%}

parameters
% Calculation for plot:
rx_d = linspace(rx_init_d,rx_final_d,rx_steps);
rx_h = linspace(rx_init_h,rx_final_h,rx_steps);
refl = zeros(rx_steps,rx_steps);
for i=1:rx_steps
    for j=1:rx_steps
        refl(i,j) = spec_refl(tx_d,tx_h,rx_d(i),rx_h(j),n1,n2,len_wall,perp);    
    end
end

% Plot setup
surf(rx_d,rx_h,refl);
title('Specular-Reflectance for Varying Rx Position')
%TODO: clean up subtitle
subtitle(['Tx wall-position: ' int2str(tx_d), ', Tx wall-distance: ' int2str(tx_h), ', Wall-length : ', int2str(len_wall)]);
xlabel('Rx wall-position')
ylabel('Rx wall-distance')
%TODO: sensibility checks for graph
%TODO: think about the fact that it's radiation, how should Rx register "hit"?