function nv = normal_vector( ct, lambda_wall, A_wall )
    % Assume wall is of form A_wall * sin( 2pi*ct/lambda_wall )
    % So derivative is A_wall * (2*pi/lambda_wall) * cos( 2*pi*ct/lambda_wall )
    m_tangent =  A_wall * ( 2*pi/lambda_wall ) * cos( 2*pi*ct/lambda_wall ) ;
    if m_tangent==0
       nv = [ 0; 1; 0 ] ; 
    else
       m_normal = 1/m_tangent ;
       if m_normal > 0
          x_normal = 1 / sqrt( 1 + m_normal^2 );
       else
          x_normal = -1 / sqrt( 1 + abs( m_normal^2 ));
       end
       y_normal = abs( m_normal ) * abs( x_normal ); % normal always upward-pointing
       nv = [ x_normal, y_normal, 0 ] ;
    end
end
