/****************************************************************
* title: rocket nose cone - tangent ogive (optimized version)
* author: Boris du Reau
*
* Optimization: the whole shell (hollow ogive + bottom flange) is
* built in 2D and then revolved in ONE single rotate_extrude.
* No more 3D difference between two ogives: only the 4 screw holes and
* the 4 nut pockets remain as 3D CSG.
*
* The part is wrapped in noseConePart() so that it can be reused by
* the exploded assembly file (via "use <...>").
*****************************************************************/

include <nosecone_tangent_main-100-365.scad>;

// 2D half-section of the complete part
module noseProfile() {
    union() {
        // shell: outer ogive - inner ogive (shifted by -1 in Z)
        difference() {
            ogiveProfile(ogiveLenght, baseDiam/2);
            translate([0, -1])
                ogiveProfile(ogiveLenght - 2*thickness, baseDiam/2 - thickness);
        }
        // bottom flange (truncated cone with a central opening)
        polygon([[baseDiam/2 - 10.5, 0],
                 [baseDiam/2,        0],
                 [baseDiam/2 - thickness, nosebottom],
                 [baseDiam/2 - 10.5, nosebottom]]);
    }
}

// Complete nose cone, base at Z = 0, tip at Z = ogiveLenght
module noseConePart() {
    difference() {
        rotate_extrude($fn = ogiveFn) noseProfile();

        screwPattern() {
            // screw hole
            translate([0, 0, -eps])
                cylinder(h = nosebottom + 2*eps, d = holeDiam, $fn = holeFn);
            // nut pocket
            translate([0, 0, 4]) cube([6.5, 6.5, 3], center = true);
        }
    }
}

noseConePart();
