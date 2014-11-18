// Compact direct drive bowden extruder for 1.75mm filament
// Licence: CC BY-SA 3.0, http://creativecommons.org/licenses/by-sa/3.0/
// Author: Dominik Scholz <schlotzz@schlotzz.com> and contributors
// Using MK8 style hobbed pulley 13x8mm from: https://www.reprapsource.com/en/show/6889
// visit: http://www.schlotzz.com
// changed: 2014-04-04, added idler slot and funnel on bowden side for easier filament insertion
// changed: 2014-04-27, placed base and idler "printer ready"
// changed: 2014-09-22, fixed non-manifold vertexes between base and filament tunnel
// changed: 2014-11-13, added bowden inlet


/*
	design goals:
	- using 13x8mm hobbed pulley
	- filament diameter parametric (1.75mm or 3mm)
	- using 608zz bearing
	- using M5 push fit connector
*/

// avoid openscad artefacts in preview
epsilon = 0.01;

// increase this if your slicer or printer make holes too tight
extra_radius = 0.1;

// major diameter of metric 3mm thread
m3_major = 2.85;
m3_radius = m3_major / 2 + extra_radius;
m3_wide_radius = m3_major / 2 + extra_radius + 0.2;

// diameter of metric 3mm hexnut screw head
m3_head_radius = 3 + extra_radius;

// drive gear
drive_gear_outer_radius = 8.00 / 2;
drive_gear_hobbed_radius = 6.35 / 2;
drive_gear_hobbed_offset = 3.2;
drive_gear_length = 13 + 0;
drive_gear_tooth_depth = .2;

// base width for frame plate
base_width = 15;
base_length = 60;
base_height = 5;

// nema 17 dimensions
nema17_width = 42.3;
nema17_hole_offsets = [
	[-15.5, -15.5, 1.5],
	[-15.5,  15.5, 1.5],
	[ 15.5, -15.5, 1.5],
	[ 15.5,  15.5, 1.5 + base_height]
];

// inlet type
inlet_type = 0; // 0:normal, 1:push-fit


//// filament
filament_diameter = 1.75; // 1.75, 3.00
filament_offset = [
	drive_gear_hobbed_radius + filament_diameter / 2 - drive_gear_tooth_depth,
	0,
	base_height + drive_gear_length - drive_gear_hobbed_offset - 2.5
];





// helper function to render a rounded slot
module rounded_slot(r = 1, h = 1, l = 0, center = false)
{
	hull()
	{
		translate([0, -l / 2, 0])
			cylinder(r = r, h = h, center = center);
		translate([0, l / 2, 0])
			cylinder(r = r, h = h, center = center);
	}
}



// mounting plate for nema 17
module nema17_mount()
{
	// settings
	width = nema17_width;
	height = base_height;
	edge_radius = 27;
	axle_radius = drive_gear_outer_radius + 1 + extra_radius;

	difference()
	{
		// base plate
		translate([0, 0, height / 2])
			intersection()
			{
				cube([width, width, height], center = true);
				cylinder(r = edge_radius, h = height + 2 * epsilon, $fn = 128, center = true);
			}
		
		// center hole
		translate([0, 0, -epsilon]	)
			cylinder(r = 11.25 + extra_radius, h = base_height + 2 * epsilon, $fn = 32);

		// axle hole
		translate([0, 0, -epsilon])
			cylinder(r = axle_radius, h = height + 2 * epsilon, $fn = 32);

		// mounting holes
		for (a = nema17_hole_offsets)
			translate(a)
			{
				cylinder(r = m3_radius, h = height * 4, center = true, $fn = 16);
				cylinder(r = m3_head_radius, h = height + epsilon, $fn = 16);
			}
	}
}


// plate for mounting extruder on frame
module frame_mount()
{
	// settings
	width = base_width;
	length = base_length;
	height = base_height;
	hole_offsets = [
		[0,  length / 2 - 6, 2.5],
		[0, -length / 2 + 6, 2.5]
	];
	corner_radius = 3;

