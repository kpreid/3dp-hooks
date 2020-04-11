include <lib-command.scad>

head_diameter = 5.8;
head_thickness = 2;
shank_diameter = 3;
shank_length = 4;
flat_thickness = 2;

overhang_slope = 0.7;

$fn = 60;
epsilon = 0.01;

main();

module main() {
    translate([-command_small_w /* not a typo */ / 2, -command_small_w / 2, 0])
    bevel_cube([command_small_h, command_small_w, flat_thickness], 0.5);

    cylinder(d=shank_diameter, h=flat_thickness + shank_length + head_thickness);
    
    translate([0, 0, flat_thickness + shank_length])
    hull() {
        cylinder(d=shank_diameter, h=epsilon);

        translate([0, 0, (head_diameter - shank_diameter) * overhang_slope / 2])
        cylinder(d=head_diameter, h=head_thickness);
    }
}

module bevel_cube(dims, edge) {
    inset = dims.z;
    
    hull() {
        cube([dims.x, dims.y, edge]);
        
        translate([inset, inset, dims.z - edge])
        cube([dims.x - inset * 2, dims.y - inset * 2, edge]);
    }
}