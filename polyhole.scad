// based on ployhole.scad by nophead
// http://hydraraptor.blogspot.com/2011/02/polyholes.html
// http://www.thingiverse.com/thing:6118

module polyhole(h, d) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n, center=true);
}

