function fc = fresnel_coefficients( tx_d, tx_h, wall_pos, n1, n2, perp )
    angle_i = angle_of_incidence( tx_d, tx_h, wall_pos );
    angle_t = angle_of_transmission( tx_d, tx_h, wall_pos, n1, n2 )
    if perp
        fc = -( sin( angle_i - angle_t ))/( sin( angle_i + angle_t ));
    else
        fc = ( tan( angle_i - angle_t ))/( tan( angle_i + angle_t ));
    end
end
function at = angle_of_transmission( tx_d, tx_h, wall_pos, n1, n2 )
    angle_i = angle_of_incidence( tx_d, tx_h, wall_pos )
    at = asin( ( n1*sin( angle_i ))/n2 );
end
function ai = angle_of_incidence( tx_d, tx_h, wall_pos )
   ai = pi/2 - atan( tx_h / ( wall_pos - tx_d )) 
end
