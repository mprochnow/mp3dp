include <dimensions.scad>

module magnet_holder() {
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
            rotate_extrude($fn=tube_resolution) {
                translate([tube_id/2+w/2, 0, 0])
                    polygon(points=[[w/2-h/4, 0],
                                    [w/2, h/4],
                                    [w/2, h-h/4],
                                    [w/2-h/4, h],
                                    [-w/2+h, h],
                                    [-w/2, 0]]);
            }

            // central "wind shield"
            cylinder(d=tube_id+4*t, h=t, $fn=tube_resolution);

            magnet_holder();

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
                    cylinder(d=d+4.5*t, h=sin(45)*4*t+support_height+5.5, $fn=tube_resolution);
                
                    translate([0, 0, -0.05])
                        cylinder(d=d, h=sin(45)*4*t+support_height+5.5+0.1, $fn=tube_resolution);
                }
                
                union() {
                    for (a=[0, 120]) {
                        rotate([0, 0, a])
                        translate([-support_width/2, 0, 0])
                            cube([support_width, (d+8*t)/2, sin(45)*4*t+support_height+5.5]);
                    }
                }
            }
        }

        // mount screw holes
        for (a=[0, 120]) {
            rotate([0, 0, a])
            for (b=[-12, 12]) {
                rotate([0, 0, b])
                translate([0, d/2, tube_height+support_height+5.5/2])
                rotate([90, 0, 0])
                    cylinder(d=3.3, h=10, $fn=16, center=true);
            }
        }

        translate([0, 0, -0.05])
            cylinder(d=10, h=t+0.1, $fn=20);
    }
}

module inner_tube() {
    t = wall_thickness;
    tt = 4.5 * nozzle_width;
    w = tube_od/2 - tube_id/2;
    h = tube_height;

    rotate_extrude($fn=tube_resolution) {
        translate([tube_id/2+w/2, 0, 0])
            polygon(points=[[w/2-h/4, tt],
                            [w/2-tt, h/4],
                            [w/2-tt, h-h/4],
                            [w/2-h/4, h-tt],
                            [-w/2+h, h-tt],
                            [-w/2+2*tt+h/6, tt+h/6],
                            [-w/2+2*tt+h/3, tt]]);
    }
    
    difference() {
        rotate_extrude($fn=tube_resolution) {
            translate([tube_id/2+w/2, 0, 0])
                polygon(points=[[-w/2+2*tt+h/6+0.1, tt+h/6+0.1],
                                [-w/2+2*tt+h/3+0.1, tt],
                                [-w/2+2*tt+h/3, tt],
                                [-w/2+2*tt+h/3+tt+0.1, -0.1],
                                [-w/2+tt-0.1, -0.1]]);
        }

        for(a=[0:12]) {
            rotate([0, 0, a*360/12])
            translate([-tt/2, 0, -0.1])
                cube([tt, tube_od, h/2]);
        }
    }

    // radial fan mount
    rotate([0, 0, 330]) {
        translate([layer_fan_offset+tt, -(layer_fan_width-1.25*tt)/2, tt+0.1])
            cube([layer_fan_depth-tt-0.5*t, layer_fan_width-1.25*tt, tube_height+layer_fan_mount_height]);

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

difference() {
    outer_tube();
    inner_tube();

    *rotate([0, 0, 340])
    translate([-(2*tube_od)/2, -(tube_od+10)/2, -1])
        cube([2*tube_od,(tube_od+10)/2, 100+2]); 
}
