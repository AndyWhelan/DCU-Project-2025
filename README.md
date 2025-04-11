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

## [`supplementary_files/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/supplementary_files/)
Mainly files from earlier in the project (presentation, lit. review, etc.) but also some notes.

# Meetings

## April 11 2025

### Questions

1. **Tx/Rx Geometry**: current approach is to calculate reflectance between point sources for one wall of fixed length, with varying receiver positions. **What's the appropriate way to complete this portion? i.e. should we go with:
    i. 	spherical Tx radiation or non-uniform?
    ii. curved Rx or sphere?**
2. **Vector/Wavenumber Questions**: you had mentioned a complex vector involving `-k*R` for complex arg and `1 / ( sqrt( k*R ))` as the complex magnitude. I assume we'll be doing a sort of integral/sum over these contributions?

# TODO
1. Rethink scaling
2. Sensibility checks on refl_plot.m graph
3. Try using the spectral reflectance to calculate the received power for antennas with a radius of tolerance.
