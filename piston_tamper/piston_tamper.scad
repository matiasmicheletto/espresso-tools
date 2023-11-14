$fn = 200;

d = 2; // Cylinders diff should be greater than piston inner ring
wb = 5; // Bottom wall width
wt = wb+d; // Top wall width

// Bottom cylinder
Ri = 77/2; // Should equal piston inner radius - delta
Hi = 20; // Should be equal to piston bottom part height 

// Top cylinder
Ro = Ri+d; // Should be the same radius of the piston
Ho = 12; // Should be greater than puck handle radius

// Inner hole
Rh = Ri+d-wt; // Should equal puck radius + delta
Hh = Hi+Ho+1; // Should be greater than the sum of both bottom and top heights

// Puck holder
Rp = 11; // Puck handle radius + delta
Hp = wt+2; // Top wall + delta


module tamper() {
	difference() {
		// Top + bottom
		union() { 
			cylinder(r = Ri, h = Hi);
			translate([0,0,Hi]) cylinder(r = Ro, h = Ho);
			// TODO: add ears
		}	

		// Inner hole
		translate([0,0,-.5]) cylinder(r = Rh,h = Hh);

		// Puck holder
		translate([Ro-(wt/2)-1,0,Hi+Ho]) 
		rotate([0,90,0])
			cylinder(r = Rp, h = Hp, center = true);
	}	
}

tamper();