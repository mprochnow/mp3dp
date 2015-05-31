include <settings.scad>
include <polyhole.scad>

include <m3.scad>

d_magnet         = 15 + 3 + 0.6;       // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 4;               // height of magnet
distance_magnets = 60;
a_magnet_mount   = -58;             // -90 <= a_magnet_mount <= 0

o_fan = 0; // vertical offset of fan
h_fan = 10;
w_fan = 30;
a_fan = 58;

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

    difference() {
        union() {
            translate([0, y, h])
            rotate([a_magnet_mount, 0, 0])
            translate([x, 0, 0])
                cylinder(d=d_magnet, h=h_magnet, $fn=40);

            rotate([0, 0, 240])
            translate([0, y, h])
            rotate([a_magnet_mount, 0, 0])
            translate([-x, 0, 0])
                cylinder(d=d_magnet, h=h_magnet, $fn=40);
                
            hull() {
                translate([0, y, h])
                rotate([a_magnet_mount, 0, -0.1])
                translate([x, 0, 0])
                    cylinder(d=d_magnet, h=0.1, $fn=40);

                rotate([0, 0, 240])
                translate([0, y, h])
                rotate([a_magnet_mount, 0, -0.1])
                translate([-x, 0, 0])
                    cylinder(d=d_magnet, h=0.1, $fn=40);
            }
        }
        
        union() {
            translate([0, y, h])
            rotate([a_magnet_mount, 0, 0])
            translate([x, 0, 1])
                cylinder(d=d_magnet-3, h=h_magnet, $fn=40);
        
            rotate([0, 0, 240])
            translate([0, y, h])
            rotate([a_magnet_mount, 0, 0])
            translate([-x, 0, 1])
                cylinder(d=d_magnet-3, h=h_magnet, $fn=40);
        }
    }
}

module effector() {
    ww = cos(a_fan)*w_fan + 2;

    difference() {
        union() {
            difference() {
                union() {
                    translate([-w_fan/2, -17.5, 0])
                        cube([w_fan, 35, 21 + 4.45 + 4.5 + 4.75]);

                    for (a = [0, 120, 240]) {
                        rotate([0, 0, a])
                        union() {
                            translate([0, ww/2 + (sqrt(3)/2*w_fan)/3, (21 + 4.45 + 4.5 + 4.75)/2])
                                cube([w_fan, ww, 21 + 4.45 + 4.5 + 4.75], center=true);

                            translate([-33, ww/2 + (sqrt(3)/2*w_fan)/3 + 4.2, 0])
                            rotate([-58, 0, 0])
                                cube([66, 4, 4]);

                                magnet_holder_slice();

                            translate([-0.9, -13, -26.6])
                            rotate([45, 0, 0])
                                cube([1.8, 40, 40]);
                        }
                    }
                }
                
                for (a = [0, 120, 240]) {
                    rotate([0, 0, a]) {
                        union() {
                            translate([0, ww/2 + (sqrt(3)/2*w_fan)/3, (sin(a_fan)*w_fan)/2-0.5])
                                cube([w_fan-3.6, 30, sin(a_fan)*w_fan-4], center=true);
                
                            translate([0, (sqrt(3)/2*w_fan)/3 + 2 + w_fan/2, 21 + 4.45 + 5])
                                cube([w_fan + 10, w_fan, 10], center=true);
                        }
                    }
                }
            
                rotate([0, 0, 120])
                translate([0, ww/2 + (sqrt(3)/2*w_fan)/3 - 1, 0])
                    cube([w_fan-3.6, cos(a_fan)*w_fan - 3, 4], center=true);

                translate([0, (sqrt(3)/2*w_fan)/3 + 1.5, 21 + 4.45 + (4.75 + 4.5)/2])
                rotate([90, 0, 0])
                union() {
                    translate([-11, 0, 0]) {
                            polyhole(17, 3.3);

                        rotate([0, 0, 30])
                            m3_nut(width=5.8);
                    }
                    
                    translate([11, 0, 0]) {
                            polyhole(17, 3.3);
                        
                        rotate([0, 0, 30])
                            m3_nut(width=5.8);
                    }
                }
                
                translate([-w_fan, -25, 21 + 4.45])
                    cube([2*w_fan, 30, 30]);

                translate([0, 0, -1])
                    cylinder(d=16.6, h=60, $fn=80);
            }

            for (a = [120, 240]) {
                rotate([0, 0, a])
                translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
                rotate([-a_fan, 0, 0])
                translate([0, -w_fan/2, -1.5])
                for (x = [-1, 1]) {
                    for (y = [-1, 1]) {
                        translate([x * w_fan/2, y * w_fan/2, -1.5])
                        intersection() {
                            cylinder(d=14, h=7, $fn=20);
                            
                            translate([x * -3.5, y * -3.5, 0])
                                cube([7, 7, 6.25], center=true);
                        }
                    }
                }
            }

            rotate([0, 0, 120])
            translate([0, (sqrt(3)/2*w_fan)/3 + 1.8, (sin(a_fan)*w_fan)/2])
                cube([w_fan-2, 1.8, sin(a_fan)*w_fan], center=true);

        }
        
        for (a = [120, 240]) {
            rotate([0, 0, a])
            translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
            rotate([-a_fan, 0, 0])
            translate([0, -w_fan/2, -1.5])
            for (p = fan_hole_offsets) {
                translate([0, 0, 0])
                translate(p)
                    cylinder(d=2.5, h=10, $fn=20, center=true);
            }
        }

        for (a = [0, 120, 240]) {
            rotate([0, 0, a]) {
                translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
                rotate([-a_fan, 0, 0])
                translate([0, -w_fan/2 +2.5, h_fan])
                    cube([w_fan + 0.2, w_fan + 5, h_fan*2], center=true);
            }
        }

        translate([0, 0, -20])
            cube([100, 100, 40], center=true);
    }

