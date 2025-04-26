include <BOSL2/std.scad>

MMCB_BODY_SIZE = [ 100, 22, 9 ];

MMCB_BODY_TOP_Z = 4;
MMCB_BODY_BOTTOM_Z = MMCB_BODY_SIZE.z - MMCB_BODY_TOP_Z;

MMCB_KNOB_D = MMCB_BODY_SIZE.y;
MMCB_KNOB_Z = 8;

MMCB_KEY_TO_KEY = 18.5;

MAGNET_S_SIZE_D = 6;
MAGNET_S_SIZE_Z = 3;

module key() {
  rect(size = 15, anchor = CENTER);
}

module pos_keys(only_left_most = false) {
  to_i = only_left_most ? 0 : 3;

  for (i = [0:to_i]) {
    translate([ 15 / 2 + MMCB_KEY_TO_KEY * i - MMCB_BODY_SIZE.x / 2 + 4, 0, 0 ])
        children();
  };
}

SUPER_MINI_SIZE = [ 22.7, 18.3, 1.2 ];

module esp32c3_super_mini() {
  cube(SUPER_MINI_SIZE, anchor = RIGHT);
}

module mmcb_body_base(wall_type = "diamonds_2x3") {
  tex = texture("diamonds");
  if (wall_type == "diamonds_2x3") {
    linear_sweep(region = rect(size = [ MMCB_BODY_SIZE.x, MMCB_BODY_SIZE.y ],
                               rounding = 4, anchor = CENTER),
                 texture = tex, h = MMCB_BODY_SIZE.z, center = false,
                 tex_inset = true, tex_depth = 0.4, tex_size = [ 2, 3 ],
                 style = "alt");
  } else if (wall_type == "diamonds_1x3") {
    linear_sweep(region = rect(size = [ MMCB_BODY_SIZE.x, MMCB_BODY_SIZE.y ],
                               rounding = 4, anchor = CENTER),
                 texture = tex, h = MMCB_BODY_SIZE.z, center = false,
                 tex_inset = true, tex_depth = 0.4, tex_size = [ 1, 3 ],
                 style = "alt");
  } else {
    linear_extrude(height = MMCB_BODY_SIZE.z, center = false, convexity = 10,
                   twist = 0, slices = 20, scale = 1.0)
        rect(size = [ MMCB_BODY_SIZE.x, MMCB_BODY_SIZE.y ], rounding = 4);
  }
}

module pos_knob() {
  right(-MMCB_BODY_SIZE.x / 2 + MMCB_KEY_TO_KEY * 4 + MMCB_KNOB_D / 2 + 4)
      children();
}

module mmcb_knob() {
  tex = texture("diamonds");
  difference() {
    linear_sweep(region = circle(d = MMCB_KNOB_D), texture = tex,
                 h = MMCB_KNOB_Z, center = false, tex_inset = true,
                 tex_depth = 0.7, tex_size = [ 1, 3 ], style = "alt");

    cylinder(h = MMCB_KNOB_Z - 1, d = 1.9, center = false);
    cylinder(h = 1, d1 = 2.4, d2 = 1.9, center = false);
  };
}

module pos_screw_holes() {
  left(MMCB_BODY_SIZE.x / 2 - 2.6) children();

  yflip_copy() pos_keys(only_left_most = true) right(MMCB_KEY_TO_KEY * 2.5)
      back(MMCB_BODY_SIZE.y / 2 - 3) children();

  yflip_copy() right(MMCB_BODY_SIZE.x / 2 - 3) back(MMCB_BODY_SIZE.y / 2 - 3)
      children();
}

