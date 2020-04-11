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
outer_bevel = 0.4;
epsilon = 0.01;

top_elements_thickness = magnet_to_wire_gap + wire_hole_diameter + top_ring_thickness;
body_height = bottom_plate_thickness + magnet_thickness + top_elements_thickness;


difference() {
    main();
    //cube([100, 100, 100]);
}


module main() {
    difference() {
        $fn = 180;
        slope_unit = top_taper_thickness;
        narrowed_diameter = magnet_diameter - slope_unit * 2;

        // Outer body, with bevel
        translate([0, 0, -bottom_plate_thickness])
        beveled_cylinder(
            d=magnet_diameter + side_wall_width * 2,
            h=body_height,
            bevel=outer_bevel,
            bevel_top=true);
        
        // Opening for magnet, narrow diameter forming the retaining ring.
        cylinder(d=narrowed_diameter, h=magnet_thickness + top_elements_thickness + epsilon);

        // Recess for magnet, bottom part of ring.
        beveled_cylinder(d=magnet_diameter, h=magnet_thickness + slope_unit, bevel=slope_unit, bevel_top=true);
        
        // Opening for magnet to enter through, top part of ring
        translate([0, 0, magnet_thickness + slope_unit])
        beveled_cylinder(d=magnet_diameter, h=top_elements_thickness, bevel=slope_unit, bevel_bottom=true);
        
        // Bevel of very top of whole
        translate([0, 0, -bottom_plate_thickness + body_height - outer_bevel])
        beveled_cylinder(
            d=magnet_diameter + outer_bevel * 2,
            h=outer_bevel * 2,
            bevel=outer_bevel,
            bevel_bottom=true);
        
        // Wire holes
        for (i = [0:90:359])
        rotate([0, 0, i])
        mirrored([1, 0, 0])
        translate([wire_hole_diameter / 2 + 1, 0, magnet_thickness + magnet_to_wire_gap + wire_hole_diameter / 2])
        rotate([90, 0, 0])
        cylinder(d=wire_hole_diameter, h=magnet_diameter, $fn=30);
    }
}

module beveled_cylinder(d, h, bevel, bevel_top=false, bevel_bottom=false) {
    hull() {
        translate([0, 0, bevel_bottom ? bevel : 0])
        cylinder(d=d, h=h - (bevel_top ? bevel : 0) + (bevel_bottom ? bevel : 0));
        cylinder(d=d - bevel * 2, h=h);
    }
}

module mirrored(axis) {
    children();
    mirror(axis) children();
}