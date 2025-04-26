include <lib/mmcb.scad>

$fn = 100;

mmcb_top();

% up(MMCB_BODY_SIZE.z + 0.3) pos_knob() mmcb_knob();

% up(10) pos_keys() rect(18);