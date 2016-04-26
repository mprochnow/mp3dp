module e3d_lite() {
    rotate([0, 0, 0])
    translate([0, 0, 16.7]) {
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
