play             = 0.3;
d_magnet         = 15 + play;       // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6;               // height of magnet
distance_magnets = 60;
a_magnet_mount   = -45;             // -90 <= a_magnet_mount <= 0

module magnet_holder_slice() {
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

    translate([0, y, 0])
    rotate([a_magnet_mount, 0, 0])
    union() {
        translate([x, 0, 0])
            cylinder(r=r_magnet, h=h_magnet, $fn=40);
    }
}

for (z = [0, 120, 240]) {
    rotate([0, 0, z])
    union() {
            magnet_holder_slice();
        
        mirror([1, 0 ,0])
            magnet_holder_slice();
    }
}

