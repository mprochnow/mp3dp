include <dimensions.scad>;

module layer_fan_upper_mount() {
    t=wall_thickness;
    
    translate([2.7, 0, layer_fan_mount_hole_x])
    difference() {
        union() {
            difference() {
                union() {
                    rotate([0, -45, 0])
                    translate([-10, -(layer_fan_width+2*t)/2, -4])
                        cube([10, layer_fan_width+2*t, 8]);
                    
                    translate([-10, -(layer_fan_width+2*t)/2, -4])
                        cube([10, layer_fan_width+2*t, 8]);
                }

                translate([-10-3.5, -50, -50])
                    cube([10, 100, 100]);
            }

            rotate([90, 0, 0])
            translate([0, 0, -t/2])
                cylinder(d=8, h=layer_fan_width+2*t+t, $fn=20, center=true);
        }

        // screw hole
        rotate([90, 0, 0])
        translate([0, 0, -t/2])
            cylinder(d=3.3, h=layer_fan_width+2*t+t+0.1, $fn=20, center=true);

        // screw head
        translate([0, -(layer_fan_width+2*t)/2+3, 0])
        rotate([90, 0, 0])
            cylinder(d=5.8, h=3.1, $fn=20);

        // nut trap
        translate([0, (layer_fan_width+2*t)/2+2.4, 0])
        rotate([90, 30, 0])
            cylinder(d=5.8/sin(60), h=2.4, $fn=6);

        // cutout for fan mount
        translate([0, (layer_fan_width-layer_fan_mount_width)/2, 0])
            cube([22, layer_fan_mount_width, 20], center=true);
    }
}

module hotend_mount() {
    t = wall_thickness;
    r = hotend_mount_od/2;
    h = hotend_mount_height;

    sh = support_height;
    sw = support_width;
    sd = tube_od-((tube_od-tube_id)/2)/3 - 0.2;

    e = sqrt(pow(sd, 2) - pow(sw, 2))/2 - r;

    translate([0, 0, tube_height])
    union() {
        difference() {
            union() {
                cylinder(d=hotend_mount_od, h=heat_sink_height+groove_mount_height, $fn=80);

                rotate([0, 0, 240])
                translate([-(layer_fan_width+2*t)/2, layer_fan_offset-5, 0])
                    cube([layer_fan_width+2*t, 5, layer_fan_mount_hole_x+layer_fan_mount_diameter/2]);

                rotate([0, 0, 330])
                translate([layer_fan_offset+t, 0, 0])
                    layer_fan_upper_mount();

                for (a=[0, 120]) {
                    rotate([0, 0, a]) {
                        translate([-sw/2, 0, 0])
                            cube([sw, r, h]);

                        difference() {
                            intersection() {
                                cylinder(d=sd, h=sh+5.5, $fn=tube_resolution);
                                
                                translate([-sw/2, 0, 0])
                                    cube([sw, sd/2, sh+5.5]);
                            }
                            
                            translate([0, 0, sh])
                            intersection() {
                                cylinder(d=sd-4*t, h=5.5+1, $fn=tube_resolution);
                                
                                translate([-(sw-4*t)/2, 0, 0])
                                    cube([sw-4*t, sd/2, sh+5.5]);
                            }

                            // mount screw holes
                            for (b=[-12, 12]) {
                                rotate([0, 0, b])
                                translate([0, sd/2, sh+5.5/2])
                                rotate([90, 0, 0])
                                    cylinder(d=3.3, h=10, $fn=16, center=true);
                            }
                        }
     
                        for (x=[-sw/2+t, sw/2-t]) {
                            translate([x-t, r, sh+5.5])
                            difference() {
                                cube([2*t, e, h-sh-5.5]);

                                translate([-0.05, e, 0])
                                rotate([atan(e/(h-sh-5.5)), 0, 0])
                                    cube([2*t+0.1, e, sqrt(pow(tube_od/2, 2)+pow(h-sh-5.5, 2))]);
                            }
                        }
                   }
                }
            }
            
            for (a=[0, 120]) {
                rotate([0, 0, a])
                translate([-(sw-4*t)/2, 0, sh])
                    cube([sw-4*t, r+0.1, h-sh-lower_groove_mount_height]);
            }

            // hotend cut-out start
            translate([0, 0, -0.05])
                cylinder(d=16.3, h=heat_sink_height+groove_mount_height+0.1, $fn=120);

            translate([0, 0, sh])
                cylinder(d=hotend_mount_od-4*t, h=h-sh-lower_groove_mount_height, $fn=120);

            translate([0, 0, -0.05])
                cylinder(d=23, h=sh+0.1, $fn=120);
            // hotend cut-out end
        
            rotate([0, 0, 60])
            for (x=[-1, 1]) {
                translate([x*(8+t+3.3/2), 0, h+9.7/2])
                union() {
                    rotate([90, 0, 0])
                        cylinder(d=3.3, h=20, $fn=16, center=true);
                    
                    translate([-6.4/2, -3/2-8-2*t, -5.5/2])
                        cube([6.4, 3, 10]);
                }

                translate([x*(6+r/2)-r/2, 0, h])
                    cube([r, 30, groove_mount_height]);
            }
             
            rotate([0, 0, 60])
            translate([-(hotend_mount_od+0.1)/2, 0, h])
                cube([hotend_mount_od+0.1, hotend_mount_od+0.1, groove_mount_height]);
        }

//        // fan mount
//        rotate([0, 0, 120])
//        for (x=[-1, 1]) {
//            translate([x*(sw/2-2*t-0.5)-t/2-0.5, r, sh])
//            union() {
//                translate([0, -t, 0])
//                    cube([t+1, t, h-sh-lower_groove_mount_height]);
//
//                translate([0, fan_width+play, 0])
//                    cube([t+1, t, 5.5]);
//            }
//        }
    }
}

module hotend_holder() {
    t = wall_thickness;
    h = groove_mount_height - lower_groove_mount_height;
    r = hotend_mount_od/2;

    translate([0, 0, tube_height+hotend_mount_height])
    difference() {
        cylinder(d=hotend_mount_od, h=h, $fn=120);
        
        translate([0, 0, 5.9])
            cylinder(d=16+play, h=4, $fn=120);

        translate([0, 0, -0.05])
            cylinder(d=12+play, h=6, $fn=120);

        rotate([0, 0, 60]) {
            translate([-(hotend_mount_od+0.1)/2, -hotend_mount_od+0.1, -0.05])
                cube([hotend_mount_od+0.1, hotend_mount_od, h+0.1]);
            
            for (x=[-1, 1]) {
                translate([x*(8+t+3.3/2), 0, h/2])
                rotate([90, 0, 0])
                    cylinder(d=3.3, h=hotend_mount_od+1, $fn=16, center=true);
                
                translate([x*(8+t+3.3/2), 30+9.4, h/2])
                rotate([90, 0, 0])
                    cylinder(d=5.8, h=30, $fn=16);
            }
        }
    }
}

hotend_mount();
hotend_holder();
