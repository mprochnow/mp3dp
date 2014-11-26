include <timing_belts.scad>
include <m3.scad>

tolerance        = 0.3;

h_bearing        = 24;
d_bearing        = 15 + tolerance;
r_bearing        = d_bearing / 2;
t_wall           = 4;
t_plate          = 6;
distance_rod     = 60; // middle to middle
w_plate          = distance_rod - 2 * (r_bearing);
distance_magnets = 40;
d_magnet         = 15 + tolerance; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6; // h_bearing of magnet
w_belt           = 7;
h_belt_mount     = h_bearing / 2;

q = 2 * 40; // quality for cylinders

module bearing_mount() {
    difference() {
        union() {
            difference() {
                union() {
                    rotate([0, 0, 22.5])
                        cylinder(r=r_bearing + t_wall + 0.92, h=h_bearing, center=true, $fn=8);

                    hull() {
                        translate([0, -4.7, 0])
                            cube([d_magnet + 2.6, 1, h_bearing], center=true);
                        
                        translate([0, -15, 3.22]) 
                        rotate([135, 0, 0])
                        rotate([0, 0, 22.5])
                            cylinder(h=h_magnet + 1, r=r_magnet + 2, center=true, $fn=8);
                    }

                    translate([distance_rod/4, -(t_plate/2 + w_belt/2 + 2.12), 0])
                        cube([distance_rod/2, t_plate, h_bearing], center=true);

                    translate([-6.83 , -(t_plate/2 + w_belt/2 + 2.12), -1.5])
                        cube([4.2, t_plate, h_bearing - 3], center=true);

                    translate([r_bearing + t_wall, -6, 0])
                    rotate([0, 0, 45])
                        cube([5, 5, h_bearing], center=true);
                }
                
                cylinder(r=r_bearing, h=h_bearing + 1, center=true, $fn=q);
            }

            translate([0,0.9,0])
            difference() {            
                intersection() {
                    translate([0, 13, 0])
                        cube([12, 9, h_bearing], center=true);

                    scale([1.0, 1.0, 1.5])
                    rotate([45, 0, 0])
                        cube([12, h_bearing*1.16, h_bearing*1.16], center=true);
                }
                
                translate([0, 13.5, 0])
                rotate([90, 0, 90])
                union() {
                    cylinder(r=1.5, h=17, center=true, $fn=q);

                    translate([0, 0, 6])
                    rotate([0, 0, 30])
                        m3_nut();

                    translate([0, 0, -6])       
                        cylinder(r=2.7, h=3, center=true, $fn=q);
                }
            }
        }
        
        translate([0, -15, 3.22])
        rotate([135, 0, 0])
        translate([0, 0, 1])
            cylinder(h=h_magnet + 1, r=r_magnet, center=true, $fn=q);

        translate([0, 10, 0])            
            cube([2.5, 20, h_bearing + 1], center=true);
    }
};

module belt_mount() {
    difference() {
        cube([13, w_belt, h_belt_mount], center=true);

        translate([0, 0.5, 10.2])
        rotate([0, 90, 0])
        rotate([-90, 0, 0])
	        scale(1.02) belt_len(profile = tT2_5, belt_width = w_belt+1, len = h_belt_mount * 2);
    
        translate([0.8, 0, 0])
            cube([1, w_belt + 1, h_belt_mount + 1], center=true);
    }
}

module carriage() {
    union() {
        translate([-(distance_rod / 2), 0, 0])
            bearing_mount();
        
        translate([(distance_rod / 2), 0, 0])
        mirror([1, 0, 0])
            bearing_mount();

        // belt mount
        difference() {    
            translate([(distance_rod - d_bearing) / 4 - 1.5, -2, h_bearing/4 - 1])
                cube([(distance_rod - d_bearing) / 2 + 3, w_belt + 2, h_bearing/2 + 2], center=true);
        
            translate([6.5, 0, h_bearing/2 + 0.5])
            rotate([0, 90, 0])
            rotate([-90, 0, 0])
	            scale(1.02) belt_len(profile = tT2_5, belt_width = w_belt+1, len = h_bearing / 2 + 1);
        
            translate([7.3, 0, h_bearing/4])
                cube([1, w_belt + 1, h_bearing/2 + 1.52], center=true);
        }
       
        // belt tensioner
        difference() {
            translate([(distance_rod - d_bearing) / 4 - 1.5, -0.43, -(h_bearing/4) - 1])
                cube([(distance_rod - d_bearing) / 2 + 3, w_belt + 3.5, h_bearing/2 - 2], center=true);
        
            translate([12, 0, -5])
            rotate([0, 0, 30])
                m3_nut(width=5.8, thickness=8);

            translate([12, 2, -5])
                cube([5.8, 6, 8], center=true);    

            translate([12, 0, -10])
                cylinder(r=1.65, h=10, center=true, $fn=q);

            translate([2, 0, -5])
            rotate([0, 0, 30])
                m3_nut(width=5.8, thickness=8);

            translate([2, 2, -5])
                cube([5.8, 6, 8], center=true);    

            translate([2, 0, -10])
                cylinder(r=1.65, h=10, center=true, $fn=q);
        }
        
        translate([-(23-12), -(7.1/2 + 8 / 2 + 1 + 5 + 2.5), 0])
        difference() {
            union() {
                translate([0, 5, 0])
                    cube([9.24, 10, h_bearing], center=true);

                rotate([0, 0, 22.5])
                    cylinder(r=5, h=h_bearing, center=true, $fn=8);
            }
                cylinder(r=2.5/2, h=h_bearing+1, center=true, $fn=q);
        }
    }
};

//bearing_mount();
carriage();