	difference()
	{
		// base plate
		intersection()
		{
			union()
			{
				translate([0, 0, height / 2])
					cube([width, length, height], center = true);
				translate([base_width / 2 - base_height / 2 - corner_radius / 2, 0, height + corner_radius / 2])
					cube([base_height + corner_radius, nema17_width, corner_radius], center = true);
				translate([base_width / 2 - base_height / 2, 0, 6])
					cube([base_height, nema17_width, 12], center = true);
			}

			cylinder(r = base_length / 2, h = 100, $fn = 32);
		}

		// rounded corner
		translate([base_width / 2 - base_height - corner_radius, 0, height + corner_radius])
			rotate([90, 0, 0])
				cylinder(r = corner_radius, h = nema17_width + 2 * epsilon, center = true, $fn = 32);

		// mounting holes
		for (a = hole_offsets)
			translate(a)
			{
				cylinder(r = m3_wide_radius, h = height * 2 + 2 * epsilon, center = true, $fn = 16);
				cylinder(r = m3_head_radius, h = height + epsilon, $fn = 16);
			}

		// nema17 mounting holes
		translate([base_width / 2, 0, nema17_width / 2 + base_height])
			rotate([0, -90, 0])
			for (a = nema17_hole_offsets)
				translate(a)
				{
					cylinder(r = m3_radius, h = height * 4, center = true, $fn = 16);
					cylinder(r = m3_head_radius, h = height + epsilon, $fn = 16);
				}
	}
}


// inlet for filament
module filament_tunnel()
{

	width = 8;
	length = nema17_width;
	height = filament_offset[2] - base_height + 4;

	translate([0, 0, height / 2])
	{
		difference()
		{
			union()
			{
				// base
				translate([-height / 2, 0, 0])
					cube([width + height, length, height], center = true);

				// inlet strengthening
				translate([0, -length / 2, -height / 2 + filament_offset[2] - base_height])
					rotate([90, 0, 0])
						cylinder(r = 3.5, h = 1, center = true, $fn = 32);

				// outlet strengthening
				translate([0, length / 2, -height / 2 + filament_offset[2] - base_height])
					rotate([90, 0, 0])
						cylinder(r = 3.5, h = 1, center = true, $fn = 32);

				// idler tensioner
				intersection()
				{
					translate([5, -length / 2 + 8, 0])
						cube([width, 16, height], center = true);
					translate([-17.8, -20 ,0])
						cylinder(r = 27, h = height + 2 * epsilon, center = true, $fn = 32);
				}

			}

			// middle cutout for drive gear
			translate([-filament_offset[0], 0, 0])
				cylinder(r = 11.25 + extra_radius, h = height + 2 * epsilon, center = true, $fn = 32);

			// middle cutout for idler
			translate([11 + filament_diameter / 2, 0, 0])
				cylinder(r = 12.5, h = height + 2 * epsilon, center = true, $fn = 32);

			// idler mounting hexnut
			translate([filament_diameter + 1, -nema17_width / 2 + 4, .25])
				rotate([0, 90, 0])
					cylinder(r = m3_radius, h = 50, center = false, $fn = 32);
			translate([filament_diameter + 3, -nema17_width / 2 + 4, 5])
				cube([2.5 + 3 * extra_radius, 5.5 + 2.5 * extra_radius, 10], center = true);
			translate([filament_diameter + 3, -nema17_width / 2 + 4, 0])
				rotate([0, 90, 0])
					cylinder(r = 3.15 + 2.5 * extra_radius, h = 2.5 + 3 * extra_radius, center = true, $fn = 6);
			
			// rounded corner
			translate([-height - width / 2, 0, height / 2])
				rotate([90, 0, 0])
					cylinder(r = height, h = length + 2 * epsilon, center = true, $fn = 32);
			
			// funnnel inlet
			if (inlet_type == 0)
			{
				// normal type
				translate([0, -length / 2 + 1 - epsilon, -height / 2 + filament_offset[2] - base_height])
					rotate([90, 0, 0])
						cylinder(r1 = filament_diameter / 2, r2 = filament_diameter / 2 + 1 + epsilon / 1.554,
							h = 3 + epsilon, center = true, $fn = 16);
			}
			else
			{
				// inlet push fit connector m5 hole
				translate([0, -length / 2 - 1 + 2.5 + epsilon, -height / 2 + filament_offset[2] - base_height])
					rotate([90, 0, 0])
						cylinder(r = 2.25, h = 5 + 2 * epsilon, center = true, $fn = 16);

				// funnel inlet outside
				translate([0, -length / 2 + 4, -height / 2 + filament_offset[2] - base_height])
					rotate([90, 0, 0])
						cylinder(r1 = filament_diameter / 2, r2 = filament_diameter / 2 + 1,
							h = 2, center = true, $fn = 16);

			}

			// funnnel outlet inside
			translate([0, 12, -height / 2 + filament_offset[2] - base_height])
				rotate([90, 0, 0])
					cylinder(r1 = filament_diameter / 2, r2 = filament_diameter / 2 + 1.25,
						h = 8, center = true, $fn = 16);

			// outlet push fit connector m5 hole
			translate([0, length / 2 + 1 - 2.5 + epsilon, -height / 2 + filament_offset[2] - base_height])
				rotate([90, 0, 0])
					cylinder(r = 2.25, h = 5 + 2 * epsilon, center = true, $fn = 16);

			// funnel outlet outside
			translate([0, length / 2 - 4, -height / 2 + filament_offset[2] - base_height])
				rotate([90, 0, 0])
					cylinder(r1 = filament_diameter / 2 + 1, r2 = filament_diameter / 2,
						h = 2, center = true, $fn = 16);

			// filament path
			translate([0, 0, -height / 2 + filament_offset[2] - base_height])
				rotate([90, 0, 0])
					cylinder(r = filament_diameter / 2 + 2 * extra_radius,
						h = length + 2 * epsilon, center = true, $fn = 16);
			
		}
	}

}


