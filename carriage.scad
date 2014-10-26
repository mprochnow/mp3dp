include <m3.scad>

height           = 24;
d_bearing        = 15;
r_bearing        = d_bearing / 2;
t_wall           = 4;
distance_rod     = 60; // middle to middle
w_plate          = distance_rod - 2 * (r_bearing);
distance_magnets = 40;
d_magnet         = 15; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6; // height of magnet

q = 4 * 40; // quality for cylinders

module magnet_holder() {
    difference() {
        hull() {
            translate([0, -6.26, 1.74]) rotate([135, 0, 0]) translate([0, 0, 0])cylinder(h=h_magnet + t_wall, r=r_magnet + 2, center=true, $fn=q);
            translate([0, 0, 0]) cube([d_magnet + t_wall, 0.1, d_magnet + t_wall + t_wall + 1], center=true);
        }
         translate([0, -6.26, 1.74]) rotate([135, 0, 0]) translate([0, 0, t_wall / 2])cylinder(h=h_magnet + 1, r=r_magnet, center=true, $fn=q);
    }
};

module bearing_mount() {
    difference() {
        union() {
            difference() {
                translate([0, 0, 0])  cylinder(h=height, r=r_bearing + t_wall, center=true, $fn=q);
                translate([0, 0, -1]) cylinder(h=height + 3, center=true, r=r_bearing, $fn=q);
                rotate([0, 90, 0]) translate([0, (r_bearing + t_wall), 0]) cylinder(r=1.5, h=17, center=true, $fn=q);
                rotate([0, 90, 0]) translate([0, (r_bearing + t_wall), 0]) translate([0, 0, 8]) m3_nut();
            }
            rotate([0, 90, 0]) translate([0, (r_bearing + t_wall), 0]) difference() {
                cylinder(r=4, h=16, center=true, $fn=q);
                cylinder(r=1.5, h=17, center=true, $fn=q);
                translate([0, 0, 8]) m3_nut();
            }
        }
        translate([0, r_bearing, 0]) rotate([0, 0, 90]) cube([d_bearing + t_wall, 1.5, height + 2], center=true); 
    }
};

module plate() {
    translate([0, t_wall / 2, 0]) cube([distance_rod, t_wall, height], center=true);
}

module carriage() {
    union() {
        translate([-(distance_rod / 2), r_bearing + t_wall, 0]) bearing_mount();
        plate();
        translate([distance_rod / 2, r_bearing + t_wall, 0]) rotate([0, 180, 0]) bearing_mount();

        translate([-(distance_magnets / 2), 0, 0]) magnet_holder();
        translate([distance_magnets / 2, 0, 0]) magnet_holder();
    }
};

carriage();

