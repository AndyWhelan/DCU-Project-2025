function R = specular_reflectance( tx_d, tx_h, rx_d, rx_h, ...
				   n1, n2, len_wall, perp ) % reflected power
    % perp decides the EM-wave polarization relative to plane of incidence P.
    % If true, oscillation is perpendicular to P; if false, it's parallel.
    R = specular_reflection_coefficient( tx_d, tx_h, rx_d, rx_h, ...
					 n1, n2, len_wall, perp );
    mag_r = abs( R );
    R = mag_r * mag_r;
end
