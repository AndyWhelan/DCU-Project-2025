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

* Wall with ~~fixed length `len_wall`~~ infinite length,
* Source centred at `( tx_d, tx_h )`,
* Reflection point `( rx_d, rx_h )` varies between `( rx_init_d, rx_init_h )` and `( rx_final_d, rx_final_h )`,
* Wall is P.E.C (perfect electrical conductor)
## Assumptions
* Rx at reflection point treated as a point.
* Cylindrical wave emanating from Tx.

# Files
## [`parameters.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/parameters.m)
Setup the parameters for plots and simulations.

## [`plot_cumulative_power_po.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/plot_cumulative_power_po.m)
Plot the cumulative power or electric field as integrated along the wall.

## [`PO_flat_strip.m`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/PO_flat_strip.m)
Conor's code for 2d setup with some indentation, commenting, and minor relabeling.

## [`old/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/old/)
Previous files that may be useful later.

## [`functions/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/functions/)
MATLAB files with function definitions for calculations.

## [`supplementary_files/`](https://github.com/AndyWhelan/DCU-Project-2025/blob/main/supplementary_files/)
### [`literature_review/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/literature_review/)
### [`meetings/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/meetings/)
### [`papers/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/papers)
### [`presentation/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/presentation)
### [`various_notes/`](https://github.com/AndyWhelan/DCU-Project-2025/tree/main/supplementary_files/various_notes)
