/****************************************************************
* title: rocket nose cone 100 mm / 365 mm - exploded assembly view
* author: Boris du Reau
*
* Stacks the 3 parts along the Z axis, from bottom to top:
*   Part 3 - CNC cap (2D outline extruded to bouchonHeight)
*   Part 2 - coupler (slides into the body tube)
*   Part 1 - tangent ogive nose cone
*
* explode = 0 -> parts in contact (assembled)
* explode = 1 -> parts separated by explodeGap
* Set animate = true and use View > Animate to watch the parts
* come together (driven by $t).
*
* This file is for visualization only (F5 preview recommended):
* print / cut each part from its own file.
*****************************************************************/

include <nosecone_tangent_main-100-365.scad>;
use <nosecone_tangent100mm_365mmPart1.scad>;   // noseConePart()
use <nosecone_100mm-emptyPart2.scad>;          // couplerPart()
use <nosecone_100mm-emptyPart3-withU-CNC.scad>; // couplerCap2D()

/* ---------- view settings ---------- */
explode      = 1;      // 0 = assembled, 1 = fully exploded
explodeGap   = 60;     // gap between two consecutive parts when exploded (mm)
animate      = false;  // true = explode factor driven by $t
showCutaway  = false;  // true = remove a 90° quadrant to see the inside
showScrewAxes = true;  // thin rods showing the 4 screw axes

/* ---------- colors ---------- */
noseColor    = "OrangeRed";
couplerColor = "SteelBlue";
capColor     = "BurlyWood";   // e.g. plywood
axisColor    = [0.2, 0.2, 0.2, 0.6];

/* Do not modify anything after that unless you know what you are doing*/

k   = animate ? 1 - $t : explode;
gap = k * explodeGap;

// Z position of the bottom face of each part (coupler top = Z 0)
zCap     = -couplerHeight - bouchonHeight - 2*gap;
zCoupler = -couplerHeight - gap;
zNose    = 0;

// Optional 90° cutaway (removes the +X / +Y quadrant)
module cutaway() {
    if (showCutaway)
        difference() {
            children();
            translate([0, 0, zCap - 1])
                cube([baseDiam, baseDiam, ogiveLenght - zCap + 2]);
        }
    else
        children();
}

cutaway() {
    // Part 1 - nose cone
    color(noseColor)
        translate([0, 0, zNose]) noseConePart();

    // Part 2 - coupler
    color(couplerColor)
        translate([0, 0, zCoupler]) couplerPart();

    // Part 3 - CNC cap
    color(capColor)
        translate([0, 0, zCap])
            linear_extrude(height = bouchonHeight) couplerCap2D();
}

// Screw axes, from below the cap to the top of the nose flange
if (showScrewAxes && k > 0)
    color(axisColor)
        screwPattern()
            translate([0, 0, zCap - 10])
                cylinder(h = nosebottom - zCap + 20, d = 1, $fn = 8);
