$fn = 100;

// Top envelope dimensions
Lt = 100; // Top section length
Ht = 50; // Top section height
W = 50; // Top and bottom width

Hc = 10; // Center section height

d = 10; // Top displacement
Lb = 95; // Bottom section length
Hb = 20; // Bottom section heigth
Wc = 30; // Center width

// Top hole
a = 100; // Cylinder inclination
Rt = Wc/2-2; // Cylinder radius
Rs = Rt*1.5; // Sphere radius

// Foot
Hf = 10; // Foot height


module top_envelope() {
    points = [
        // Bottom face
        [-Wc/2,-Lt/2,0], 
        [-Wc/2,-Lt/2,Hc],
        [Wc/2,-Lt/2,Hc],
        [Wc/2,-Lt/2,0],
        // Top face
        [-W/2,Lt/2,0],
        [W/2,Lt/2,0],
        [W/2,Lt/2,Ht],
        [-W/2,Lt/2,Ht]
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
        
        translate([0,0,.55*Ht])
        rotate([a,0,0])
            cylinder(r = Rt, h = Lt*1.1, center = true);
        
        translate([0,0,.55*Ht+Rt/2])
        rotate([a,0,0])
            cube([2*Rt, Rt, Lt*1.1], center = true);
        
        translate([0, Lt/2+15, .55*Ht + Rt/2])
            sphere(r = Rs);
    }
}

module bottom_envelope() {
    points = [
        [-Wc/2,-Lb/2,0], 
        [-Wc/2,-Lb/2,Hc],
        [Wc/2,-Lb/2,Hc],
        [Wc/2,-Lb/2,0],
        [-W/2,Lb/2,0],
        [W/2,Lb/2,0],
        [W/2,Lb/2,Hb],
        [-W/2,Lb/2,Hb]
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
            
            hh = W*0.3;
            translate([0,Lb/2+Hf/2,hh])
                cube([W, Hf, 2*hh], center = true);
            
            translate([0,Lb/2+Hf/2,W*0.65])
            rotate([90, 0, 0])
                cylinder(r = W/2*1.1, h = Hf, center = true);
        }
        translate([0,0, W*0.65])
            rotate([90,Hf/2,0])
            cylinder(r = W/2, h = Lb + Hf/2, center=true);
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

holder();
