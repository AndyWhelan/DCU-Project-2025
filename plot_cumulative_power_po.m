%{
1. Calculate the Physical Optics path contribution along a wall,
2. Plot it versus wall position, showing the specular wall position also.
%}

% Linking:
parameters % setup variables as per `./parameters.m`
addpath( genpath( './functions' )); % for function access

% Calculation for plot:
for j=1:wall_steps
    path_contribution( j ) = path_component( tx_d, tx_h, rx_d, rx_h, ...
                                             wall_positions( j ), ...
                                             wavenumber, perp, hankel_approx ) * delta_wall
    sum_pc( j ) = sum( path_contribution( 1:j )) 
    power(j) = abs( sum_pc( j )) ^ 2 
end
spec_wall_pos = specular_reflected_wall_position( tx_d, tx_h, rx_d, rx_h ) 
%plot( wall_positions, sum_pc )
plot( wall_positions, power )
xline( spec_wall_pos )