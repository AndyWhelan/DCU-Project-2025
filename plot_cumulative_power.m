%{
1. Calculate the reflection power coefficients for a range of receiver positions
2. 3d-plot it
%}

% Linking:
parameters % setup variables as per `./parameters.m`
addpath( genpath( './functions' )); % for function access

% Calculation for plot:
for j=1:wall_steps
    pc( j ) = specular_path_component( tx_d, tx_h, rx_d, rx_h, n1, n2, ...
                                       wall_positions( j ), wavenumber, ...
                                       perp, hankel_approx )
    if isnan( pc( j ))
        pc( j ) = 0;
    end
    cpc( j ) = sum( pc( 1:j ))
end
plot( wall_positions, cpc )