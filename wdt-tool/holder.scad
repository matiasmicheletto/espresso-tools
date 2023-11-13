$fn = 100;

Lt = 60; // Top section length
Lb = 60; // Bottom section length

Ht = 40; // Top section height
Hc = 8; // Center section height
Hb = 16; // Bottom section heigth
Hf = 29; // Foot height (square section)

Wt = 40; // Top width
Wc = 30; // Center width
Wb = 50; // Bottom width

// Top hole
Rt = 14; // Cylinder radius
Lr = 65; // Cylinder length
a = asin(1.5*Rt/Lr); // Cylinder inclination
Rs = Rt*1.6; // Sphere radius

// Foot
ef = 10; // Foot height
Rf = 26.5; // Foot radius
df = 2; // Foot border


module top_envelope() {
    points = [
        // Bottom face
        [-Wc/2,-Lt/2,0], 
        [-Wc/2,-Lt/2,Hc],
        [Wc/2,-Lt/2,Hc],
        [Wc/2,-Lt/2,0],
        // Top face
        [-Wt/2,Lt/2,0],
        [Wt/2,Lt/2,0],
        [Wt/2,Lt/2,Ht],
        [-Wt/2,Lt/2,Ht]
    ];
    faces = [
        [0,1,2,3],
        [0,4,7,1],
        [0,3,5,4],
        [3,2,6,5],
        [4,5,6,7],
        [1,7,6,2]
    ];
    polyhedron(points=points, faces=faces);
}

module top_section() {
    difference() {
        top_envelope();
        
        translate([0,0,Ht*0.65])
        rotate([a-90,0,0])
            cylinder(r = Rt, h = Lt*1.3, center = true);

        translate([0,0,Ht*0.8])
        rotate([a-90,0,0])
            cube([2*Rt, Rt, Lt*1.3], center = true);
        
        translate([0, Lt/2+15, Ht*0.65 + Rt/2])
            sphere(r = Rs);
    }
}

module bottom_envelope() {
    points = [
        [-Wc/2,-Lb/2,0], 
        [-Wc/2,-Lb/2,Hc],
        [Wc/2,-Lb/2,Hc],
        [Wc/2,-Lb/2,0],
        [-Wb/2,Lb/2,0],
        [Wb/2,Lb/2,0],
        [Wb/2,Lb/2,Hb],
        [-Wb/2,Lb/2,Hb]
    ];
    faces = [
        [0,1,2,3],
        [0,4,7,1],
        [0,3,5,4],
        [3,2,6,5],
        [4,5,6,7],
        [1,7,6,2]
    ];
    polyhedron(points=points, faces=faces);
}

module bottom_section() {    
    difference() {
        union() {
            bottom_envelope();
            
            // Foot
            translate([0,Lb/2+ef/2,Hf/2])
                cube([Wb, ef, Hf], center = true);
            translate([0,(Lb+ef)/2,Hf])
            rotate([90, 0, 0])
                cylinder(r = Rf, h = ef, center = true);
        }
        
        // Hollow
        translate([0, ef/4, Hf])
            rotate([90, 0, 0])
            cylinder(r = Rf-df, h = Lb+ef/2, center = true);
        
        // Adaption top to bottom
        hh = 30; dd = 1;
        translate([0, hh/2-Lb/2-3.5, Hf/2+2])
            rotate([95, 0, 0])
            cylinder(r1 = Rt-dd, r2 = Rt+0.5, h = hh, center = true);
    }
}


module holder() {
    union() {
        translate([0,0,Lt/2])
        rotate([90,0,0])
            top_section();
        translate([0,0,-Lb/2])
        rotate([90,180,0])
            bottom_section();
    }
}

/*
module presentation() {
    translate([60, 0, 0]) {
        top_section();
        translate([60,0,0])
            bottom_section();
    }
}
presentation();
*/

holder();