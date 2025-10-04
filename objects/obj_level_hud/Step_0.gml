// get player safely
if (is_undefined(global.player) || !instance_exists(global.player)) exit;

var p = global.player;

// ensure sel_slot exists
if (!variable_instance_exists(p, "sel_slot")) exit;


// --- Cycle active gourd slot ---
if (keyboard_check_pressed(ord("Q"))) {
    p.sel_slot = (p.sel_slot + 1) mod 3;
}
if (keyboard_check_pressed(ord("E"))) {
    p.sel_slot = (p.sel_slot + 2) mod 3;
}

// compute desired offset so selected slot appears at 270°
var sel = clamp(p.sel_slot, 0, 2);
var desired = 270 - base_angles[sel];

// normalize helpers
function _norm(a){ while (a <= -180) a += 360; while (a > 180) a -= 360; return a; }

var cur   = _norm(angle_offset);
var dst   = _norm(desired);
var delta = _norm(dst - cur);

// move toward desired by rot_speed_deg (shortest path)
var step = clamp(delta, -rot_speed_deg, rot_speed_deg);
angle_offset = _norm(cur + step);