# paramatric-tpu-grommet

Uses OpenSCAD to render.

To make one, open the `grommet.scad` and tweak the variables, then render and export.

```
# ... snip ...
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

```

To make many, run `bash ./grommet.sh` after adjusting the paramters in the bash script for diameter/count.

```
# ... snip ...

# diameter x count
items=(
  "44x2"
  "42x2"
  "27.5x3"
  "24x8"
  "20x4"
  "40x2"
)
```