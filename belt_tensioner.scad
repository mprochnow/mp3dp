include <timing_belts.scad>
include <polyhole.scad>

distance_rod     = 60; // middle to middle
w_belt           = 10;

intersection() 
{
    difference() {    
        translate([0.5, 0, 7])
            cube([20, 12, 14], center=true);

        union() {
            translate([0, -2, 14.5])
            rotate([0, 90, 0])
            rotate([-90, 0, 0])
                belt_len(profile = tT2_5, belt_width = w_belt+1, len = 13);

            translate([0.4+0.1, -(w_belt+1)/2-2, 1.5])
                cube([0.3, w_belt+1, 13.]);
            
            *translate([0.2, -( w_belt + 1)/2, -13.25])
                cube([0.4, w_belt + 1, 13.52]);
    }

    translate([5, 0, 12])
        polyhole(25, 3.3);

    translate([-5, 0, 12])
        polyhole(25, 3.3);

    translate([7.3, 0, 13])
        cube([10, 5.4, 20], center=true);

    translate([-7.3, 0, 13])
        cube([10, 5.4, 20], center=true);
}

rotate([0, 45, 0])
    cube([23, 13, 23], center=true);
}
