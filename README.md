***NB: MATLAB files are separated out and linked. Should clone this repo to get `plot_specular_reflectance.m` working.***
# Setup

                  ( tx_d, tx_h )                                              
                        \                                                
                         \             ( rx_d, rx_h )                  
                          \                 /                           
                           \               /                            
                            \             /                             
                             \           /                              
                              \         /                               
                +--------------\       /                                
                |               \     /                                 
                | pi/2 - angle_i \   /                                  
                |                 \ /                                   
    ( 0, 0 ) --------------- ( refl_d, 0 ) ---------- ( len_wall, 0 )

* Wall with fixed length `len_wall`,
* Origin set at one edge of wall,
* Source centred at `( tx_d, tx_h )`,
* Reflection point `( rx_d, rx_h )` varies between `( rx_init_d, rx_init_h )` and `( rx_final_d, rx_final_h )`,
## Assumptions
* Rx at reflection point currently treated as a point. **Adjust to either be of fixed length or with a radius of tolerance?**
* No assumption yet on Tx radiation pattern (just calculation of reflectance for a given ray).

# Files
## [`parameters.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/parameters.m)
Setup the parameters for the 3d-plot

## [`plot_specular_reflectance.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/plot_specular_reflectance.m)
1. Calculate the reflection power coefficients for a range of receiver positions,
2. 3d-plot it.

## [`functions/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/functions/)
This folder contains MATLAB files with function definitions for calculating reflectance.

## [`supplementary_files/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/supplementary_files/)
### [`literature_review/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/literature_review/)
### [`meetings/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/meetings/)
### [`papers/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/papers)
### [`presentation/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/presentation)
### [`various_notes/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/various_notes)

# TODO
1. Adjust coordinate system to match that in paper of Degli-Esposti.
2. Rethink scaling
3. Sensibility checks on plot_specular_reflectance.m graph
4. Try using the spectral reflectance to calculate the received power for antennas with a radius of tolerance.