    difference() {
        union() {
            hull() {
                translate([-(w_fan-3.9)/2, (sqrt(3)/2*w_fan)/3 - 4.5, sin(a_fan)*w_fan - 3.5 - 0.2])
                    cube([w_fan-3.9, 8, 1]);
            
                translate([0, 0, 0.5])
                    cube([9, 9, 1], center=true);
            }

            hull() {
                rotate([0, 0, 120])
                translate([-(w_fan-3.9)/2, (sqrt(3)/2*w_fan)/3 - 4.5, sin(a_fan)*w_fan - 3.5 - 0.2])
                    cube([w_fan-3.9, 4.2, 1]);

                translate([0, 0, 0.5])
                    cube([9, 9, 1], center=true);
            }
            
            hull() {
                rotate([0, 0, 240])
                translate([-(w_fan-14)/2, (sqrt(3)/2*w_fan)/3 - 4.3, sin(a_fan)*w_fan - 3.5 - 0.2])
                    cube([w_fan-14, 8, 1]);
            
                translate([0, 0, 0.5])
                    cube([9, 9, 1], center=true);
            }

            hull() {
                rotate([0, 0, 240])
                translate([-(w_fan-3.9)/2, (sqrt(3)/2*w_fan)/3 - 4.5, sin(a_fan)*w_fan - 3.5 - 0.2])
                    cube([w_fan-3.9, 4, 1]);
            
                translate([0, 0, 0.5])
                    cube([9, 9, 1], center=true);
            }
        }
        
        for (x = [0 : 40]) {
            translate([-20 + x * 1.25, -25, sin(a_fan)*w_fan - 3.5 - 0.2])
                cube([1, 50, 5]);
        }
        
        translate([-0.4, -25, -1])
            cube([0.8, 50, 30]);

        translate([-25, -0.4, -1])
            cube([50, 0.8, 30]);
    }
}

module hotend_holder() {
    translate([11, -4.626, 0])
        cylinder(d=5.3, h=11.75, $fn=10);

