function D = specular_reflected_wall_position( tx_d, tx_h, rx_d, rx_h ) % reflected point wall position
    % No check yet that the line joining image to Rx intersects the wall
    img_d = tx_d;
    img_h = -tx_h;
    % Equation of line joining image to Rx, setting y to 0
    D = img_d - img_h * ( ( rx_d - img_d ) / ( rx_h - img_h ));
end
