function A = specular_angle_of_incidence( tx_d, tx_h, rx_d, rx_h )
    refl_d = specular_reflected_wall_position( tx_d, tx_h, rx_d, rx_h );
    A = pi/2 - atan( rx_h/refl_d );
end
