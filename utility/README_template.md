# Discussion for Meeting on 11-06-2025

1. I looked back at the papers and believe I have a grasp of what they're doing (see [Effective Roughness (ER) Model](#effective-roughness-er-model) section and discuss)
2. Given you agree with this...

- I looked back at the papers

---

# Effective Roughness (ER) Model

## Assumptions

In the original ER model<sup>[[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf), [2](./papers/1.A_diffuse_scattering_model.pdf), [3](./papers/2.Measurement_and_Modelling_of_Scattering.pdf)]</sup>, the following assumptions are made (I use `dW` instead of `dS` for clarity, since we have the scattering parameter `S`):

1. > "...consider a ray tube of solid angle `dΩ` impinging on the surface element (`dW`). Part of the power is reflected in the specular ray tube... part is transmitted and part is reflected toward the destination point `D`."

   \[
   E = E_i + E_r + E_s + E_t
   \]

   where:
   - \( E \) is the total electric field,
   - \( E_i \) is the **i**ncident field,
   - \( E_r \) is the specularly **r**eflected component of the scattered field,
   - \( E_s \) is the diffusely **s**cattered component of the scattered field, and
   - \( E_t \) is the **t**ransmitted component of the scattered field.

2. Lambertian local diffuse scattering:

   \[
   |E_s|_{dW} \propto \sqrt{\cos \theta_s}
   \]

   where \( \theta_s \) is the scattering angle relative to the wall normal.

3. > "`S` ... defined as the ratio between local scattered field and incident field ... can be determined from scattered field measurements"

   \[
   S := \frac{|E_s|}{|E_i|}\big|_{dW} \quad \text{is assumed to be constant for a given wall.}
   \]

4. The far-field is sufficiently close so that diffusely scattered waves interfere incoherently:

   \[
   |E_s| = \int_W |E_s|_{dW} \ dW
   \]

---

## Model Measures – Derivations

### Local Scattering Power Balance

Using the solid angle formula:

\[
d\Omega = \frac{dW \cos \theta_i}{r_i^2}
\]

along with assumption 2, we equate the total power density (scaled by \( \eta \), the intrinsic impedance) of the scattered field with respect to \( E_i \) (via \( |E_s|_{dW}^2 \ r_i^2 \ d\Omega \)) and \( E_s \) (via \( \iint_{\Omega} |E_s|_{dW}^2 \ r_s^2 d\Omega \)), obtaining:

\[
|E_s|_{dW} = S \sqrt{ \frac{dW \cos \theta_i \cos \theta_s}{\pi} } \frac{1}{r_s} |E_i|_{dW}
\]

Since \( \theta_s \) determines \( \theta_i \) given fixed antenna positions, we can use the above to compute:
- **Total Power** for a given setup (using assumption 4),
- **Power-Angle Profile**, and
- **Scattering-Angle Spread**

---

### Coordinate-Based Expressions

Expressing \( r_s \), \( \theta_i \), and \( \theta_s \) in terms of setup parameters — \( (x_\text{Tx}, y_\text{Tx}), (x_\text{Rx}, y_\text{Rx}) \), and distance along the wall \( x \):

- \( r_s = \sqrt{y_\text{Rx}^2 + (x_\text{Rx} - x_\text{Tx} - x)^2} \)
- \( \cos \theta_s = \frac{y_\text{Rx}}{r_s} \)
- \( \cos \theta_i = \frac{y_\text{Tx}}{ \sqrt{y_\text{Tx}^2 + x^2} } \)

This leads to:

\[
|E_s|_{dW} = S \sqrt{ \frac{dW \ y_\text{Rx} \ y_\text{Tx}}{ \pi \left( y_\text{Tx}^2 + x^2 \right)^{1/2} \left( y_\text{Rx}^2 + (x_\text{Rx} - x_\text{Tx} - x)^2 \right)^{3/4} } } \ |E_i|_{dW}
\]

This expression can be used to compute:
- **Power–Distance Profile**
- **Path-Length Spread**

---

### Path Delay Conversion

Additionally, by converting each path distance to a delay, we can compute:
- **Power–Delay Profile**
- **Delay Spread**

Procedure:
- Use the coordinate system from [[1](./papers/11.Evaluation_of_the_role_of_diffuse_scattering_in_urban_microcellular_propagation.pdf)], translating the origin to the specular reflection point:

  \[
  x \to x' = x - \left( x_i + y_i \frac{x_s - x_i}{y_s + y_i} \right)
  \]

- Path length:

  \[
  ct = \sqrt{(x'_i)^2 + y_i^2} + \sqrt{(x'_s)^2 + y_s^2}
  \]

  (note that \( y' = y \))

- Square twice to eliminate radicals
- Reduce the resulting quartic to a quadratic using symmetry and solve for \( x' \)
- Retransform using \( x' \to x \)

---

## [MATLAB Code](./flat_strip_setup.m)

The code linked above uses functions from the [`./matlab_functions`](./matlab_functions) directory. The full, inlined version is pasted below:

<!-- {{{ MATLAB Code -->
# [MATLAB Code](./flat_strip_setup.m)
The code linked above uses functions from [./matlab_functions](./matlab_functions). The full, inlined version is pasted below:
<!--INLINE:flat_strip_setup.m-->
<!-- }}} -->
