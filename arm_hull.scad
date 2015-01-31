difference() {
    cylinder(d1=9.6, d2=7.3, h=10, $fn=80);

    union() {
            cylinder(d1=9, d2=6.7, h=10, $fn=80);
        
        translate([0, 0, 15])
            cylinder(d=6.7, h=5, $fn=80);
        
        translate([0, 0, -5])
            cylinder(d=9, h=5, $fn=80);
    }
}
