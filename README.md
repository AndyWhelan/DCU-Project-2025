# Discussion for Meeting on 11-06-2025

1. I looked back at the papers and believe I have a grasp of what they're doing (see
   [next section](#effective-roughness-er-model) and discuss)
2. Given you agree with this, 

- I looked back at the papers

# Effective Roughness (ER) Model
## Assumptions
In the original ER model<sup>[[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf) ,[2](./papers/1.A_diffuse_scattering_model.pdf), [3](./papers/2.Measurement_and_Modelling_of_Scattering.pdf)]</sup>, the following assumptions are made (I use $dW$ instead of $dS$ for clarity, since we have the scattering parameter $S$)

1.  > ...consider a ray tube of solid angle $d \Omega$ impinging on the surface
    element ($dW$). Part of the power is reflected in the specular ray tube... part
    is transmitted and part is reflected toward the desination point $D$

    $    E = E_i + E_r + E_s + E_t,$
    where
    - $E$ is the total electric field,
    - $E_i$ is the ***i***ncident field, 
    - $E_r$ is the specularly ***r***eflected component of the scattered field,
    - $E_s$ is the diffusely ***s***cattered component of the scattered field, and
    - $E_t$ is the ***t***ransmitted component of the scattered field. 
    
2.  Lambertian local diffuse scattering: 
    $    \vert E_s \vert_{dW} \propto \sqrt{\cos \theta_s},$
    where $\theta_s$ is the scattering angle relative to the wall normal.
3.
    > $S$ ... defined as the ratio between local scattered field and incident field
    ... can be determined from scattered field measurements

    $    S:= \frac{\vert E_s \vert }{\vert E_i \vert}\vert_{dW} \ \ \text{is assumed to be constant for a given wall.}$

4.  The far-field is sufficiently close so that diffusely scattered waves interfere
    incoherently:
    $    \vert E_s \vert = \int_W \vert E_s \vert_{dW} \ dW.$

## Model Measures - Derivations
### Local Scattering Power Balance

Using the solid angle formula $d \Omega = \frac{dW \cos \theta_i}{r_i^2}$, along with
assumption 2, we equate the total power density (scaled by $\eta$, intrinsic 
impedance) of the scattered field, with respect to $E_i$ ($\vert E_s \vert_{dW}^2 \ r_i^2 \ d \Omega$) and $E_s$ ($ \iint_{\Omega} \vert E_s \vert_{dW}^2 \ r_s^2 d \Omega $), obtaining  

$\vert E_s \vert_{dW} = S \sqrt{\frac{dW \cos \theta_i \cos \theta_s}{\pi}} \frac{1}{r_s} 
\vert E_i \vert_{dW}.
$

Since $\theta_s$ will determine $\theta_i$ given fixed antenna positions, we can use
the above to compute the
- **Total Power** for a given setup (by utilising assumption 4),
- **Power-Angle Profile**, and
- **Scattering-angle Spread**

Expressing $r_s$, $\theta_i$ and $\theta_s$ in terms of setup parameters ( $(x_{Tx},y_{Tx}), (x_{Rx},y_{Rx})$ ) and distance along the wall $x$:
- $r_s = \sqrt{y^2_{Rx} + (x_{Rx} - x_{Tx} - x)^2}$,
- $\cos \theta_s = \frac{y_{Rx}}{r_s}$, and 
- $\cos \theta_i = \frac{y_{Tx}}{\sqrt{y^2_{Tx}+ x^2}}$

we can also derive:

$\vert E_s \vert_{dW} = S \sqrt{ \frac{dW \ y_{Rx} \ y_{Tx}}{\pi \ \left(y^2_{Tx}+x^2\right)^{\frac{1}{2}} \ \left(y^2_{Rx} + (x_{Rx} - x_{Tx} - x)^2\right)^{\frac{3}{4}}} } \ \vert E_i \vert_{dW}.
$

This can be used to directly compute the
- **Power-Distance Profile**, and
- **Path-length Spread**,

### Path Delay Conversion
Additionally, by converting each path distance to a delay, we can compute
- **Power-Delay Profile**, and 
- **Delay Spread**

The procedure for the conversion is as follows:
- Use coordinate system in [[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf)] translating the origin to the specular point of reflection $x \to x' = x - \left( x_i + y_i \frac{x_s - x_i}{y_s + y_i} \right)$
- $ct = \sqrt{(x'_i)^2 + (y_i)^2} + \sqrt{(x'_s)^2 + (y_s)^2}$, noting that $y' = y$,
- Square the above twice to remove all radicals,
- Reduce quartic to quadratic due to symmetry, and solve for $x'$,
- Retransform $x' \to x$.

<!-- {{{ MATLAB Code -->
# [MATLAB Code](./flat_strip_setup.m)
The code linked above uses functions from [./matlab_functions](./matlab_functions). The full, inlined version is pasted below:
<!--INLINE:flat_strip_setup.m-->
<!-- }}} -->
