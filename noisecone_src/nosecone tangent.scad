/****************************************************************
* Tangent ogive nose cone (optimized version)
*
* phi = (R^2 + L^2) / 2R
* y   = sqrt(phi^2 - (L - x)^2) + R - phi      (x measured from the tip)
*
* Optimization: the profile is a 2D polygon revolved by ONE
* rotate_extrude, instead of a union of stacked cylinders.
* A tangent ogive is a circular arc of radius phi, so it is sampled at a
* constant angular step: equal-length segments, no wasted points.
*
* Orientation: base at Z = 0, tip at Z = L.
*****************************************************************/

/* ---------- parameters ---------- */
L = 100;               // nose cone length (mm)
R = 24/2;              // base radius (mm)

/* ---------- quality settings ---------- */
profileSegments = 30;  // segments along the profile
fnAround        = 30;  // segments around the axis

/* Do not modify anything after that unless you know what you are doing */

phi  = (R*R + L*L) / (2*R);   // ogive radius
tMax = asin(L / phi);         // arc angle from base to tip

// Profile points [radius, z], from the base (z = 0) to the tip (z = L)
function noseProfilePoints() =
    [for (i = [0:profileSegments]) let(t = tMax * i / profileSegments)
        (i == profileSegments) ? [0, L]
                               : [max(0, (R - phi) + phi * cos(t)), phi * sin(t)]];

// 2D half-section, closed along the axis
module noseProfile() {
    polygon(concat([[0, 0]], noseProfilePoints()));
}

module ogive() {
    rotate_extrude($fn = fnAround) noseProfile();
}

ogive();
