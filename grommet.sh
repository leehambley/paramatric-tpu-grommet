#!/usr/bin/env bash
set -euo pipefail

OUTDIR="."
mkdir -p "$OUTDIR"

# diameter x count
items=(
  "44x2"
  "42x2"
  "27.5x3"
  "24x8"
  "20x4"
  "40x2"
)

i=1
for it in "${items[@]}"; do
  d="${it%x*}"    # diameter
  n="${it#*x}"    # count
  for ((k=1; k<=n; k++)); do
    idx=$(printf "%03d" "$i")
    fname="${OUTDIR}/${idx}_${d}.stl"
    echo "-> $fname"
    /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD \
      -o "$fname" \
      -D diameter="$d" \
      -D label="\"$d\"" \
      grommet.scad
    ((i++))
  done
done