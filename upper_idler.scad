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
            translate([0, d_rod/2 + 0.87 , 0])
            rotate([0, 0, 22.5])
                cylinder(r=(d_rod+t_wall)/2, h=h_idler, center=true, $fn=8);

            translate([0, (d_rod+t_wall)/2 - 10.5, 0])
                cube([t_wall + d_rod - 1.24, 21, h_idler], center=true);

            translate([distance_rods/4, w_pulley/2 + t_wall / 2 + 1, -(h_idler/2) + 5/2])        
                cube([distance_rods/2, t_wall, 5], center=true);

            translate([distance_rods/4, w_pulley/2 + t_wall / 2 - 1, 5/2])        
                cube([distance_rods/2, t_wall - 4, 15], center=true);

            translate([distance_rods/2, w_pulley/2 + t_wall / 2 - offset_bearing/2, 0])
            rotate([90, 0, 0])            
                cylinder(r=7/2, h=t_wall+offset_bearing, center=true, $fn=q);
            
            translate([distance_rods/2, w_pulley/2 + t_wall + 1, -(h_idler/4 - 5)])
            rotate([90, 0, 0])
            rotate([0, 0, 22.5])
                cylinder(r=12/2, 10, center=true, $fn=8);  
            
            translate([distance_rods/2, w_pulley/2 + t_wall + 1, -(h_idler/4)])
                cube([11.1, 10, h_idler/2], center=true);
        }
    
            cylinder(r=d_rod/2, h=h_idler + 1, center=true, $fn=q);

        translate([0, -10, 0])            
            cube([2.5, 20, h_idler + 1], center=true);
    
        translate([0, -8, 0])
        rotate([90, 0, 90])
        union() {
            cylinder(r=3.3/2, h=17, center=true, $fn=q);

            translate([0, 0, 8])
            rotate([0, 0, 30])
                m3_nut();

            translate([0, 0, -8])       
                cylinder(r=2.7, h=3, center=true, $fn=q);
        }
    
        translate([distance_rods/2, 0, 0])
        rotate([90, 0, 0])
            cylinder(r=4.3/2, h = 60, center=true, $fn=q);
    }
}

difference() {
    union() {
        translate([-(distance_rods/2), 0, 0])
            mount();
        
        translate([distance_rods/2, 0, 0])
        mirror([1, 0, 0])
            mount();
        
        translate([-(distance_rods/2), 6.55, -10])
            cube([16, 6, 20]);
            
        translate([-(distance_rods/2 - 15.9) , 4.55, -10])
        rotate([0, 0, 45])
            cube([5.7, 5.6, 20]);
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
}

