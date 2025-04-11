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
### [`literature_review/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/literature_review)
### [`papers/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/papers)
### [`presentation/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/presentation)
### [`various_notes/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/various_notes)

# Meetings

## April 11 2025

### Questions

* **Tx/Rx Geometry**: current approach is to calculate reflectance between point sources for one wall of fixed length, with varying receiver positions. **What's the appropriate way to complete this portion? i.e. should we go with:**
    * **spherical Tx radiation or non-uniform?**
    * **curved Rx or sphere?**
* **Vector/Wavenumber Questions**: you had mentioned a complex vector involving `-k*R` for complex arg and `1 / ( sqrt( k*R ))` as the complex magnitude.
    * **Is `R` the position vector or reflectance?**
    * **Is there a source for this equation?**
    * **Is the magnitude correct? It seems like having the magnitude be inversely proportional to (sqrt of) `R` is wrong. Why would a high reflectance result in small contribution?**
    * **Is the complex arg correct? I can see a reference to a position vector `r` but not reflectance `R`. Also, what about the negative sign?**
    * **I assume we'll be doing a sort of integral/sum over these contributions?**
* **Next Meeting**: should probably have more frequent. Any availability from Friday week?

# TODO
1. Adjust coordinate system to match that in paper of Degli-Esposti.
2. Rethink scaling
3. Sensibility checks on plot_specular_reflectance.m graph
4. Try using the spectral reflectance to calculate the received power for antennas with a radius of tolerance.
