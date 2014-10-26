//name == "M3" 		? [3, 5.5, 3, 5.5, 2.4, 7, 0.5] :	
module m3_nut(width=5.5, thickness=3) {
    cylinder(r=(width / sin(60) / 2), h=thickness, center=true, $fn=6);
}
