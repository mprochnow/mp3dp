include <settings.scad>
include <m3.scad>

h_idler = 20;
q = 2 * 40;
t_wall = 8;
w_pulley = 7.1;
d_pulley = 12; // outer most diameter of pulley
w_bearing = 5;

offset_bearing = (w_pulley-w_bearing) / 2;

module mount() {
    difference() {
        union() {
            translate([0, d_rod/2 + 0.39 , 0])
            rotate([0, 0, 22.5])
                cylinder(d=d_rod+t_wall+1.1, h=h_idler, center=true, $fn=8);

            translate([0, (d_rod+t_wall)/2 - 10.9, 0])
                cube([t_wall + d_rod, 21, h_idler], center=true);

            translate([distance_rods/4, w_pulley/2 + t_wall / 2 + 1, -(h_idler/2) + 5/2])        
                cube([distance_rods/2, t_wall, 5], center=true);

            translate([distance_rods/4, w_pulley/2 + 1 + t_wall / 2, 5/2])        
                cube([distance_rods/2, t_wall, 15], center=true);
        }
    
        cylinder(r=d_rod/2, h=h_idler + 1, center=true, $fn=q);

        translate([0, -10, 0])            
            cube([2.5, 20, h_idler + 1], center=true);
    
        translate([0, -8, 0])
        rotate([90, 0, 90])
        union() {
            cylinder(d=3.3, h=17, center=true, $fn=q);

            translate([0, 0, 8])
            rotate([0, 0, 30])
                m3_nut(5.7);

            translate([0, 0, -8])       
                cylinder(d=5.5, h=3, center=true, $fn=q);
        }
    
    }
}

union() {
    difference() {
        union() {
            translate([-(distance_rods/2), 0, 0])
                mount();
            
            translate([distance_rods/2, 0, 0])
            mirror([1, 0, 0])
                mount();
            
            translate([-2.5, 0, 2.5]) 
            difference() {
                union() {
                    translate([0, w_pulley/2 + t_wall / 2 - offset_bearing/2, 0])
                    rotate([90, 0, 0])            
                        cylinder(r=7/2, h=t_wall+offset_bearing, center=true, $fn=q);
                    
                    translate([0, w_pulley/2 + t_wall + 1, -(h_idler/4 - 5.2)])
                    rotate([90, 0, 0])
                    rotate([0, 0, 22.5])
                        cylinder(d=12, 10, center=true, $fn=8);  
                    
                    translate([0, w_pulley/2 + t_wall + 1, -(h_idler/4)])
                        cube([11.1, 10, h_idler/2 + 5], center=true);
                }
            }
        }

        translate([-23, 9.5, 10.1])
        rotate([90, 0, 180])
        union() {
            translate([-5, -7, 0])
                cylinder(r=2.3/2, h=5, $fn=q);
            
            translate([5, -7, 0])
                cylinder(r=2.3/2, h=5, $fn=q);

            translate([-(14.5/2), -9.1, -(3.5/2)])
                cube([14.5, 9.1, 3.5]);
    }


    translate([-2.5, 0, 2.5])
    rotate([90, 0, 0])
        cylinder(d=3.3, h = 60, center=true, $fn=q);
    }
}

