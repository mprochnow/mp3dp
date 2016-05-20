include <timing_belts.scad>
include <polyhole.scad>

distance_rod     = 60; // middle to middle
w_belt           = 10;

difference() {    
    translate([0, 0, 7])
        cube([20, 12, 14], center=true);

    translate([0, -2, 14.5])
    rotate([0, 90, 0])
    rotate([-90, 0, 0])
        belt_len(profile = tT2_5, belt_width = w_belt+1, len = 13);

    translate([0.4+0.1, -(w_belt+1)/2-2, 1.5])
        cube([0.3, w_belt+1, 13.]);

    for (m=[0, 1]) {
        mirror([m, 0, 0]) {
            translate([5, 0, 12])
                polyhole(25, 3.6);

            translate([2, -3, 3])
                cube([10, 6, 20]);

            translate([2, -6.05, 14])
            rotate([0, atan((14-3)/(10-1.5)), 0])
                cube([20, 12.1, 10]);
        }
    }
}
