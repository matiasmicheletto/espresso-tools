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
Rt = Wc/2; // Cylinder radius
a = 102; // Cylinder inclination
Rs = Rt*1.5; // Sphere radius

// Bottom hole
Rb = Rt*1.2;
e = W/2-Rb; 
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

module bottom_section() {    
    difference() {
        bottom_envelope();
        
        translate([0,0,Rb+2])
        rotate([90,0,0])
            cylinder(r = Rb, h = Lb, center = true);
    }
}

module foot() {
    difference() {
        union() {
            cylinder(r = W*0.55, h = Hf);
            translate([0,W/4+10,Hf/2])
                cube([W, W*0.8, Hf], center = true);
        }
        
        translate([0,Rb/2-e/2,(Hf+e)/2])
            cylinder(r = Rb, h = Hf-e+1, center = true);
        
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
        
        translate([0,-W*0.8-2.5,-Lb-Hf])
            foot();
    }
}

holder();



