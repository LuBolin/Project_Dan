// ======== PAUSE BUTTON INTERACTION ========
// Only in non-menu rooms
if (room != MainMenu) {
    var gui_w = display_get_gui_width();
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Calculate button position (same as in Draw event)
    var btn_x = gui_w - pause_button_width - 16;
    var btn_y = pause_button_y;

    // Check if mouse is hovering over button
    pause_button_hovered = point_in_rectangle(mx, my, btn_x, btn_y, btn_x + pause_button_width, btn_y + pause_button_height);

    // Check for click on pause button
    if (pause_button_hovered && mouse_check_button_pressed(mb_left)) {
        // Trigger pause (same as pressing Escape)
        if (instance_exists(obj_pause_menu)) {
            with (obj_pause_menu) {
                event_perform(ev_keypress, vk_escape);
            }
        }
    }
}

// get player safely
if (is_undefined(global.player) || !instance_exists(global.player)) exit;
var p = global.player;
if (!variable_instance_exists(p, "inv")) exit;

var inv_len = array_length(p.inv);
if (inv_len <= 0) exit;

// ensure sel_slot exists
if (!variable_instance_exists(p, "sel_slot")) p.sel_slot = 0;
p.sel_slot = clamp(p.sel_slot, 0, max(0, inv_len - 1));

// --- Cycle active gourd slot ---
if (keyboard_check_pressed(ord("Q"))) {
    p.sel_slot = (p.sel_slot + 1) mod inv_len;
    p.equipped_element = p.inv[p.sel_slot];
}
if (keyboard_check_pressed(ord("E"))) {
    p.sel_slot = (p.sel_slot + inv_len - 1) mod inv_len;
    p.equipped_element = p.inv[p.sel_slot];
}

// Mouse wheel
if (mouse_wheel_up()) {
    p.sel_slot = (p.sel_slot + 1) mod inv_len;
    p.equipped_element = p.inv[p.sel_slot];
}
if (mouse_wheel_down()) {
    p.sel_slot = (p.sel_slot + inv_len - 1) mod inv_len;
    p.equipped_element = p.inv[p.sel_slot];
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