/****************************************************************
* title: rocket nose cone - 2D cap for CNC cutting (optimized version)
* author: Boris du Reau
* version: 1.1
*
* 2D part (DXF/SVG export). The small holes no longer use
* $fn=200 but holeFn; the outline keeps couplerResolution.
*
* The part is wrapped in couplerCap2D() so that it can be reused by
* the exploded assembly file (via "use <...>").
*****************************************************************/

include <nosecone_tangent_main-100-365.scad>;

u_hole_diam = 4.5;
uspacer     = 30;    // center distance between the 2 U-bolt holes

/* Do not modify anything after that unless you know what you are doing*/

// 2D cap outline, centered on the origin
module couplerCap2D() {
    difference() {
        circle(d = couplerOutDiameter, $fn = couplerResolution);

        // 4 mounting holes
        screwPattern() circle(d = holeDiam, $fn = holeFn);

        // U-bolt holes
        for (s = [-1, 1]) translate([0, s * uspacer/2]) circle(d = u_hole_diam, $fn = holeFn);
    }
}

couplerCap2D();
