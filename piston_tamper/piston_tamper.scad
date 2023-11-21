$fn = 200;

delta = 0.5; // Printer inaccuracy

wb = 3; // Bottom wall width
wt = 3; // Top wall width

// Bottom cylinder
Rb = 72.5/2-delta; // Should equal piston inner radius minus a delta (0.5)
Hb = 17+delta; // Should be equal to piston bottom part height 

// Top cylinder
Rt = 77/2; // Should be the same radius of the piston
Ht = 40; // Should be greater that portafilter height

// Puck Handle
Rp = 19/2; // Puck handle radius + delta
zp = Hb+Ht-20; // Puck handle height position
Hp = wt+2; // Top wall + delta

// Ears
We = 58.5; // Ear width
Hce = 8; // Cuboid section height
Hcc = 8; // Cylindrical section height
Rce = We*We/8/Hcc+Hcc/2; // Cylindrical section radius
de = 1.5; // Piston inner border

echo("Border size", Rt-Rb);
echo("Puck hole diameter", (Rt-wt)*2);
echo("Ear cylindrical section radius", Rce);

module ears() {
    difference() {
        intersection() {
            union() {
                // Cuboid section
                translate([-Rt, -We/2, Hcc+de])
                    cube([2*Rt, We, Hce]);
                
                // Cylindrical section
                translate([0,0,de+Rce])
                rotate([0, 90, 0])
                    difference() { // Cylindrical cap
                        cylinder(r = Rce, h = 2*Rt, center = true);
                        translate([-Hcc/2, 0, 0])
                            cube([2*Rce-Hcc, 2*Rce, 2*Rt], center = true);
                    }
            }        
            translate([0, 0, de])
                cylinder(r = Rt, h = Hcc+Hce);    
        }
        
        // Hole
        translate([0,0,de]) cylinder(r = Rt-wt,h = Hcc+Hce);
    }
}

module tamper() {
	difference() {
		// Top + bottom
		union() { 
			cylinder(r = Rb, h = Hb);
			translate([0,0,Hb]) cylinder(r = Rt, h = Ht);
			ears();
		}	

        // Top inner Hole
        translate([0,0,Hb+wt]) cylinder(r = Rt-wt,h = Ht);
        // Bottom inner Hole
		translate([0,0,-.05]) cylinder(r = Rb-wb,h = Hb+wt+0.1);

		// Puck Handle
		translate([Rt-(wt/2)-1,0,zp]) 
		rotate([0,90,0])
            cylinder(r = Rp, h = Hp, center = true);
        translate([Rt-wt-2, -Rp, zp])
            cube([wt+2, 2*Rp, 21]);
	}	
}

tamper();