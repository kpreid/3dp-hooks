// A cup which, if printed in flexible filament, contains a magnet removably, and has holes through which bendable wire can be passed to make a custom magnet hook.

// Fit parameters
magnet_diameter = 18 * 1.015;  // Enlarged to allow for part shrinkage
magnet_thickness = 3;
wire_hole_diameter = 2.1;

// Independent parameters
bottom_plate_thickness = 0.6;  // three 0.2 mm layers
top_taper_thickness = 0.4;
magnet_to_wire_gap = 1;
top_ring_thickness = 1;
side_wall_width = 2;
epsilon = 0.01;

top_elements_thickness = magnet_to_wire_gap + wire_hole_diameter + top_ring_thickness;


difference() {
    main();
    //cube([100, 100, 100]);
}


module main() {
    difference() {
        $fn = 120;
        slope_unit = top_taper_thickness;
        narrowed_diameter = magnet_diameter - slope_unit * 2;

        // Outer body
        translate([0, 0, -bottom_plate_thickness])
        cylinder(
            d=magnet_diameter + side_wall_width * 2,
            h=bottom_plate_thickness + magnet_thickness + top_elements_thickness);
        
        // Opening for magnet, narrow diameter forming the retaining ring.
        cylinder(d=narrowed_diameter, h=magnet_thickness + top_elements_thickness + epsilon);

        // Recess for magnet, bottom part of ring.
        hull() {
            cylinder(d=magnet_diameter, h=magnet_thickness);
            cylinder(d=narrowed_diameter, h=magnet_thickness + slope_unit);
        }
        
        // Opening for magnet to enter through, bottom part of ring
        hull() {
            translate([0, 0, magnet_thickness + slope_unit * 2])
            cylinder(d=magnet_diameter, h=top_elements_thickness);
            translate([0, 0, magnet_thickness + slope_unit])
            cylinder(d=narrowed_diameter, h=top_elements_thickness);
        }
        
        // Wire holes
        for (i = [0:90:359])
        rotate([0, 0, i])
        mirrored([1, 0, 0])
        translate([wire_hole_diameter / 2 + 1, 0, magnet_thickness + magnet_to_wire_gap + wire_hole_diameter / 2])
        rotate([90, 0, 0])
        cylinder(d=wire_hole_diameter, h=magnet_diameter, $fn=30);
    }
}

module mirrored(axis) {
    children();
    mirror(axis) children();
}