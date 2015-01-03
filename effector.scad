include <settings.scad>
include <polyhole.scad>

d_magnet         = 15 + 2 + play;       // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6 + 2;               // height of magnet
distance_magnets = 60;
a_magnet_mount   = -45;             // -90 <= a_magnet_mount <= 0

o_fan = 1; // vertical offset of fan
h_fan = 10;
w_fan = 30;
a_fan = -45;
fan_hole_offsets = [
    [ -12,  12, 0],
    [  12,  12, 0],
    [  12, -12, 0],
    [ -12, -12, 0]
];


module 30mm_fan() {
    difference() {
        cube([w_fan, w_fan, h_fan], center=true);
        
        for (a = fan_hole_offsets) {
            translate(a)
                cylinder(d=3.1, h=11, center=true, $fn=20);
        }
        
        cylinder(d=28, h=11, center=true, $fn=80);
    }
}

module hotend() {
    translate([0, 0, 2.375 + 2.25])
        cylinder(d=16, h=4.75, center=true, $fn=20);

        cylinder(d=11.92, h=4.5, center=true, $fn=20);
    
    translate([0, 0, -(2.225 + 2.25)])
        cylinder(d=16, h=4.45, center=true, $fn=20);
    
    translate([0, 0, -(10.5 + 4.45 + 2.25)])
        cylinder(d=9.75, h=21, center=true, $fn=20);
    
    translate([0, 0, -(0.875 + 21 + 4.45 + 2.25)])
        cylinder(d=6, h=1.75, center=true, $fn=20);

    translate([0, 3, -(5 + 1.75 + 21 + 4.45 + 2.25)])
        cube([15, 17, 10], center=true);
}

module magnet_holder_slice(part) {
    // tilted circle projects an ellipse
    a = r_magnet;                       // intersect point of ellipse with x-axis
    b = cos(a_magnet_mount) * r_magnet; // intersect point of ellipse with y-axis

    // polar angle of tangent
    phi = atan(pow(b, 2) / pow(a, 2) * tan(-60));
    
    // polar radius of tangent
    r = (a * b) / sqrt(pow(a, 2) * pow(sin(phi), 2) + pow(b, 2) * pow(cos(phi), 2));
    
    // coordinate of tangent, if tilt angle is 0
    x0 = cos(-60) * r_magnet;
    y0 = sin(-60) * r_magnet;

    // intersect point with y-axis, if tilt angle is 0
    n0 = y0 - tan(30) * x0;
 
    // equation of straight line: y = tan(30) * x + n0;    
    
    // use x-coordinate of tangent of ellipse for phi with
    // equation, subtract y-coordinate of tangent and
    // subtract the result from y0
    yn = y0 - ((tan(30) * cos(phi) * r + n0) - (sin(phi) * r));

    x = cos(30) * (tan(30) * (distance_magnets + r_magnet)) - x0;
    y = sin(30) * (tan(30) * (distance_magnets + r_magnet)) - yn;

    h = -sin(a_magnet_mount) * r_magnet;

    if (part == "magnet_holder") {
        translate([0, y, h])
        rotate([a_magnet_mount, 0, 0])
        translate([0, 0, h_magnet/2])
            cube([2 * (x + r_magnet), d_magnet, h_magnet] , center=true);
    }

    if (part == "magnet_cutout") {
        translate([x, y - sin(a_magnet_mount), h + cos(a_magnet_mount)])
        rotate([a_magnet_mount, 0, 0])
            cylinder(r=r_magnet - 1, h=h_magnet + 1, $fn=40);

        translate([-x, y - sin(a_magnet_mount), h + cos(a_magnet_mount)])
        rotate([a_magnet_mount, 0, 0])
            cylinder(r=r_magnet - 1, h=h_magnet + 1, $fn=40);
    }
    
    w_fan_holder =   y
                   + cos(a_magnet_mount) * r_magnet
                   - sin(a_magnet_mount) * h_magnet;

    h_fan_holder = 4.45 + 21;
    
    h_fan_cutout = cos(a_fan) * w_fan - sin(a_fan)*h_fan;
    
    if (part == "fan_cutout") {
        translate([-(w_fan + 0.5)/2, 0, o_fan])
            cube([w_fan + 0.5, 100, h_fan_cutout]);
    }
    
