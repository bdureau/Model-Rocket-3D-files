/****************************************************************
* Power series nose cone (optimized version)
*
* y = R * (x/L)^n                              (x measured from the tip)
*   n = 1    for a cone
*   n = 0.75 for a 3/4 power
*   n = 0.5  for a 1/2 power (parabola)
*   n = 0    for a cylinder
*
* Optimization: the profile is a 2D polygon revolved by ONE
* rotate_extrude, instead of a union of stacked cylinders.
* For n < 1 the curve is vertical at the tip, so the samples are
* packed towards the tip (x = L * u^q, q = 1/n, capped at 4) instead of
* being evenly spaced: a smooth tip with the same number of segments.
*
* Orientation: base at Z = 0, tip at Z = L.
*****************************************************************/

/* ---------- parameters ---------- */
n = 0.3;               // power series exponent (0..1)
L = 100;               // nose cone length (mm)
R = 24/2;              // base radius (mm)

/* ---------- quality settings ---------- */
profileSegments = 30;  // segments along the profile
fnAround        = 30;  // segments around the axis

/* Do not modify anything after that unless you know what you are doing */

assert(n >= 0, "n must be >= 0");

q = (n > 0) ? min(4, max(1, 1/n)) : 1;   // sample clustering exponent

// Profile points [radius, z], from the base (z = 0) towards the tip
function noseProfilePoints() =
    [for (i = [0:profileSegments - 1])
        let(u = 1 - i / profileSegments, x = L * pow(u, q))
            [R * pow(x / L, n), L - x]];

// 2D half-section, closed along the axis (tip point [0, L] added here
// so that n = 0 gives a clean cylinder)
module noseProfile() {
    polygon(concat([[0, 0]], noseProfilePoints(), [[0, L]]));
}

module ogive() {
    rotate_extrude($fn = fnAround) noseProfile();
}

ogive();