// render drive gear
module drive_gear()
{
	r = drive_gear_outer_radius - drive_gear_hobbed_radius;
	rotate_extrude(convexity = 10)
	{
		difference()
		{
			square([drive_gear_outer_radius, drive_gear_length]);
			translate([drive_gear_hobbed_radius + r, drive_gear_length - drive_gear_hobbed_offset])
				circle(r = r, $fn = 16);
		}
	}
}


// render 608zz
module bearing_608zz()
{
	difference()
	{
		cylinder(r = 11, h = 7, center = true, $fn = 32);
		cylinder(r = 4, h = 7 + 2 * epsilon, center = true, $fn = 16);
	}
}


// render 624zz
module bearing_624zz()
{
	difference()
	{
		cylinder(r = 6.5, h = 5, center = true, $fn = 32);
		cylinder(r = 2, h = 5 + 2 * epsilon, center = true, $fn = 16);
	}
}


// idler with 608 bearing
module idler_608()
{
	width = nema17_width;
	height = filament_offset[2] - base_height + 4;
	edge_radius = 27;
	hole_offsets = [-width / 2 + 4, width / 2 - 4];
	bearing_bottom = filament_offset[2] / 2 - base_height / 2 - 6;

	// base plate
	translate([0, 0, height / 2])
	difference()
	{
		union()
		{
			// base
			intersection()
			{
				cube([width, width, height], center = true);
				cylinder(r = edge_radius, h = height + 2 * epsilon, $fn = 128, center = true);
				translate([17, 0, 0])
					cube([15, nema17_width + epsilon, height], center = true);
			}
			
			// spring base enforcement
			translate([17.15, -nema17_width / 2 + 4, .25])
				rotate([0, 90, 0])
					cylinder(r = 3.75, h = 4, $fn = 32);
		}

		translate([drive_gear_hobbed_radius + 11 - 0.25 + filament_diameter, 0, bearing_bottom])
		difference()
		{
			// bearing spare out
			cylinder(r = 11.5, h = 60, $fn = 32);

			// bearing mount
			cylinder(r = 4 - extra_radius, h = 7.5, $fn = 32);

			// bearing mount base
			cylinder(r = 4 - extra_radius + 1, h = 0.5, $fn = 32);
		}

		// bearing mount hole
		translate([drive_gear_hobbed_radius + 11 - 0.25 + filament_diameter, 0, 0])
			cylinder(r = 2.5, h = 50, center = true, $fn = 32);

		// tensioner bolt slot
		translate([17.15, -nema17_width / 2 + 4, .25])
			rotate([0, 90, 0])
				rounded_slot(r = m3_wide_radius, h = 50, l = 1.5, center = true, $fn = 32);

		translate([-12, -20 ,0])
			cylinder(r = 27, h = height + 2 * epsilon, center = true, $fn = 32);

		// mounting hole
		translate([15.5, 15.5, 0])
		{
			cylinder(r = m3_wide_radius, h = height * 4, center = true, $fn = 16);
			cylinder(r = m3_head_radius, h = height + epsilon, $fn = 16);
		}

	}

	translate([drive_gear_hobbed_radius + 11 - 0.25 + filament_diameter, 0, filament_offset[2] - base_height])
		%bearing_608zz();
}



module compact_extruder()
{
	// motor plate
	nema17_mount();

	// mounting plate
	translate([-nema17_width / 2 - base_height, 0, base_width / 2])
		rotate([0, 90, 0])
			frame_mount();

	// filament inlet/outlet
	translate([filament_offset[0], 0, base_height - epsilon])
		filament_tunnel();

	// drive gear
	color("grey")
		%translate([0, 0, base_height - 2.5])
			drive_gear();

	// filament
	color("red")
		%translate(filament_offset - [0, 0, epsilon])
			rotate([90, 0, 0])
				cylinder(r = filament_diameter / 2, h = 100, $fn = 16, center = true);


}

compact_extruder();
translate([20, 0, 0])
	idler_608();
