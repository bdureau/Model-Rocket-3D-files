/****************************************************************
* Shared parameters + shared modules for the 100 mm / 365 mm nose cone
* author: Boris du Reau
* This file is included by all the other files.
*****************************************************************/

/* ---------- parameters (unchanged) ---------- */
ogiveLenght = 365;
thickness   = 3;
baseDiam    = 100;
nosebottom  = 8;
couplerOutDiameter  = 97;
couplerOutDiameter2 = 97;
holeDiam      = 3.5;
couplerHeight = 90;

couplerThickness  = 3;
couplerResolution = 200;   // segments around the axis (revolved parts)

pistonCapHeight = 7;
noiseBase       = 100;
bouchonHeight   = 3;       // thickness of the CNC-cut bottom cap (Part 3)

/* ---------- speed / quality settings ---------- */
// Segment length along the ogive profile (mm).
// The ogive radius of curvature is ~1360 mm: with 3 mm segments the
// deviation from the true curve is < 0.001 mm, invisible once printed.
ogiveSegLen = 3;
ogiveFn     = 100;   // segments around the axis for the ogive
holeFn      = 24;    // segments for the small screw holes (3.5 / 4.5 mm)

/* ---------- derived values ---------- */
screwR = (couplerOutDiameter/2) - 6;   // radius of the 4-screw bolt circle
eps    = 0.05;                         // avoids coincident faces

/* ---------- shared modules ---------- */

// Places children() at the 4 screw positions (0°, 90°, 180°, 270°)
module screwPattern() {
    for (a = [0:90:270]) rotate([0, 0, a]) translate([screwR, 0, 0]) children();
}

// 2D profile of a tangent ogive (half-section, x = radius, y = height).
// A tangent ogive is a circular arc of radius phi: it is sampled at a
// constant angular step, which yields segments of equal length.
module ogiveProfile(L, R, segLen = ogiveSegLen) {
    phi  = (R*R + L*L) / (2*R);
    tMax = asin(L / phi);
    n    = max(8, ceil(phi * tMax * PI / 180 / segLen));
    polygon(concat([[0, 0]],
        [for (i = [0:n]) let(t = tMax * i / n)
            [max(0, (R - phi) + phi * cos(t)), phi * sin(t)]]));
}