module mmcb_top(wall_type = "diamonds_1x3") {
  difference() {
    mmcb_body_base(wall_type = wall_type);

    // space for keys
    up(MMCB_BODY_SIZE.z + 0.01) pos_keys() {
      cube([ 14.4 + 0.2, 14 + 0.2, 3 ], anchor = CENTER + TOP) {
        align(BOT) cylinder(h = 4, d = 4.2 + 0.3);
        fwd(6.5) align(BOT) cylinder(h = 4, d = 3);
        fwd(3.5) right(3.5) align(BOT) cylinder(h = 4, d = 3);
      };
    }

    // space for knob
    *up(MMCB_BODY_SIZE.z + 1) pos_knob()
        cylinder(h = MMCB_BODY_TOP_Z, d = MMCB_KNOB_D + 1, anchor = TOP) {
      align(BOT) cylinder(h = 4, d = 4);
    };

    // space for rotary encoder
    up(MMCB_BODY_SIZE.z + 0.01) pos_knob() {
      left(1) cube(size = [ 12, 9.5 + 0.2, 3.3 ], anchor = CENTER + TOP);
      // hole for legs
      left(9.5 / 2) hull() yflip_copy(offset = 3)
          cylinder(h = MMCB_BODY_TOP_Z + 1, d = 2, anchor = TOP);

      // center hole
      cylinder(h = MMCB_BODY_TOP_Z + 1, d = 4.5, anchor = TOP);
    };

    // screw holes
    pos_screw_holes() {
      cylinder(d = 2.0, h = MMCB_BODY_SIZE.z + 0.1, anchor = BOT) {
        down(0.6) align(TOP) cylinder(d = 3.5, h = 1, anchor = TOP);
      };
    };

    // space for bottom part
    up(MMCB_BODY_SIZE.z - MMCB_BODY_TOP_Z)
        cube([for (v = MMCB_BODY_SIZE) v + 1], anchor = CENTER + TOP);
  };
}

module mmcb_bottom(wall_type = "diamonds_2x3") {
  difference() {
    mmcb_body_base(wall_type = wall_type);

    // space for keys
    up(1) hull() {
      pos_keys() {
        cube([ 13 + 0.2, 14 + 0.2, MMCB_BODY_BOTTOM_Z ], anchor = CENTER + BOT);
      };
    };

    // space for esp32c3 super mini
    up(MMCB_BODY_BOTTOM_Z + 0.01) right(MMCB_BODY_SIZE.x / 2 - 2)
        diff(remove = "del") {
      cube([ SUPER_MINI_SIZE.x + 0.4, SUPER_MINI_SIZE.y + 0.4, 4.1 ],
           anchor = RIGHT + TOP) {
        // space for screw holes
        yflip_copy() align(RIGHT + BACK + TOP, inside = false) tag("del")
            hull() {
          right(-3.3) back(-3.3) cylinder(h = 0.01, d = 20, center = false);

          down(3) cylinder(h = 0.01, d = 0.01, center = false);
        };

        // cable hole
        align(LEFT + CENTER) cube([ 2, 6, 4.1 ], anchor = RIGHT + TOP);

        type_c_offset_size = 0.3;
        type_c_offset_length = 0;
        // type c port
        left(1) up(1 + 3.2) align(RIGHT + BOT) diff() {
          cube(
              [
                7.2 + type_c_offset_length,
                8.9 + type_c_offset_size,
                3.2 + type_c_offset_size,
              ],
              anchor = CENTER + BOT) {
            tag("remove") edge_mask([ BACK, FRONT ], except = [ RIGHT, LEFT ])
                rounding_edge_mask(l = 10 + type_c_offset_length, r = 1.5);
          };
        };
      };
    };

    // holes for bottom magnets
    left(10) xflip_copy(offset = 20) cylinder(
        d = MAGNET_S_SIZE_D + 0.4, h = MAGNET_S_SIZE_Z + 0.2, anchor = BOT);

    // screw holes
    up(1) pos_screw_holes() {
      cylinder(d = 2, h = MMCB_BODY_SIZE.z, anchor = BOT);
    };

    // space for top part
    up(MMCB_BODY_BOTTOM_Z)
        cube([for (v = MMCB_BODY_SIZE) v + 1], anchor = CENTER + BOT);
  };

  // holes for bottom magnets
  left(10) xflip_copy(offset = 20) difference() {
    cylinder(d = MAGNET_S_SIZE_D + 0.4 + 3, h = 2, anchor = BOT);
    cylinder(d = MAGNET_S_SIZE_D + 0.4, h = 2 + 1, anchor = BOT);
  };
}