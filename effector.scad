include <settings.scad>
include <polyhole.scad>

d_magnet         = 15 + play;       // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6;               // height of magnet
distance_magnets = 60;
a_magnet_mount   = -45;             // -90 <= a_magnet_mount <= 0

o_fan = 0; // vertical offset of fan
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
    translate([0, 0, h_fan/2])
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

module magnet_holder_slice() {
    // tilted circle projects an ellipse
    a = r_magnet; // intersect point of ellipse with x-axis
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
 
    /////////////////////////////////////////////////////////////////////////
    // equation of straight line: y = tan(30) * x + n0;    
    /////////////////////////////////////////////////////////////////////////
    
    // use x-coordinate of tangent of ellipse for phi with
    // equation, subtract y-coordinate of tangent and
    // subtract the result from y0
    yn = y0 - ((tan(30) * cos(phi) * r + n0) - (sin(phi) * r));

    x = cos(30) * (tan(30) * (distance_magnets + r_magnet)) - x0;
    y = sin(30) * (tan(30) * (distance_magnets + r_magnet)) - yn;

    h = -sin(a_magnet_mount) * r_magnet;

    translate([0, y, h])
    rotate([a_magnet_mount, 0, 0])
    union() {
        translate([x, 0, 0])
            cylinder(r=r_magnet, h=h_magnet, $fn=40);
    }
}

ww = cos(a_fan)*w_fan + 2;

union() {
    difference() {
        union() {
            rotate([0, 0, 30])
                cylinder(r=w_fan/2/sin(60), h=cos(a_fan)*w_fan, $fn=3);

            for (a = [0, 120, 240]) {
                rotate([0, 0, a])
                difference() {
                    translate([0, ww/2 + (sqrt(3)/2*w_fan)/3, cos(a_fan)*w_fan/2])
                        cube([w_fan, ww, cos(a_fan)*w_fan], center=true);
                
                    translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
                    rotate([-45, 0, 0])
                    translate([0, -w_fan/2, h_fan])
                        cube([w_fan + 1, w_fan + 1, h_fan*2], center=true);

                }
            }
        }
        
        for (a = [0, 120, 240]) {
            rotate([0, 0, a])
            translate([0, ww/2 + (sqrt(3)/2*w_fan)/3 + 2, (cos(a_fan)*w_fan)/2])
                cube([w_fan-2, 30, cos(a_fan)*w_fan - 2], center=true);
        }
    
        translate([0, 0, 1])
        rotate([0, 0, 30])
            cylinder(r=(w_fan-2)/2/sin(60), h=cos(a_fan)*w_fan - 2, $fn=3);
    
        rotate([0, 0, 120])
        translate([0, ww/2 + (sqrt(3)/2*w_fan)/3 + 1.9, 0])
            cube([w_fan-2, cos(a_fan)*w_fan - 6, 4], center=true);

        translate([0, 0, -1])
            cylinder(d=16.5, h=30, $fn=40);
    }

    for (a = [120, 240]) {
        rotate([0, 0, a])
        translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
        rotate([-45, 0, 0])
        translate([0, -w_fan/2, -1.5])
        difference() {
            for (x = [-w_fan/2, w_fan/2]) {
                for (y = [-w_fan/2, w_fan/2]) {
                    translate([x, y, 0])
                    intersection() {
                        cylinder(d=14, h=3, $fn=20);
                        
                        translate([x/(w_fan/2)*-3.5, y/(w_fan/2)*-3.5, 0])
                            cube([7, 7, 3], center=true);
                    }
                }
            }

            for (p = fan_hole_offsets) {
                translate([0, 0, 0])
                translate(p)
                    cylinder(d=2.5, h=4, $fn=20, center=true);
            }
        }
    }

    rotate([0, 0, 120])
    translate([0, (sqrt(3)/2*w_fan)/3 + 0.5, (cos(a_fan)*w_fan)/2])
        cube([w_fan-2, 1, cos(a_fan)*w_fan], center=true);
}

*for (a = [0, 120, 240]) {
    rotate([0, 0, a])
    union() {
            magnet_holder_slice();
        
        mirror([1, 0 ,0])
            magnet_holder_slice();
    }
}

#translate([0, 0, (21 + 4.45 + 2.25)])
rotate([0, 0, 0])
    hotend();

*for (a = [120, 240]) {
    rotate([0, 0, a])
    translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
    rotate([-45, 0, 0])
    translate([0, -w_fan/2, 0])
        30mm_fan();
}

