***NB: MATLAB files are separated out and linked. Should clone this repo to get `refl_plot.m` working.***

# Setup
Geometry setup: 2d wall of fixed length; fixed Tx; mobile Rx:
                 (tx_d,tx_h)                                              
                                                                        
                       \                                                
                        \          (rx_init_d,rx_init_h)                  
                         \                                              
                          \                 /                           
                           \               /                            
                            \             /                             
                             \           /                              
                              \         /                               
                +--------------\       /                                
                |               \     /                                 
                | pi/2-angle_i   \   /                                  
                |                 \ /                                   
    (0,0) -------------------- (refl_d,0) --------------- (len_wall,0)
# Folders/Files
## [`functions/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/functions/)
Function definitions for calculating reflectance values.

## [`parameters.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/parameters.m)
Setup the parameters for the 3d-plot

## [`plot_specular_reflectance.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/plot_specular_reflectance.m)
1. Calculate the reflection power coefficients for a range of receiver positions,
2. 3d-plot it.

# TODO
1. Rethink scaling
2. Sensibility checks on refl_plot.m graph
3. Try using the spectral reflectance to calculate the received power for antennas with a radius of tolerance.
