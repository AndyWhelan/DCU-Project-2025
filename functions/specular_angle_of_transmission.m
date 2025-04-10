function T = specular_angle_of_transmission( tx_d, tx_h, rx_d, rx_h, n1, n2 )
    % n1 and n2 are refractive indices
    angle_i = specular_angle_of_incidence( tx_d, tx_h, rx_d, rx_h );
    T = asin( ( n1*sin( angle_i )) /n2 );
end
