/****************************************************************
* Elliptical nose cone (optimized version)
*
* y = R * sqrt(1 - x^2 / L^2)                  (x measured from the base)
*
* Optimization: the profile is a 2D polygon revolved by ONE
* rotate_extrude, instead of a union of stacked cylinders.
* The ellipse is sampled with its parametric angle
* (r = R*cos(t), z = L*sin(t)), which puts more points near the blunt
* tip, where the curve turns fastest, and fewer along the flat sides.
*
* Orientation: base at Z = 0, tip at Z = L (the original file had the
* tip at Z = 0, unlike the other nose cone files).
*****************************************************************/

/* ---------- parameters ---------- */
L = 100;               // nose cone length (mm)
R = 24/2;              // base radius (mm)

/* ---------- quality settings ---------- */
profileSegments = 30;  // segments along the profile
fnAround        = 30;  // segments around the axis

/* Do not modify anything after that unless you know what you are doing */

// Profile points [radius, z], from the base (z = 0) to the tip (z = L)
function noseProfilePoints() =
    [for (i = [0:profileSegments]) let(t = 90 * i / profileSegments)
        (i == profileSegments) ? [0, L] : [R * cos(t), L * sin(t)]];

// 2D half-section, closed along the axis
module noseProfile() {
    polygon(concat([[0, 0]], noseProfilePoints()));
}

module ogive() {
    rotate_extrude($fn = fnAround) noseProfile();
}

ogive();
