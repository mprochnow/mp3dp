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

module hotend_mount() {
    t = wall_thickness;
    d = hotend_mount_od/2;
    h = 33;
    b = hotend_mount_od/2 * sin(30);
    c = hotend_mount_od/2 * sin(60);
    e = sqrt(pow((tube_od-(tube_od/2-tube_id/2)/3)/2, 2) - pow(c, 2)) - b;
    
    translate([0, 0, tube_height])
    difference() {
        union() {
            cylinder(d=hotend_mount_od, h=h, $fn=128);
            
            for (a=[0, 120]) {
                rotate([0, 0, a]) {
                    intersection() {
                        translate([-c, 0, 0])
                            cube([c*2, tube_od, 2]);
                    
                        cylinder(d=tube_od-(tube_od/2-tube_id/2)/3, h=2, $fn=128);
                    }
                    
                    for(x=[-c+t, c-t]) {
                        translate([x, b, 2])
                        difference() {
                            translate([-(2*t)/2, 0, 0])
                                cube([2*t, e, h-2]);
                            
                            translate([-(2*t+0.1)/2, e, 0])
                            rotate([atan(e/(h-2)), 0, 0])
                                cube([2*t+0.1, e, sqrt(pow(tube_od/2, 2)+pow(h-2, 2))]);
                        }
                    }
                }
            }
            
            rotate([0, 0, 240])
            translate([-(layer_fan_width+2*t)/2, 0, 0])
                cube([layer_fan_width+2*t, hotend_mount_od/2, layer_fan_mount_height]);
        }
        
        union() {
            for (a=[0, 120]) {
                rotate([0, 0, a]) {
                    translate([0, 20, 15 + 1])
                    rotate([90, 0, 0])
                        cylinder(d=27, h=20, $fn=80);
                    
                    translate([-27/2, 0, 2])
                        cube([27, 27, 15]);
                }
            }

            translate([0, 0, -1])
                cylinder(d=16.3, h=45, $fn=80);

            translate([0, 0, -1])
                cylinder(d=23, h=31, $fn=80);

            translate([0, 0, 2])
                cylinder(d=27, h=28, $fn=80);
        }
    }
}

difference() {
    outer_tube();
    inner_tube();
}

hotend_mount();

*rotate([0, 0, -120])
    #e3d_lite();

*rotate([0, 0, 120])
translate([0, 15, tube_height+15])
translate([0, 10, 0])
rotate([90, 0, 0])
    fan(30, 10);