    translate([-11, -4.626, 0])
        cylinder(d=5.3, h=11.75, $fn=10);

    rotate([90, 0, 0])
    translate([0, 11, 0])
    difference() {
        union() {
            translate([-w_fan/2, -17.5, 0])
                cube([w_fan, 35, 9.25]);

            translate([0, 0, 9.25])
            rotate([0, 0, 22.5])
                cylinder(d1=21, d2=10, h=4, $fn=8);
        }

        union() {
            translate([0, 0, 4.3])
                cylinder(d=16.6, h=4.95, $fn=80);

            translate([-16.6/2, 0, 4.3])            
                cube([16.6, 5, 4.95]);
                
            translate([0, 0, -0.1])
                cylinder(d=11.92, h=4.65, $fn=80);

            translate([-11.92/2, 0, -0.1])            
                cube([11.92, 5, 4.65]);
                
            translate([0, 4.45 - 3.5, 4.65])
            rotate([90, 0, 0])
            union() {
                translate([-11, 0, 0]) {
                    translate([0, 0, -8.48])
                        polyhole(17, 3.3);

                    cylinder(d=5.8, h=10, $fn=20);
                }
                
                translate([11, 0, 0]) {
                    translate([0, 0, -8.48])
                        polyhole(17, 3.3);
                    
                    cylinder(d=5.8, h=10, $fn=20);
                }
            }
            
            polyhole(30, 4.2);
            
            translate([0, w_fan/2 + 4.45, 0])
                cube([w_fan + 10, w_fan, 2*9.269], center=true);

            for (a = [120, 240]) {
                rotate([0, 0, a]) {
                    union() {
                        translate([0, (sqrt(3)/2*w_fan)/3 + 2 + w_fan/2, 0])
                            cube([w_fan + 10, w_fan, 20], center=true);
                    }
                }
            }
            
            translate([0, -w_fan/2 - 11, 0])
                cube([w_fan + 10, w_fan, 20], center=true);
        }
    }
}

module fan_shroud() {
    y = (sqrt(3)/2*w_fan)/3;

    rotate([0, 0, 120]) {
        difference() {
            hull() {
                translate([0, y + (cos(a_fan)*w_fan)/2 + 0.5, -0.3])
                    cube([w_fan-1.3, cos(a_fan)*w_fan - 1.2, 0.3], center=true);

                translate([0, y + (cos(a_fan)*w_fan)/2 - 3.5, -15])
                    cube([w_fan-14, cos(a_fan)*w_fan - 10, 0.1], center=true);
            }

            hull() {
                translate([0, y + (cos(a_fan)*w_fan)/2 + 0.5, -0.3])
                    cube([w_fan-3.2, cos(a_fan)*w_fan - 3, 0.3], center=true);

                translate([0, y + (cos(a_fan)*w_fan)/2 - 4, -16])
                    cube([w_fan-17, cos(a_fan)*w_fan - 13, 0.1], center=true);
            }
        
            translate([0, y + (cos(a_fan)*w_fan)/2 + 0.5, -0.3])
                cube([w_fan-3.5, cos(a_fan)*w_fan - 3.5, 1], center=true);

            translate([0, y + (cos(a_fan)*w_fan)/2 + 3.5, 0])
            rotate([-25, 0, 0])
            translate([0, 0, -17])
                cube([w_fan, cos(a_fan)*w_fan, 3], center=true);
        }
    }
}

effector();

*hotend_holder();

*rotate([180, 0, 0])
fan_shroud();

*translate([0, 0, (21 + 4.45 + 2.25)])
rotate([0, 0, 30])
    hotend();

*for (a = [120, 240]) {
    rotate([0, 0, a])
    translate([0, ww + (sqrt(3)/2*w_fan)/3, 0])
    rotate([-a_fan, 0, 0])
    translate([0, -w_fan/2, 0])
        30mm_fan();
}

