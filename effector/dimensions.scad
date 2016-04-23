nozzle_width = 0.4;
wall_thickness = 2 * nozzle_width;

play             = 0.3;
d_magnet         = 15 + play; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 4; // height of magnet
distance_magnets = 60;
a_magnet_mount   = -30;

tube_od = 85.9;
tube_id = 33; //inner ring diameter adjust for clearance around the hotend
tube_dia = (tube_od - tube_id) / 3;
tube_resolution = 256;
tube_height = 14.7+2; //11.5+2;
tube_opening_width = 3;

layer_fan_offset = 24; // offset of layer fan from center
layer_fan_width = 19.5 + play;
layer_fan_depth = 30;

layer_fan_mount_hole_x = 37.8;
layer_fan_mount_hole_y = 2.7;
layer_fan_mount_width = 13.5;
layer_fan_mount_diameter = 8;

/*
    Calculation of magnet position
*/
// tilted circle projects an ellipse
a = r_magnet; // intersection point of ellipse with x-axis
b = cos(a_magnet_mount) * r_magnet; // intersect point of ellipse with y-axis

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

c = (tan(30) * (distance_magnets + r_magnet));

magnet_x = cos(30) * c - x0;
magnet_y = sin(30) * c - yn;

magnet_h = -sin(a_magnet_mount) * (r_magnet+1.5);
///////////////////////////////////////////////////////////////////////////////
