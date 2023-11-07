
$fn = 100;

H1 = 15; // Top cylinder height
R1 = 67/2; // Top cylinder radius
H2 = 12; // Bottom cylinder height
R2 = 58/2; // Bottom cylinder radius
W = 33; // Hollowing width (for Oster Perfect Brew grinder)
t = 2; // Walls width
h = 4; // Height of funnel section

a = asin(W/(2*(R1-t))); // Temp variable to compute hollowing depth
x = (R1-t)*(1-cos(a)) + t; // Depth of hollowing

module envelope() {
	union(){
		translate([0,0,H2])
			cylinder(h = H1, r = R1);
		cylinder(h = H2, r = R2);
	}	
}

module inner() {
	union(){
		translate([0,0,H2+h])
			cylinder(h = H1, r = R1-t);
		
		translate([0, 0, H2])
			cylinder(h = h, r1 = R2-t, r2 = R1-t);

		cylinder(h = H2, r = R2-t);	
	}		
}

module hollowing() {
	translate([R1-x,-W/2,H2+h])
		cube([x,W,H1-h]);
}

module dosing_funnel() {
    difference(){
        envelope();
        inner();
        hollowing();	
    }
}

dosing_funnel();
