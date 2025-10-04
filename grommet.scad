// bung.scad — sandwich bung with embossed diameter
// Inputs (override via -D on CLI)
diameter     = 44;   // mm  -> column (middle) diameter
col_h        = 2;    // mm  -> column height
disc_h_top   = 3;    // mm  -> top flange thickness
disc_h_bot   = 1.5;    // mm  -> bottom flange thickness
flange_add   = 6;    // mm  -> flanges are diameter + 6 (i.e., +3 mm radius)
disc_r       = 2;    // mm  -> top flange top-edge radius
recess_d     = diameter - 10;   // mm  -> recess diameter
recess_depth = 1.2;  // mm
recess_rim_r = 0.8;  // mm  -> concave rim inside recess
label        = str(diameter, "mm");   // e.g. "44", "27.5" (string)
label_h      = 0.1;  // mm  -> raised text height
label_size   = 0.15; // × recess_d (relative text size)
$fn = 128;

// quarter-arc helper
function arc_pts(cx, cy, rr, a1, a2, n=24) =
  [ for (i=[0:n]) let(a=a1 + (a2-a1)*i/n) [ cx + rr*cos(a), cy + rr*sin(a) ] ];

// rounded-top disc
module rounded_top_disc(D,H,R){
  Rmax = D/2;  rr = min(R, H/2, Rmax-0.01);
  outer = concat([[0,0],[Rmax,0],[Rmax,H-rr]],
                 arc_pts(Rmax-rr, H-rr, rr, 0, 90, 36),
                 [[0,H]]);
  rotate_extrude($fn=256) polygon(points=outer);
}

// recess cutter (concave lip + flat floor)
module recess_cutter(D,H,depth,rrim){
  R = D/2; d = min(depth, H-0.2); r = min(rrim, d, R-0.2);
  pts = concat([[0,H],[R,H]],
               arc_pts(R - r, H, r, 0, -90, 24),
               [[R - r, H - d], [0, H - d], [0,H]]);
  rotate_extrude($fn=256) polygon(points=pts);
}

// embossed text raised inside the recess
module recess_label(d, z_floor, h, rel){
  // center the text; size relative to recess diameter
  sz = d * rel;
  translate([0,0,z_floor])
    linear_extrude(height=h)
      text(label, size=sz, halign="center", valign="center",
           font="Liberation Sans:style=Bold");
}

// top flange with recess and optional label
module cap_with_recess(D,H,R){
  difference(){
    rounded_top_disc(D,H,R);
    recess_cutter(recess_d, H, recess_depth, recess_rim_r);
  }

  if (label != "") {
    sz = recess_d * label_size;
    // Raise text clearly above recess floor
    translate([0,0,H - recess_depth + 0.2])
      linear_extrude(height=label_h)
        text(label,
             size=sz,
             halign="center", valign="center",
             font="Liberation Sans:style=Bold");
  }
}


// ---- Assembly (single part) ----
col_d    = diameter;
flange_d = diameter + flange_add;

union(){
  // bottom flange
  cylinder(h=disc_h_bot, d=flange_d, center=false);

  // column
  translate([0,0,disc_h_bot])
    cylinder(h=col_h, d=col_d, center=false);

  // top flange (rounded, recessed, embossed)
  translate([0,0,disc_h_bot + col_h])
    cap_with_recess(flange_d, disc_h_top, disc_r);
}
