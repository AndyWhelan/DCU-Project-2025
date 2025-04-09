%{ 
1. Setup the parameters for the 3d-plot
2. Calculate the reflection power coefficients for a range of values
%}

% Geometry:
tx_d = 2;
tx_h = 10;
rx_init_d = 0;
rx_init_h = 0;
rx_final_d = 10*tx_d;
rx_final_h = 10*tx_h;
len_wall = 3*tx_d; %TODO: suggest sensible range of values

% Other physical parameters:
n1 = 1; % refractive index of air
n2 = 1.55; % refractive index of plaster wall: https://refractiveindex.info/?shelf=main&book=CaSO4&page=Querry-%CE%B2
perp=true; % EM-wave polarization relative to plane of incidence P.
% true: radiation oscillates perpendicular to P;
% false: radiation oscillates parallel to P.

% Numerical parameters:
rx_steps = 200; % number of steps for Rx to move from start to finish
%TODO: rethink scaling

% Calculation:
rx_d = linspace(rx_init_d,rx_final_d,rx_steps);
rx_h = linspace(rx_init_h,rx_final_h,rx_steps);
% populate refl matrix
refl = zeros(rx_steps,rx_steps);
for i=1:rx_steps
    for j=1:rx_steps
        refl(i,j) = spec_refl(tx_d,tx_h,rx_d(i),rx_h(j),n1,n2,len_wall,perp);    
    end
end
