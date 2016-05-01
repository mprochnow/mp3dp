include <dimensions.scad>;
include <mocks.scad>;

module magnet_holder_slice(outer_only=false, inner_only=false) {
    difference() {
        translate([0, 0, 15.1])
        difference() {
            for(a=[0, 120, 240]) {
                union() {
                    rotate([0, 0, a]){
                        for(i=[-1, 1]) {
                            translate([0, magnet_y, magnet_h])
                            rotate([a_magnet_mount, 0, 0])
                            translate([i*magnet_x, 0, -20])
                                cylinder(r=r_magnet+0.8, h=20+h_magnet, $fn=80);
                        }
                    }
                }
            }

            for(a=[0, 120, 240]) {
                union() {
                    rotate([0, 0, a]){
                        for(i=[-1, 1]) {
                            translate([0, magnet_y, magnet_h])
                            rotate([a_magnet_mount, 0, 0])
                            translate([i*magnet_x, 0, 0])
                                cylinder(d=d_magnet, h=h_magnet+0.1, $fn=80);
                        }
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

module layer_fan_lower_mount() {
    t = wall_thickness;
    r = layer_fan_mount_diameter / 2;
    a = layer_fan_mount_hole_x - layer_fan_depth - t;
    b = layer_fan_mount_hole_y;
    c = sqrt(pow(a, 2) + pow(b, 2));
    l = sqrt(pow(c , 2) - pow(r, 2));
    m = atan(b / a) + asin(r / c);

    difference() {
        union() {
            rotate([0, -m, 0])
            translate([-0.5*l, 0, -r])
                cube([3*l, layer_fan_width+2*t, 2*r], center=true);
            
            translate([a, (layer_fan_width+2*t)/2+t, b])
            rotate([90, 0, 0])
                cylinder(r=r, h=layer_fan_width+2*t+t, $fn=40);
        }

        // screw hole
        translate([a, (layer_fan_width+2*t+0.1)/2+t, b])
        rotate([90, 0, 0])
            cylinder(d=3.3, h=layer_fan_width+2*t+t+0.1, $fn=20);

        // screw head
        translate([a, -(layer_fan_width+2*t)/2+3, b])
        rotate([90, 0, 0])
            cylinder(d=5.8, h=3.1, $fn=20);

        // nut trap
        translate([a, (layer_fan_width+2*t)/2+2.4, b])
        rotate([90, 30, 0])
            cylinder(d=5.8/sin(60), h=2.4, $fn=6);

        // cutout for fan mount
        translate([(a+r+0.1)/2, (layer_fan_width-layer_fan_mount_width)/2, 0])
            cube([a+r+0.1, layer_fan_mount_width, tube_height+layer_fan_mount_height], center=true);
    }
}

module outer_tube() {
    t = wall_thickness;
    w = tube_od/2 - tube_id/2;
    h = tube_height;
    d = tube_od-((tube_od-tube_id)/2)/3;

    difference() {
        union() {
            magnet_holder_slice();

            rotate_extrude($fn=tube_resolution) {
                translate([tube_id/2+w/2,0,0])
                    duct_outline(w, h);
            }

            // radial fan mount
            rotate([0, 0, 330]) {
                translate([layer_fan_offset, -(layer_fan_width+2*t)/2, 0])
                    cube([t+layer_fan_depth+t, layer_fan_width+2*t, h+layer_fan_mount_height]);

                translate([layer_fan_offset+t+layer_fan_depth+t, 0, h])
                    layer_fan_lower_mount();
            }
            
            // upper part mount
            translate([0, 0, tube_height-sin(45)*4*t])
            intersection () {
                difference() {
                    cylinder(d=d+4*t, h=sin(45)*4*t+support_height+5.8, $fn=tube_resolution);
                
                    translate([0, 0, -0.05])
                        cylinder(d=d, h=sin(45)*4*t+support_height+5.8+0.1, $fn=tube_resolution);
                }
                
                union() {
                    for (a=[0, 120]) {
                        rotate([0, 0, a])
                        translate([-support_width/2, 0, 0])
                            cube([support_width, (d+8*t)/2, sin(45)*4*t+support_height+5.8]);
                    }
                }
            }

            // central "wind shield"
            cylinder(d=tube_id+2, h=t, $fn=tube_resolution);
        }

        // mount screw holes
        for (a=[0, 120]) {
            rotate([0, 0, a])
            for (b=[-12, 12]) {
                rotate([0, 0, b])
                union() {
                    translate([0, d/2, tube_height+support_height+5.8/2])
                    rotate([90, 0, 0])
                        cylinder(d=3.3, h=10, $fn=16, center=true);
                    
                    translate([0, 10+d/2+1.8*t, tube_height+support_height+5.8/2])
                    rotate([90, 0, 0])
                        cylinder(d=5.8, h=10, $fn=16);
                }
            }
        }

        translate([0, 0, -0.05])
            cylinder(d=10, h=t+0.1, $fn=20);
    }
}

module inner_tube() {
    t = wall_thickness;
    w = tube_od/2 - tube_id/2 - t - 2*t;
    h = tube_height - 2 * t;

    translate([0, 0, t])
    rotate_extrude($fn=tube_resolution) {
        translate([tube_id/2+w/2+2*t, 0, 0])
            duct_outline(w, h);
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

    // radial fan mount
    rotate([0, 0, 330]) {
        translate([layer_fan_offset+2*t, -(layer_fan_width-2*t)/2, t])
            cube([layer_fan_depth-2*t, layer_fan_width-2*t, tube_height+layer_fan_mount_height]);

        translate([layer_fan_offset+t, -(layer_fan_width)/2, tube_height])
            cube([layer_fan_depth, layer_fan_width, layer_fan_mount_height+0.1]);

        translate([layer_fan_offset-0.05, -1, tube_height+5.3])
            cube([t+0.1, 2, 7.5]);

        translate([layer_fan_offset+layer_fan_depth+2*t, 0, tube_height])
        rotate([0, atan(layer_fan_mount_height/(layer_fan_depth+2*t)), 0])
        translate([-2*layer_fan_depth, -(layer_fan_width+2*t+1)/2, 0])
            cube([2*layer_fan_depth, layer_fan_width+2*t+1, layer_fan_mount_height]);
    }
}

module layer_fan_upper_mount() {
    t=wall_thickness;
    
    translate([2.7, 0, layer_fan_mount_hole_x])
    difference() {
        union() {
            rotate([0, -45, 0])
            translate([-20, -(layer_fan_width+2*t)/2, -4])
                cube([20, layer_fan_width+2*t, 8]);
            
            translate([-10, -(layer_fan_width+2*t)/2, -4])
                cube([10, layer_fan_width+2*t, 8]);

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
    difference() {
        union() {
            cylinder(d=hotend_mount_od, h=heat_sink_height+groove_mount_height, $fn=80);

            for (a=[0, 120]) {
                rotate([0, 0, a]) {
                    difference() {
                        intersection() {
                            cylinder(d=sd, h=sh+5.8, $fn=tube_resolution);
                            
                            translate([-sw/2, 0, 0])
                                cube([sw, sd/2, sh+5.8]);
                        }
                        
                        translate([0, 0, sh])
                        intersection() {
                            cylinder(d=sd-4*t, h=sh+5.8, $fn=tube_resolution);
                            
                            translate([-(sw-4*t)/2, 0, 0])
                                cube([sw-4*t, sd/2, sh+5.8]);
                        }
                    }

                    difference() {
                        translate([-sw/2, 0, 0])
                            cube([sw, r, h]);

                        translate([-(sw-4*t)/2, 0, sh])
                            cube([sw-4*t, r+e, h-sh-lower_groove_mount_height]);
                    }

                    for (x=[-sw/2+t, sw/2-t]) {
                        translate([x-t, r, sh+5.8])
                        difference() {
                            cube([2*t, e, h-sh-5.8]);

                            translate([-0.05, e, 0])
                            rotate([atan(e/(h-sh-5.8)), 0, 0])
                                cube([2*t+0.1, e, sqrt(pow(tube_od/2, 2)+pow(h-sh-5.8, 2))]);
                        }
                    }
                }
            }

            rotate([0, 0, 240])
            translate([-(layer_fan_width+2*t)/2, layer_fan_offset-5, 0])
                cube([layer_fan_width+2*t, 5, layer_fan_mount_hole_x+layer_fan_mount_diameter/2]);
            
            rotate([0, 0, 330])
            translate([layer_fan_offset+t, 0, 0])
                layer_fan_upper_mount();
        }

        for (a=[0, 120]) {
            rotate([0, 0, a]) {
                translate([-(sw-4*t)/2, 0, sh])
                    cube([sw-4*t, r+0.1, h-sh-lower_groove_mount_height]);

                // mount screw holes
                for (b=[-12, 12]) {
                    rotate([0, 0, b])
                    translate([0, sd/2, sh+5.8/2])
                    rotate([90, 0, 0])
                        cylinder(d=3.3, h=10, $fn=16, center=true);
                }
            }
        }

        // hotend cut-out start
        translate([0, 0, -0.05])
            cylinder(d=16.3, h=heat_sink_height+groove_mount_height+0.1, $fn=120);

        translate([0, 0, sh])
            cylinder(d=hotend_mount_od-2*t, h=h-sh-lower_groove_mount_height, $fn=120);

        translate([0, 0, -0.05])
            cylinder(d=23, h=sh+0.1, $fn=120);
        // hotend cut-out end
        
        rotate([0, 0, 60])
        for (x=[-1, 1]) {
            translate([x*(8+t+3.3/2), 0, h+9.7/2])
            union() {
                rotate([90, 0, 0])
                    cylinder(d=3.3, h=20, $fn=16, center=true);
                
                translate([-6.4/2, -3/2-8-2*t, -5.8/2])
                    #cube([6.4, 3, 10]);
            }
            translate([x*(6+r/2)-r/2, -8+2*t, h])
                cube([r, 30, groove_mount_height]);
        }
        
        rotate([0, 0, 60])
        translate([-(hotend_mount_od+0.1)/2, 0, h])
            cube([hotend_mount_od+0.1, hotend_mount_od+0.1, groove_mount_height]);
    }
}

difference() {
    outer_tube();
    inner_tube();
}

hotend_mount();

rotate([0, 0, -120])
    #e3d_lite();

rotate([0, 0, 120])
translate([0, hotend_mount_od/2, tube_height+support_height+fan_diameter/2])
translate([0, 10, 0])
rotate([90, 0, 0])
    #fan(fan_diameter, 10);
