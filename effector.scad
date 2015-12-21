include <m3.scad>
use <layer_fan.scad>

play             = 0.3;
d_magnet         = 15 + 3 + play; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 4; // height of magnet
distance_magnets = 60;
a_magnet_mount   = -30;

module e3d_lite() {
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

module magnet_holder_slice() {
    a = r_magnet; // intersect point of ellipse with x-axis
    b = cos(a_magnet_mount) * r_magnet; // intersect point of ellipse with y-axis

    phi = atan(pow(b, 2) / pow(a, 2) * tan(-60));
    
    r = (a * b) / sqrt(pow(a, 2) * pow(sin(phi), 2) + pow(b, 2) * pow(cos(phi), 2));
    
    x0 = cos(-60) * r_magnet;
    y0 = sin(-60) * r_magnet;

    n0 = y0 - tan(30) * x0;
 
    yn = y0 - ((tan(30) * cos(phi) * r + n0) - (sin(phi) * r));

    x = cos(30) * (tan(30) * (distance_magnets + r_magnet)) - x0;
    y = sin(30) * (tan(30) * (distance_magnets + r_magnet)) - yn;

    h = -sin(a_magnet_mount) * r_magnet;

    translate([0, y, h])
    rotate([a_magnet_mount, 0, 0])
    translate([x, 0, 0])
    difference() {
        translate([0, 0, -10])
            cylinder(r=r_magnet, h=h_magnet + 8 + 2, $fn=80);

        translate([0, 0, 1])
            cylinder(d=d_magnet-3, h=h_magnet + 2, $fn=80);
    }
}

module effector() {
    union() {
        difference() {
            union() {
                difference() {
                    for (z = [0, 120, 240]) 
                    rotate([0, 0, z]) {
                        translate([-15, 0, 0])
                            cube([30, 34.5, 4]);
                        
                        rotate([0, 0, 30])
                        translate([0, -11, 0])
                            cube([22, 22, 4]);
                    }
                
                    translate([0, 45, 15 + 1])
                    rotate([90, 0, 0])
                        cylinder(d=28, h=70, $fn=80);
                    
                }

                for (z = [60, 180, 300]) {
                    rotate([0, 0, z])
                    union() {
                            magnet_holder_slice();
                        
                        mirror([1, 0 ,0])
                            magnet_holder_slice();
                    }
                }
            }
            
            translate([-15.2, -45, 1])
                cube([30.4, 30, 30]);

            translate([0, 0, -1])
                cylinder(d=23, h=31, $fn=80);

            translate([-50, -50, -20])
                cube([100, 100, 20]);
            
            for (a = [60, 180, 300])
            rotate([0, 0, a])
            translate([0, 20+19.5, 0])
                cylinder(d=38.5, h=12, center=true, $fn=80);

            translate([0, -15, 15 + 1])
            rotate([90, 0, 0])
            for (i = [-12, 12]) {
                for (j = [-12, 12]) {
                    translate([i, j, -10])
                        cylinder(d=1.9, h=11, $fn=20);
                }
            }
            
            rotate([0, 0, 240])
            translate([0, 25, 0])
                cylinder(d=9, h=10, center=true, $fn=20);
        }
        
        difference() {
            union() {
                cylinder(d=35, h=33, $fn=80);
                
                translate([0, 0, 33])
                    sphere(d=35, $fn=80, center=true);
                
                translate([0, 20, 15 + 1])
                rotate([90, 0, 0])
                    cylinder(d=30, h=40, $fn=80);

                translate([-15, -15, 0])
                    cube([30, 33, 17]);

                for (a = [60, 300]) {
                    rotate([0, 0, a])
                    translate([0, 15, 12.5])
                    difference() {
                        rotate([45, 0, 0])
                            cube([2.5, 25, 25], center=true);
                        
                        translate([0, 12, 0])
                        rotate([0, 90, 0])
                            cylinder(d=3.3, h=10, center=true, $fn=20);

                        translate([0, 20.5, 0])
                            cube([10, 10, 20], center=true);
                    }
                }

                translate([0, -7, 15 + 1])
                rotate([90, 0, 0])
                for (i = [-12, 12]) {
                    translate([i, 12, 0])
                        cylinder(d=6, h=10, $fn=20);
                }
            }

            translate([-17.5, 0, 33])
                cube([35, 20, 20]);
            
            translate([-20, -20, 42.7])
                cube([40, 40, 20]);
            
            translate([-15.2, -45, 1])
                cube([30.4, 30, 42]);

            translate([-15.2, 17.5, 4])
                cube([30.4, 10, 40]);

            translate([0, 20, 15 + 1])
            rotate([90, 0, 0])
                cylinder(d=28, h=40, $fn=80);

            translate([0, 0, -1])
                cylinder(d=16.3, h=45, $fn=80);

            translate([0, 0, -1])
                cylinder(d=23, h=31, $fn=80);

            translate([0, -7, 15 + 1])
            rotate([90, 0, 0])
            for (i = [-12, 12]) {
                for (j = [-12, 12]) {
                    translate([i, j, 0])
                        cylinder(d=2.1, h=10, $fn=20);
                }
            }

            for (x = [12, -12]) {
                translate([x, -10, 38]) 
                rotate([90, 0, 0]) {
                        cylinder(d=3.1, h=30, center=true, $fn=20);
                
                    rotate([0, 0, 30])
                        m3_nut(width=5.8, thickness=10);
                }
            }

            translate([-50, -50, -20])
                cube([100, 100, 20]);
        }
    }
}

module hotend_holder() {
    difference() {
        sphere(d=35, $fn=80, center=true);

        translate([0, 0, 10 + 9.7])
            cube([40, 40, 20], center=true);

        translate([0, 0, -10])
            cube([40, 40, 20], center=true);

        translate([-17.5, -20, -0.1])
            cube([35, 20, 9.8 + play]);

        translate([0, 0, 6])
            cylinder(d=16+play, h=3.7 + 0.1, $fn=80);

        translate([0, 0, -0.1])
            cylinder(d=12+play, h=6.2, $fn=80);
        
        for (x=[12, -12]) {
            translate([x, 15, 5])
            rotate([90, 0, 0]) {
                cylinder(d=3.3, h=30, $fn=20);
                cylinder(d=5.5, h=10, $fn=20);
            }
        }
    }
}

rotate([0, 0, 180])
effector();

translate([0, 0, 33])
rotate([0, 0, 180])
     hotend_holder();

rotate([0, 0, 180])
rotate([0, 0, 90])
    #e3d_lite();

*translate([0, -15, 15 + 2])
rotate([90, 0, 0])
    #fan(30, 10);

translate([0, 0, -7])
translate([0, 0, -10])
    layer_fan();
