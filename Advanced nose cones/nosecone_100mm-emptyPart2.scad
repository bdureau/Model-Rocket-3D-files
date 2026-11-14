/****************************************************************
* title: rocket nose cone bottom (coupler) - optimized version
* author: Boris du Reau
* version: 1.1
*
* Optimization: the body is a solid of revolution. It is built
* in 2D (rectangle - bores - quarter circle instead of the
* $fn=200 half-sphere) and then revolved in a single rotate_extrude.
* Only the 4 holes and the 4 nut pockets remain as 3D CSG.
*
* The part is wrapped in couplerPart() so that it can be reused by
* the exploded assembly file (via "use <...>").
*****************************************************************/

include <nosecone_tangent_main-100-365.scad>;

/* Do not modify anything after that unless you know what you are doing*/

rOut   = couplerOutDiameter/2;
rIn    = rOut - couplerThickness;
rBore  = (noiseBase/2) - 10.5;
zIn1   = pistonCapHeight;                                   // bottom of the cavity
hIn    = couplerHeight - 4*pistonCapHeight - 8;             // height of the cavity
zDome  = couplerHeight - couplerOutDiameter/2.75;           // center of the dome

// 2D half-section of the coupler
module couplerProfile() {
    difference() {
        square([rOut, couplerHeight]);
        // central through bore
        translate([0, -eps]) square([rBore, couplerHeight + 2*eps]);
        // cylindrical cavity
        translate([0, zIn1]) square([rIn, hIn]);
        // dome (upper half of the sphere) = quarter disc in 2D
        translate([0, zDome]) intersection() {
            circle(r = rIn, $fn = couplerResolution);
            square([rIn, rIn]);
        }
    }
}

// Complete coupler, bottom at Z = 0, top at Z = couplerHeight
module couplerPart() {
    difference() {
        rotate_extrude($fn = couplerResolution) couplerProfile();

        screwPattern() {
            // through screw hole
            translate([0, 0, -eps])
                cylinder(h = couplerHeight + 2*eps, d = holeDiam, $fn = holeFn);
            // nut pocket
            translate([0, 0, couplerHeight - 5]) cube([6.5, 6.5, 3], center = true);
        }
    }
}

couplerPart();
