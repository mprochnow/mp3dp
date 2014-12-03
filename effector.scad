tolerance        = 0.3;
d_magnet         = 15 + tolerance; // outer diameter of magnet
r_magnet         = d_magnet / 2;
h_magnet         = 6; // height of magnet
distance_magnets = 60;
angle_magnet_mounts = -45;

module magnet_holder_slice() {
    x = cos(30) * (tan(30) * (distance_magnets + r_magnet)) - sin(30) * r_magnet;
    y = sin(30) * (tan(30) * (distance_magnets + r_magnet)) + cos(30) * r_magnet;

    translate([x, y, 0])
    rotate([angle_magnet_mounts, 0, 0])
        cylinder(r=r_magnet, h=h_magnet, $fn=80);

    translate([-x, y, 0])
    rotate([angle_magnet_mounts, 0, 0])
        cylinder(r=r_magnet, h=h_magnet, $fn=80);
}

rotate([0, 0, 0])
    magnet_holder_slice();

rotate([0, 0, 120])
    magnet_holder_slice();

rotate([0, 0, -120])
    magnet_holder_slice();

