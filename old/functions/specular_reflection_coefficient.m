function R = specular_reflection_coefficient( tx_d, tx_h, rx_d, rx_h, ...
					      n1, n2, len_wall, perp )
    refl_d = specular_reflected_wall_position( tx_d, tx_h, rx_d, rx_h );
    if refl_d > len_wall
        R = 0; % since there won't be a real reflection point
    else
        angle_i = specular_angle_of_incidence( tx_d, tx_h, rx_d, rx_h );
        angle_t = specular_angle_of_transmission( tx_d, tx_h, rx_d, rx_h, ...
						  n1, n2 );
        if perp
            R = -( sin( angle_i - angle_t ))/( sin( angle_i + angle_t ));
        else
            R = ( tan( angle_i - angle_t ))/( tan( angle_i + angle_t ));
        end
    end
end
