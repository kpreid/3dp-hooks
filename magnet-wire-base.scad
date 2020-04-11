// A cup which, if printed in flexible filament, contains a magnet removably, and has holes through which bendable wire can be passed to make a custom magnet hook.

// Fit parameters
magnet_diameter = 18 * 1.015;  // Enlarged to allow for part shrinkage
magnet_thickness = 3;
wire_diameter = 2.05;

// Independent parameters
bottom_plate_thickness = 0.6;  // three 0.2 mm layers
top_rim_thickness = 0.6;
side_wall_width = 2;
epsilon = 0.01;


main();


module main() {
    difference() {
        $fn = 120;
        
        // Outer body
        translate([0, 0, -bottom_plate_thickness])
        cylinder(
            d=magnet_diameter + side_wall_width * 2,
            h=bottom_plate_thickness + magnet_thickness + top_rim_thickness);
        
        // Recess for magnet
        slope_delta = top_rim_thickness + epsilon;
        hull() {
            cylinder(d=magnet_diameter, h=magnet_thickness);
            cylinder(d=magnet_diameter - slope_delta * 2, h=magnet_thickness + slope_delta);
        }
        // cut off slope halfway
        cylinder(d=magnet_diameter - slope_delta, h=magnet_thickness + slope_delta);
    }
}