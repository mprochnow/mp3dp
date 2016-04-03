use <m3.scad>

wall_thickness = 1.2; //ring wall thickness
tube_opening_width = 3;// Air vent on the bottom facing your parts
tube_id = 36; //inner ring diameter adjust for clearance around the hotend
tube_od = 71; 
tube_dia = (tube_od - tube_id) / 3;
tube_resolution = 64;

module duct_outline(diameter = 10) {
    hull() {
        polygon(
            points=[[0,0], [0,diameter / 2],[diameter / 2,0]], paths=[[0,1,2]]);
        
        translate([-diameter / 2, diameter / 2, 0])
        difference() {
            circle(d=diameter); 
            translate([-diameter/3, -diameter/3])
                square([diameter/2, diameter/2], center=true);
        }
    }   
}

module outer_tube() {
    rotate_extrude($fn=tube_resolution) {
        translate([tube_dia / 2 + tube_id / 2,0,0])
        rotate([180,0,180])
            duct_outline(tube_dia);
    }
    
    cylinder(d=tube_od-10, h=wall_thickness/2+0.1, $fn=tube_resolution);
}

module inner_tube() {
    translate([0, 0, wall_thickness]) 
    rotate_extrude($fn=tube_resolution){
        translate([tube_dia / 2 + tube_id / 2 + wall_thickness,0,0])
        rotate([180,0,180])
            duct_outline(tube_dia - (wall_thickness * 2)); 
     
    }   
}

module slit() {
    rotate_extrude($fn=tube_resolution){
        translate([tube_id / 2 + wall_thickness- 0.1, 0, 0])
        rotate([60.434,60.434, 0])
            square([tube_opening_width, wall_thickness * 3]);            
    }
}    

module cable_cut_out() {
    rotate([0, 0, 150])
    translate([tube_od/2, 0, wall_thickness+7])
        cube([tube_od, 15, 15], center=true);
}

module tube_end_caps() {
    intersection() {
        difference() {
            outer_tube();
            cable_cut_out();
            cylinder(d=10, h=2*wall_thickness, $fn=20, center=true);
        }
    
        rotate([0, 0, 150])
        translate([tube_od/2, 0, 7])
            cube([tube_od, 15+2*wall_thickness, 15], center=true);
    }
}

module holder(height=33) {
    for (a=[210, 330]) {
        rotate([0, 0, a])
        difference() {
            for (y=[3.4, -3.4]) {
                translate([15 + 12, y, 0])
                translate([-3.7, -1.8, 1])
                    cube([7.4, 3.6, height]);
            }
            
            outer_tube();
            
            translate([15 + 12, 0, 29.5])
            rotate([90, 0, 0])
            union() {
                cylinder(d=3.3, h=20, $fn=20, center=true);

                translate([0, 0, (a==210) ? -5 : 5])
                    cylinder(d=5.8, h=3, center=true, $fn=20);

                translate([0, 0, (a==210) ? 5 : -5])
                rotate([0, 0, 30])
                    m3_nut(width=5.8);
            }
        }
    }
}

module fan_mount() {
    w = 19.6 + 2 * wall_thickness;
    d = 31 + 2 * wall_thickness;
    h = 18 + tube_dia;
    t = wall_thickness;
    
    rotate([0, 0, 330])
    difference() {
        translate([(tube_id)/2+tube_dia+0.9, 0, 0])
        union() {
            translate([0, -w/2, tube_dia/2])
                cube([d, w, h-tube_dia/2]);
            
            translate([-tube_dia/2, -w/2, 0])
                cube([d, w, tube_dia/2]);

            translate([d-tube_dia/2, 0, tube_dia/2])
            rotate([0, 45, 0])
            rotate([0, 0, 90])
                cube([w, cos(45)*tube_dia, cos(45)*tube_dia], center=true);
        }
    }
}

module fan_mount_cutout() {
    w = 19.6 + 2 * wall_thickness;
    d = 31 + 2 * wall_thickness;
    h = 18 + tube_dia;
    t = wall_thickness;
    
    rotate([0, 0, 330])
    translate([(tube_id)/2+tube_dia+0.9, 0, 0])
    union() {
        translate([t, -(w-4*t)/2, tube_dia/2-t])
            cube([d-3*t, w-4*t, h-tube_dia/2]);

        translate([-tube_dia/2-0.1, -(w-4*t)/2, t])
            cube([d+tube_dia/2-5*t+0.3, w-4*t, tube_dia/2+t]);

        translate([d-tube_dia/2, 0, tube_dia/2-t])
        rotate([0, 45, 0])
        rotate([0, 0, 90])
            cube([w-4*t, cos(45)*(tube_dia-4*t), cos(45)*(tube_dia-4*t)], center=true);

        translate([d/2, 0, h/2+t+10])
            cube([d-2*t, w-2*t, h], center=true);
        
        translate([t, 0, h])
        rotate([0, 28, 0])
        translate([(d+10.11)/2-2, 0, h/2-0.5])
            cube([(d+8), w+1, h], center=true);
        
        translate([0, 0, t+10+5.3])
        translate([0, 0, 7.5/2])
            cube([10, 2.6, 7.5], center=true);
    }
}

module layer_fan() {
    union() {
        difference() {
            union() {
                outer_tube();
                holder();
                fan_mount();
            }
            inner_tube();
            slit();
            cable_cut_out();
            fan_mount_cutout();
            cylinder(d=10, h=2*wall_thickness, $fn=20, center=true);
        }
        tube_end_caps();
    }
}

layer_fan();
