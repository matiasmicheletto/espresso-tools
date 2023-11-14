/*
 * Dan Kirshner - dan_kirshner@yahoo.com
 *
 * You are welcome to make free use of this software.  Retention of my 
 * authorship credit would be appreciated.
*/

// Examples:
// metric_thread(8, 1, 10);

// Rohloff hub thread:
// metric_thread(34, 1, 10, internal=true, n_starts=6);
// metric_thread(8, 2, 4);

pi = 3.14159265;

function segments(diameter) = min(50, ceil(diameter*6));

module metric_thread(diameter = 8, pitch = 1, length = 1, internal = false, n_starts = 1) {
   n_turns = floor(length/pitch);
   n_segments = segments(diameter);
   h = pitch * cos(30);

   union() {
      intersection() {
         for (i=[-1*n_starts : n_turns+1]) {
            translate([0, 0, i*pitch])
               metric_thread_turn(diameter, pitch, internal, n_starts);
         }
         translate([0, 0, length/2])
            cube([diameter*1.1, diameter*1.1, length], center=true);
      }

      if (internal) {
         cylinder(r=diameter/2 - h*5/8, h=length, $fn=n_segments);
      } else {
         cylinder(r=diameter/2 - h*5.3/8, h=length, $fn=n_segments);
      }
   }
}

module metric_thread_turn(diameter, pitch, internal, n_starts) {
    n_segments = segments(diameter);
    fraction_circle = 1.0/n_segments;
    for (i=[0 : n_segments-1]) {
        rotate([0, 0, i*360*fraction_circle])
        translate([0, 0, i*n_starts*pitch*fraction_circle])
            thread_polyhedron(diameter/2, pitch, internal, n_starts);
   }
}


function z_fct(current_radius, radius, pitch) = 
    0.5*(current_radius - (radius - 0.875*pitch*cos(30)))/cos(30);

module thread_polyhedron(radius, pitch, internal, n_starts) {
   n_segments = segments(radius*2);
   fraction_circle = 1.0/n_segments;

   h = pitch * cos(30);
   outer_r = radius + (internal ? h/20 : 0);
   inner_r = radius - 0.875*h;

   x_incr_outer = outer_r * fraction_circle * 2 * pi * 1.005;
   x_incr_inner = inner_r * fraction_circle * 2 * pi * 1.005;
   z_incr = n_starts * pitch * fraction_circle * 1.005;
   x1_outer = outer_r * fraction_circle * 2 * pi;
   z0_outer = z_fct(outer_r, radius, pitch);
   z1_outer = z0_outer + z_incr;

   polyhedron(
      points = [
            [-x_incr_inner/2, -inner_r, 0],                                    // [0]
            [x_incr_inner/2, -inner_r, z_incr],                                // [1]
            [x_incr_inner/2, -inner_r, pitch + z_incr],                        // [2]
            [-x_incr_inner/2, -inner_r, pitch],                                // [3]

            [-x_incr_outer/2, -outer_r, z0_outer],                             // [4]
            [x_incr_outer/2, -outer_r, z0_outer + z_incr],                     // [5]
            [x_incr_outer/2, -outer_r, pitch - z0_outer + z_incr],             // [6]
            [-x_incr_outer/2, -outer_r, pitch - z0_outer]                      // [7]
      ],

      faces = [
            [0, 3, 4],  // This-side trapezoid, bottom
            [3, 7, 4],  // This-side trapezoid, top

            [1, 5, 2],  // Back-side trapezoid, bottom
            [2, 5, 6],  // Back-side trapezoid, top

            [0, 1, 2],  // Inner rectangle, bottom
            [0, 2, 3],  // Inner rectangle, top

            [4, 6, 5],  // Outer rectangle, bottom
            [4, 7, 6],  // Outer rectangle, top

            [7, 2, 6],  // Upper rectangle, bottom
            [7, 3, 2],  // Upper rectangle, top

            [0, 5, 1],  // Lower rectangle, bottom
            [0, 4, 5]   // Lower rectangle, top
        ]
   );
}