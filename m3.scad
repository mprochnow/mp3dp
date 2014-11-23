module m3_nut(width=5.5, thickness=3.3) {
    cylinder(r=(width / sin(60) / 2), h=thickness, center=true, $fn=6);
}
