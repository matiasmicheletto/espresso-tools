use <lib/threads.scad>
$fn = 100;

// Top part (handle)
Ht = 50; // Envelope height
Dt = 27; // Envelope diameter
Dn = 20; // Narrowing diameter
// Middle narrowing is acchieved with a torus
t1 = 2*atan((Dt-Dn)/Ht); // Temp variable to compute torus radii
Rt = Ht/2/sin(t1); // Torus radii
// Top rounding is a cropped sphere
Hr = 4; // Top rounding height
t2 = 2*atan(2*Hr/Dt); // Temp variable to compute top radius
Rr = Dt/2/sin(t2); // Top radius

// Bottom part (comb)
Hb = 8; // Base height
Db = Dt; // Base diameter
// Screw thread geometry
Hs = 4.5; // Screw thread height
Ds = 19; // Screw thread diameter
// Holes geometry
Nh = 6; // Number of holes (plus the middle one)
Dh = 1; // Needle hole diameter
a = atan(Ds/4/(Hb+Hs)); // Needle hole inclination
L = sqrt(Ds*Ds/16 + (Hb+Hs)^2); // Inclined holes length (distance from top to bottom)
e = Dh/2*tan(a); // Needle hole extension (due to inclination)
d = Dh/2*sin(a); // Needle hole vertical displacement (align due to inclination)

module handle() {
    union(){
        // Handle
        translate([0, 0, 1.5*Hs])
        difference() {
            // Envelope
            cylinder(h = Ht, r = Dt/2); 
            
            // Torus
            translate([0, 0, Ht/2]){ 
                rotate_extrude(convexity = 10)
                translate([Dn/2+Rt, 0, 0])
                    circle(r = Rt);
            }
        }
        
        // Thread section
        difference() {
            cylinder(h = 1.5*Hs, r = Dt/2); 
            metric_thread(Ds, 3, Hs, true, 1);
        }
        
        // Rounded borders on top
        translate([0, 0, Ht-Rr+Hr+1.5*Hs])
        difference() {
            sphere(Rr);
            translate([0, 0, -Hr])
                cube(2*Rr, center = true);
            translate([0, 0, 2*Rr-2.5])
                cube(2*Rr, center = true);
        }
    }
}


module comb() {
    difference() {
        // Envelope with thread
        union() {
            cylinder(h = Hb, r = Db/2);
            translate([0, 0, Hb])
                metric_thread(Ds, 3, Hs, false, 1);
        }
        
        // Center hole
        cylinder(h = Hb+Hs, r = Dh/2); 
        
        // Other holes
        for (t = [0:360/Nh:360]) { // For each hole
        rotate([0, 0, t])
            translate([Ds/2, 0, -d])
            rotate([0, -a, 0])
                cylinder(h = L + 2*e, r = Dh/2);        
        }
    }
}


module wdt() { 
    translate([0, 0, Hb+Hs+10]) handle();
    comb();
}

wdt();