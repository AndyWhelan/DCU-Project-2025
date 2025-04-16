function gf = greens_function( k, r, approx )
    % Keeping the below for comparison to 3d case
    %gf = exp( -i * k * r ) / ( 4*pi*r) 
    if approx
        hankel_part = sqrt( 2 / ( pi * k * r )) * exp( -i * ( k * r - pi/4 ))
    else
        hankel_part = hankel_2( 0, k * r )
    end
    gf = ( i/4 ) * hankel_part
end
function H = hankel_2( alpha, Z )
    H = besselj( alpha, Z ) - i * bessely( alpha, Z )
end