    if (part == "fan_holder_walls") {
        difference() {
            translate([0, w_fan_holder/2, h_fan_holder/2])
                cube([distance_rods - d_magnet, w_fan_holder, h_fan_holder], center=true);
        
            translate([0, w_fan_holder, cos(a_magnet_mount) * h_magnet])
            rotate([a_fan, 0, 0])
            translate([0, 0, h_fan_holder/2])
                cube([distance_rods - d_magnet + 1, 3*w_fan_holder, h_fan_holder], center=true);
        
            translate([0, w_fan_holder + sin(a_magnet_mount) * h_magnet, 0])
            rotate([(90 + a_magnet_mount), 0, 0])
            translate([0, 0, -h_fan_holder/2])
                cube([distance_rods - d_magnet + 1, 3*w_fan_holder, h_fan_holder], center=true);
        }
    }

    if (part == "fan_mount") {
        translate([0, w_fan_holder + sin(a_magnet_mount) * h_magnet, 0])
        rotate([-45, 0, 0])
        translate([0, -w_fan/2, -o_fan])
        difference() {
            union() {
                for (x = [(w_fan + 0.5)/2 -3, -((w_fan + 0.5)/2 - 3)]) {
                    translate([x, 0, 0])
                        cube([6, 29, 5], center=true);
                }
            }
            
            for (a = fan_hole_offsets) {
                translate(a)
                    cylinder(d=2.5, h=6, center=true, $fn=20);
            }
        }
    }
    
    if (part == "hotend_mount") {
        translate([0, 0, 21 + 4.45 + 2.25])
        union() {
            difference() {
                rotate([0, 0, 30])
                    cylinder(r=24.6, h=4.45, center=true, $fn=3);
                
                    cylinder(d=11.92, h=4.5+1, center=true, $fn=20);

                translate([0, -15, 0])
                    cube([distance_rods - d_magnet + 1, 30, 4.45 + 1], center=true);
            }
            
            translate([0, 1 + cos(60)*24.6, 0])
                cube([distance_rods - d_magnet, 2, 4.45], center=true);
        }
    }
    
    if (part == "hotend_holder") {
        translate([0, 0, 21 + 4.45+4.5])
        union() {
            difference() {
                rotate([0, 0, 30])
                    cylinder(r=24.6, h=4.75, $fn=3);

                    cylinder(d=16 + 2*play, h=10, center=true, $fn=20);
                
                for (a = [60, 180, 300])
                {
                    rotate([0, 0, a])
                    translate([0, 24.6 - 10.5, 0])
                        polyhole(20, 3.3);
                }
            }
            
            translate([0, 0, 4.75])
            difference() {
                    cylinder(d1=20, d2=8, h=4, $fn=30);
                
                translate([0, 0, 1])
                    polyhole(4, 2.5, center=false);
            }
            
            difference() {
                    cylinder(d=8, h=4.75, $fn=20);
    
                translate([0, 0, -1])
                    cylinder(d=7.5, h=5, $fn=20);
            }
        }
    }
}

magnet_holder_slice("hotend_holder");

*union() {
    difference() {
        union() {
            hull() {
                for (z = [0, 120, 240]) {
                    rotate([0, 0, z])
                        magnet_holder_slice("magnet_holder");
                }
            }
            
            for (z = [0, 120, 240]) {
                rotate([0, 0, z])
                    magnet_holder_slice("fan_holder_walls");
            }
        }
        
        for (z = [0, 120, 240]) {
            rotate([0, 0, z])
            union() {
                magnet_holder_slice("magnet_cutout");
                magnet_holder_slice("fan_cutout");
                
                if (z == 240) {
                    translate([0, 8.7, -2])
                        magnet_holder_slice("fan_cutout");
                }
            }
        }
        
        translate([0, 0, -1])
        rotate([0, 0, 30])
            cylinder(r=17.6, h=40, $fn=3);
    }
    
    difference() {
        union() {
            for (z = [0, 120, 240]) {
                rotate([0, 0, z])
                    magnet_holder_slice("hotend_mount");
            
                if (z != 240) {
                    rotate([0, 0, z])
                        magnet_holder_slice("fan_mount");
                }
            }
        }
        rotate([0, 0, 240])
        translate([0, 25, 21 + 4.45 + 2.25])            
            cube([11.92, 50, 4.5+1], center=true);
        
        translate([0, 0, -5])
            cube([100, 100, 10], center=true);
    }
}

*translate([0, 0, (21 + 4.45 + 2.25)])
rotate([0, 0, 240])
    hotend();

*translate([0, 36.992-w_fan/2, o_fan + cos(a_fan)*w_fan/2])
rotate([-45, 0, 0])
translate([0, 0, h_fan/2])
    30mm_fan();

