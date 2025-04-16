function pc = path_component( tx_d, tx_h, rx_d, rx_h, wall_pos, k, perp, approx )
    rx = [ rx_d rx_h ]
    tx = [ tx_d tx_h ]
    wall = [ wall_pos 0 ]
    r1 = norm( wall - tx )
    r2 = norm( rx - wall )
    
    electric_field_incident = greens_function( k, r1, approx ) 
    pc = electric_field_incident * greens_function( k, r2, approx )
end 
