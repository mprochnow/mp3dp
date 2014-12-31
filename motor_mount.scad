include <settings.scad>
include <m3.scad>
include <polyhole.scad>


module nema17_mount() {
    // dimensions
    width = 42.3;
    height = 5;
    hole_offsets = [
        [-15.5, -15.5, 1.5],
        [-15.5,  15.5, 1.5],
        [ 15.5, -15.5, 1.5],
        [ 15.5,  15.5, 1.5]
    ];

    difference() {
        // base plate
        translate([0, 0, height / 2])
            cube([width, width + 5, height], center = true);
        
        // center hole
        translate([0, 0, -0.5]    )
            cylinder(r = 11.25 + 0.1, h = height + 1, $fn = 32);

        // mounting holes
        for (a = hole_offsets) {
            translate(a) {
                polyhole(height * 4, 3.3);
                polyhole(height + 1, 5.7, center=false);
            }
        }
    }
}

module rod_mount() {
    width = 42.3;
    offset_rods =   2 + 0.5
                  + 7
                  + 9 / 2;
    height = offset_rods;

    difference() {
        union() {
            translate([width/2 + 8.85, 0, height / 2])
                cube([2 * 8.85, width + 5, height], center=true);
            
            translate([width/2 + 8.85, 0, height + 0.7])
            rotate([0, 22, 0])
            rotate([90, 0, 0])        
                cylinder(r=9.55, h=width + 5, center=true, $fn=8);
            
            for (y = [width/4, -width/4]) {

                translate([distance_rods/2, y, 20.5])                
                rotate([22, 0, 0])
                rotate([0, 90, 0])        
                    cylinder(r=5.5, h=2*8.85, center=true, $fn=8);
            }
        
            translate([width/2, 0, 5])
            rotate([0, 45, 0])
                cube([3.5, width + 5, 3.5], center=true);
        }
        
        translate([distance_rods/2, 0, offset_rods])
        rotate([90, 0, 0])
            cylinder(r=d_rod/2, h=42.3 + 5 + 1, center=true, $fn=40);

        for (y = [width/4, -width/4]) {
            translate([distance_rods/2, y, 20.5])
            rotate([0, 270, 0])
            union() {
                polyhole(17, 3.3);

                translate([0, 0, 8])
                rotate([0, 0, 30])
                    m3_nut(width=5.8);

                translate([0, 0, -8])       
                    polyhole(3, 5.7);  
            }
        }
        
        translate([distance_rods/2, 0, height/2 + offset_rods])
            cube([2.5, width + 5 + 1, height], center=true);
        
        translate([distance_rods/2 + 8.8, 0, 0])
        rotate([0, 45, 0])
            cube([12, width + 5 + 1, 12], center=true);
    
    }
}

union() {
        nema17_mount();
        
        rod_mount();

    mirror([1, 0, 0])
        rod_mount();
}
