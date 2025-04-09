%{
3d-plot a range of values for spec_reflectance for varying rx_d,rx_h
%}

parameters
surf(rx_d,rx_h,refl);
title('Specular-Reflectance for Varying Rx Position')
%TODO: clean up subtitle
subtitle(['Tx wall-position: ' int2str(tx_d), ', Tx wall-distance: ' int2str(tx_h), ', Wall-length : ', int2str(len_wall)]);
xlabel('Rx wall-position')
ylabel('Rx wall-distance')
%TODO: sensibility checks for graph
%TODO: think about the fact that it's radiation, how should Rx register "hit"?
