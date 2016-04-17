include <m3.scad>
use <layer_fan.scad>

nozzle_width = 0.4;
wall_thickness = 2 * nozzle_width;

play             = 0.3;
d_magnet         = 15 + play; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 4; // height of magnet
distance_magnets = 60;
a_magnet_mount   = -30;

tube_od = 88;
tube_id = 33; //inner ring diameter adjust for clearance around the hotend
tube_dia = (tube_od - tube_id) / 3;
tube_resolution = 256;
tube_height = 14.7+2; //11.5+2;
tube_opening_width = 3;

layer_fan_offset = 24; // offset of layer fan from center
layer_fan_width = 19.6;
layer_fan_depth = 31;

/*
    Calculation of magnet position
*/
// tilted circle projects an ellipse
a = r_magnet; // intersection point of ellipse with x-axis
b = cos(a_magnet_mount) * r_magnet; // intersect point of ellipse with y-axis

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

c = (tan(30) * (distance_magnets + r_magnet));

magnet_x = cos(30) * c - x0;
magnet_y = sin(30) * c - yn;

magnet_h = -sin(a_magnet_mount) * (r_magnet+1.5);
///////////////////////////////////////////////////////////////////////////////

module e3d_lite() {
    rotate([0, 0, 0])
    translate([0, 0, 14.7+2]) {
        translate([0, 0, 39])
            cylinder(d=16, h=3.7, $fn=20);
        
        translate([0, 0, 33])
            cylinder(d=12, h=6, $fn=20);
        
        translate([0, 0, 30])
            cylinder(d=16, h=3, $fn=20);
        
        translate([0, 0, 0])
            cylinder(d=6, h=30, $fn=20);
        
        for (i = [0 : 8]) {
            translate([0, 0, 3.5 * i])
                cylinder(d=22.3, h=1.5, $fn=20);
        }
        
        translate([0, 0, -3.2])
            cylinder(d=5.5, h=3.2, $fn=20);
        
        translate([-15.5, -8, -14.7])
            cube([20, 16, 11.5]);
        
        translate([0, 0, -20.2])
            cylinder(d1=1, d2=7, h=5.5, $fn=20);
    }
}

module fan(w, h, o=3) {
    p = w / 2 - o;

    translate([0, 0, h/2])
    difference() {
        cube([w, w, h], center=true);

        cylinder(d=w-2, h=h+1, center=true, $fn=80);
        
        for (x = [-p, p]) {
            for (y = [-p ,p]) {
                translate([x, y, 0])
                    cylinder(d=3.1, h=h+1, center=true, $fn=20);
            }
        }
    }
}

module magnet_holder_slice(outer_only=false, inner_only=false) {
    difference() {
        for(a=[0, 120, 240]) {
            translate([0, 0, 14.7])     
            rotate([0, 0, a]){
                for(i=[-1, 1]) {
                    translate([0, magnet_y, magnet_h])
                    rotate([a_magnet_mount, 0, 0])
                    translate([i*magnet_x, 0, 0])
                    difference() {
                        translate([0, 0, -20])
                            cylinder(r=r_magnet+1.5, h=20+h_magnet + 2, $fn=80);

                        translate([0, 0, +2])
                            cylinder(d=d_magnet, h=h_magnet+0.1, $fn=80);
                    }
                }
            }
        }

        translate([0, 0, -20+tube_height/4])
            cylinder(r=2*c, h=20);
    }
}

module duct_outline(w, h) {
    polygon(points=[[w/3,0],
                    [w/2, h/4],
                    [w/2, h-h/4],
                    [w/3, h],
                    [-w/2+h, h],
                    [-w/2,0]],
            paths=[[0, 1, 2, 3, 4, 5]]);
    
}

module outer_tube() {
    t = wall_thickness;
    w = tube_od/2 - tube_id/2;
    h = tube_height;
    
    difference() {
        union() {
            magnet_holder_slice();
            
            rotate_extrude($fn=tube_resolution) {
                translate([tube_id/2+w/2,0,0])
                    duct_outline(w, h);
            }

            // radial fan mount
            rotate([0, 0, 330])
            translate([layer_fan_offset, -(19.6+2*t)/2, 0])
                cube([layer_fan_depth+2*t, layer_fan_width+2*t, tube_height+15+1.6]);
            
            cylinder(d=tube_id+2, h=t, $fn=tube_resolution);
        }
        translate([0, 0, -0.05])
            cylinder(d=10, h=t+0.1, $fn=20);
    }
}

module inner_tube() {
    t = wall_thickness;
    w = tube_od/2 - tube_id/2 - t - 2*t;
    h = tube_height - 2 * t;
    
    translate([0, 0, t]) {
        rotate_extrude($fn=tube_resolution) {
            translate([tube_id/2+w/2+2*t,0,0])
                duct_outline(w, h);
        }

        // radial fan mount
        rotate([0, 0, 330]) {
            translate([layer_fan_offset+2*t, -(layer_fan_width-2*t)/2, 0])
                cube([layer_fan_depth-2*t, layer_fan_width-2*t, tube_height+15]);

            translate([layer_fan_offset+t, -(layer_fan_width)/2, tube_height])
                cube([layer_fan_depth, layer_fan_width, 15+1.6+0.1]);

            translate([layer_fan_offset-0.05, -1, tube_height+5.3])
                cube([t+0.1, 2, 7.5]);

            translate([layer_fan_offset+layer_fan_depth+2*t+0.1, 0, tube_height+1.6])
            rotate([0, atan((15-1.6)/(layer_fan_depth+2*t)), 0])
            translate([-2*layer_fan_depth, -(layer_fan_width+2*t+1)/2, 0])
                cube([2*layer_fan_depth, layer_fan_width+2*t+1, 15]);
        }
    }

    difference() {
        translate([0, 0, -tube_opening_width/2])
        rotate_extrude($fn=tube_resolution)
        translate([tube_id/2+t+tube_opening_width/2, 0, 0])
        rotate([0, 0, 45])
            square([tube_opening_width, sin(45)*tube_opening_width]);
    
        for(a=[0:12])
            rotate([0, 0, a*360/12])
            translate([-wall_thickness, 0, -0.1])
                cube([2*wall_thickness, tube_od, tube_opening_width*2]);
    }

}

difference() {
    outer_tube();
    inner_tube();
}

*#e3d_lite();

*rotate([0, 0, 180])
translate([0, 15, 14.7 + 2 + 15])
translate([0, 10, 0])
rotate([90, 0, 0])
    #fan(30, 10);
