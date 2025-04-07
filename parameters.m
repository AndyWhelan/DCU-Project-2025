% 3d-plot a range of values for spec_reflectance for varying rx_d,rx_h
tx_d = 2;
tx_h = 10;
n1 = 1;
n2 = 1.5; % e.g. plaster wall. TODO: reference
len_wall = 3*tx_d; %TODO: suggest sensible range of values
perp=true; % polarization. TODO: elaborate

steps = 200;
%TODO: rethink scaling
rx_init_d = 0;
rx_final_d = 10*tx_d;
rx_init_h = 0;
rx_final_h = 0.99*tx_h;

rx_d = linspace(rx_init_d,rx_final_d,steps);
rx_h = linspace(rx_init_h,rx_final_h,steps);
% populate refl matrix
refl = zeros(steps,steps);
for i=1:steps
    for j=1:steps
        refl(i,j) = spec_refl(tx_d,tx_h,rx_d(i),rx_h(j),n1,n2,len_wall,perp);    
    end
end
