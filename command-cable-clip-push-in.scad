// Clip for a round cable which fits snugly inside (so that the clip does not need to be very springy).

include <lib-command.scad>

cable_diameter = 9.6;
hookness = cable_diameter * 0.2;

base_thickness = 2;

cable_center_z = base_thickness + cable_diameter / 2;

$fn = 60;
epsilon = 0.01;

main();

module main() {
    // Cable mock
    %translate([0, 0, cable_center_z])
    rotate([0, 90, 0])
    cylinder(d=cable_diameter, h=50, center=true);
    
    difference() {
        // Lower body section of clip
        hull_chain() {
            // Adhesive base plate
            linear_extrude(0.5)
            square([command_small_h, command_small_w], center=true);
 
            // Middle section
            translate([0, 0, cable_center_z])
            mirror([0, 0, 1])
            linear_extrude(0.5)
            square([command_small_h - 10, cable_diameter + 0.4 * 6], center=true);

            // Top section
            // TODO: kludgy, should be using sections of a cylinder
            translate([0, 0, cable_center_z + hookness])
            mirror([0, 0, 1])
            linear_extrude(0.5)
            square([command_small_h - 20, cable_diameter + 0.4 * 6], center=true);
            
            //bevel_cube([command_small_h, command_small_w, cable_center_z], 0.5);
        }
        
        // Cable cutaway + entrance
        translate([0, 0, cable_center_z])
        union() {
            rotate([0, 90, 0]) cylinder(d=cable_diameter, h=50, center=true);

            translate([0, 0, cable_diameter * 0.5])
            rotate([0, 90, 0]) cylinder(d=cable_diameter, h=50, center=true);
        }
    }
}

// hull_chain() { a; b; c; } = union() {
//     hull() { a; b; }
//     hull() { b; c; }
// }
module hull_chain() {
    if ($children <= 1) {
        children();
    } else {
        for (i = [0:$children-2]) {
            hull() children([i, i+1]);
        }
    }
}
