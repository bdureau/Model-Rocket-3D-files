/****************************************************************
* Secant ogive nose cone (optimized version)
*
* alpha = arctan(R/L) - arccos(sqrt(L^2 + R^2) / 2rho)
* y     = sqrt(rho^2 - (rho*cos(alpha) - x)^2) + rho*sin(alpha)
*                                               (x measured from the tip)
*
* rho is a free parameter:
*   rho = rhoTangent            -> tangent ogive (the original file did
*                                  this, so it was not a real secant)
*   rho > rhoTangent            -> classic secant ogive (meets the body
*                                  tube at an angle)
*   sqrt(L^2+R^2)/2 < rho < rhoTangent -> bulging ogive (wider than R)
*
* Optimization: the profile is a circular arc, sampled at a constant
* angular step and revolved by ONE rotate_extrude, instead of a union
* of 100 stacked cylinders.
*
* Orientation: base at Z = 0, tip at Z = L.
*****************************************************************/

/* ---------- parameters ---------- */
L = 100;               // nose cone length (mm)
R = 24/2;              // base radius (mm)
rhoTangent = (R*R + L*L) / (2*R);
rho = 1.5 * rhoTangent; // ogive radius (mm), see above

/* ---------- quality settings ---------- */
profileSegments = 60;  // segments along the profile
fnAround        = 100; // segments around the axis

/* Do not modify anything after that unless you know what you are doing */

assert(rho >= sqrt(L*L + R*R) / 2,
       "rho is too small: it must be >= sqrt(L^2 + R^2) / 2");

alpha = atan(R/L) - acos(sqrt(L*L + R*R) / (2*rho));

// Circle center in [radius, z] coordinates (z = L - x)
rc = rho * sin(alpha);
zc = L - rho * cos(alpha);

// Arc angles at the base [R, 0] and at the tip [0, L]
t0 = atan2(0 - zc, R - rc);
t1 = atan2(L - zc, 0 - rc);

// Profile points [radius, z], from the base (z = 0) to the tip (z = L)
function noseProfilePoints() =
    [for (i = [0:profileSegments]) let(t = t0 + (t1 - t0) * i / profileSegments)
        (i == 0)               ? [R, 0] :
        (i == profileSegments) ? [0, L] :
                                 [max(0, rc + rho * cos(t)), zc + rho * sin(t)]];

// 2D half-section, closed along the axis
module noseProfile() {
    polygon(concat([[0, 0]], noseProfilePoints()));
}

module ogive() {
    rotate_extrude($fn = fnAround) noseProfile();
}

ogive();
