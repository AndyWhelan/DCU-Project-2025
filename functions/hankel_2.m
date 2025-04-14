function H = hankel_2( Z )
    H = besselj( 0, Z ) - i * bessely( 0, Z )
end
