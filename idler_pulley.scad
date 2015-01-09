include <Pulley_T-MXL-XL-HTD-GT2_N-tooth.scad>

motor_shaft = 11.3;
teeth=20;
profile=5;
idler_ht=1;
pulley_t_ht=6.3;
pulley_b_ht=idler_ht;

// part 1
difference() {
    cylinder(d=motor_shaft+6.2, h=idler_ht, $fn=80);
    
    translate([0, 0, -1])
        cylinder(r=9.5/2, h=12, $fn=80);    
}

// part 2
translate([20, 0, 0])
difference() {
    union() {
            cylinder(d=motor_shaft+6.2, h=idler_ht, $fn=80);
        
        translate([0, 0, idler_ht])
            cylinder(d=motor_shaft - 0.2, h=1, $fn=motor_shaft*4);
    }
    
    translate([0, 0, -1])
        cylinder(r=9.4/2, h=12, $fn=80);    
}

