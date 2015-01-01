play             = 0.3;
d_magnet         = 15 + 2 + play;       // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6 + 2;               // height of magnet
distance_magnets = 60;
a_magnet_mount   = -45;             // -90 <= a_magnet_mount <= 0

module 30mm_fan() {
    hole_offsets = [
        [ -12,  12],
        [  12,  12],
        [  12, -12],
        [ -12, -12]
    ];
    
    difference() {
        hull() {
            for (a = hole_offsets) {
                translate(a)
                    cylinder(d=4, h=10, center=true, $fn=40);
            }
        }
        
        for (a = hole_offsets) {
            translate(a)
                cylinder(d=3.1, h=11, center=true, $fn=20);
        }
        
        cylinder(d=27.9, h=11, center=true, $fn=80);
    }
}

module magnet_holder_slice(cutout=0) {
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

    echo(y);

    h = -sin(a_magnet_mount) * r_magnet;

    if (cutout == 1) {
        translate([x, y - sin(a_magnet_mount), h + cos(a_magnet_mount)])
        rotate([a_magnet_mount, 0, 0])
            cylinder(r=r_magnet - 1, h=h_magnet + 1, $fn=40);

        translate([-x, y - sin(a_magnet_mount), h + cos(a_magnet_mount)])
        rotate([a_magnet_mount, 0, 0])
            cylinder(r=r_magnet - 1, h=h_magnet + 1, $fn=40);
    } else {
        translate([0, y, h])
        rotate([a_magnet_mount, 0, 0])
        translate([0, 0, h_magnet/2])
            cube([2 * (x + r_magnet), d_magnet, h_magnet] , center=true);
    }
}

*difference(){
    magnet_holder_slice(0);
    magnet_holder_slice(1);
}

difference() {
    hull() {
        for (z = [0, 120, 240]) {
            rotate([0, 0, z])
                magnet_holder_slice();
        }
    }
    for (z = [0, 120, 240]) {
        rotate([0, 0, z])
        union() {
            magnet_holder_slice(cutout=1);
            
            translate([-15, 0, 1])
                cube([30, 100, 50]);
        }
    }
    
    translate([0, 0, -1])
        cylinder(r=10, h=40, $fn=40);
}

