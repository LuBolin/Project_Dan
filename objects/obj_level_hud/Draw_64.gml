// ======== PAUSE BUTTON ========
// Get GUI dimensions first
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Only show in non-menu rooms
if (room != MainMenu) {
    // Position button in top-right corner
    var btn_x = gui_w - pause_button_width - 16;
    var btn_y = pause_button_y;

    // Button colors
    var btn_bg_color = pause_button_hovered ? make_color_rgb(80, 60, 50) : make_color_rgb(50, 40, 30);
    var btn_border_color = make_color_rgb(150, 120, 90);
    var btn_text_color = c_white;

    // Draw button background
    draw_set_alpha(0.8);
    draw_set_color(btn_bg_color);
    draw_rectangle(btn_x, btn_y, btn_x + pause_button_width, btn_y + pause_button_height, false);

    // Draw button border
    draw_set_alpha(1);
    draw_set_color(btn_border_color);
    draw_rectangle(btn_x, btn_y, btn_x + pause_button_width, btn_y + pause_button_height, true);

    // Draw button text
    draw_set_color(btn_text_color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + pause_button_width / 2, btn_y + pause_button_height / 2, pause_button_text);

    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// ======== HEALTH BAR (your original, unchanged except organized) ========
if (!instance_exists(global.player)) exit;
var p = global.player;

// guard health vars
if (!variable_instance_exists(p, "hp") || !variable_instance_exists(p, "max_hp")) exit;

var hp     = p.hp;
var hp_max = max(1, p.max_hp);
var ratio  = clamp(hp / hp_max, 0, 1);

// health bar size & pos
var bar_w = gui_w * 0.20;   // 20% width
var bar_h = bar_w / 8;      // 1:8 height:width
var pad   = 16;
var bar_x = pad;
var bar_y = pad;

// colors
var back_col   = make_color_rgb(40, 40, 40);
var fill_col   = make_color_rgb(200, 50, 50);
var border_col = c_black;


// Progressive shading for low health
draw_set_color(c_black)

var shading = 1 - ratio * 3;

draw_set_alpha(clamp(shading, 0, 0.5));
draw_rectangle(0, 0, gui_w, gui_h, false);

draw_set_alpha(clamp(shading, 0, 0.8));
draw_sprite_stretched(spr_hurt_pov, 0, 0, 0, gui_w, gui_h);

// draw back
draw_set_color(back_col);
draw_set_alpha(1);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

// draw fill
draw_set_color(fill_col);
draw_rectangle(bar_x, bar_y, bar_x + (bar_w * ratio), bar_y + bar_h, false);

// border + text
draw_set_color(border_col);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(bar_x + bar_w + 10, bar_y - 2, string(hp) + " / " + string(hp_max));

// ======== DIFFICULTY LEVEL DISPLAY ========
// Show current difficulty level
var difficulty = get_current_difficulty();
var diff_text = "Level: " + string(difficulty);
draw_set_color(c_yellow);
draw_text(bar_x, bar_y + bar_h + 8, diff_text);
draw_set_color(c_white);

// ======== ENEMY KILL COUNTER ========
// Check if level manager exists and display kill requirements
if (instance_exists(obj_level_manager)) {
    var lm = instance_find(obj_level_manager, 0);
    if (lm.enemy_count_complete) {
        // Position at center-left of screen
        var text_x = pad;
        var text_y = gui_h / 2;

        var kills_needed = lm.required_kills;
        var total = lm.total_enemies;
        var current = lm.current_kills;

        // Prepare text lines (wrapped)
        var kills_text = string(kills_needed) + "/" + string(total);
        var line1 = "Collect ";
        var line1_part2 = " chi";
        var line2 = "to unlock the";
        var line3 = "exit door!";
        var line4 = "Current: " + string(current);

        // Calculate text dimensions for background
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_font(-1); // Use default font for measurement
        var line_height = 20;
        var max_width = max(
            string_width(line1) + string_width_ext(kills_text, -1, -1) + string_width(line1_part2),
            string_width(line2),
            string_width(line3),
            string_width(line4)
        );
        var bg_padding = 8;
        var bg_x1 = text_x - bg_padding;
        var bg_y1 = text_y - bg_padding;
        var bg_x2 = text_x + max_width + bg_padding;
        var bg_y2 = text_y + (line_height * 4) + bg_padding;

        // Draw translucent gray background
        draw_set_alpha(0.7);
        draw_set_color(make_color_rgb(50, 50, 50));
        draw_rectangle(bg_x1, bg_y1, bg_x2, bg_y2, false);
        draw_set_alpha(1);

        // Draw text lines
        draw_set_color(c_white);

        // Line 1: "Collect" + underlined "X/Y" + " chi"
        draw_text(text_x, text_y, line1);
        var x_offset = string_width(line1);
        draw_text(text_x + x_offset, text_y, kills_text);
        var x_offset2 = x_offset + string_width(kills_text);
        draw_text(text_x + x_offset2, text_y, line1_part2);
        // Draw underline for X/Y
        var underline_y = text_y + string_height(kills_text) - 2;
        draw_line(text_x + x_offset, underline_y, text_x + x_offset + string_width(kills_text), underline_y);

        // Line 2: "to unlock the"
        draw_text(text_x, text_y + line_height, line2);

        // Line 3: "exit door!"
        draw_text(text_x, text_y + line_height * 2, line3);

        // Draw current kills with color coding (red if not enough, green if enough)
        var kill_color = (current >= kills_needed) ? c_lime : c_red;
        draw_text(text_x, text_y + line_height * 3, "Current: ");
        draw_set_color(kill_color);
        draw_text(text_x + string_width("Current: "), text_y + line_height * 3, string(current));

        // Reset drawing state
        draw_set_color(c_white);
        draw_set_valign(fa_top);
    }
}


// ======== GOURD RING HUD (integrated) ========

// require inventory (array of 3 structs) and sel_slot
if (!variable_instance_exists(p, "inv") || array_length(p.inv) < 3 || !variable_instance_exists(p, "sel_slot")) exit;

// draw ring (torus)
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

draw_set_color(col_ring);
draw_circle(ui_x, ui_y, ring_R, false);
draw_set_color(col_hole);
draw_circle(ui_x, ui_y, ring_r, false);
draw_set_color(col_outline);
draw_circle(ui_x, ui_y, ring_R, true);
draw_circle(ui_x, ui_y, ring_r, true);

// draw the 3 nodes
for (var i = 0; i < 3; i++) {
    var ang = base_angles[i] + angle_offset;
    var nx = ui_x + lengthdir_x(ring_R, ang);
    var ny = ui_y + lengthdir_y(ring_R, ang);

    var g = p.inv[i]; // struct instance (class)
    var is_sel = (i == p.sel_slot);

    var node_col  = c_gray;
    var dim_alpha = 1;

    // use gourd's color if present
    if (is_struct(g) && !is_undefined(g.color)) {
        node_col = g.color;
    }

	// compute scale for target pixel size
    var sw = max(1, sprite_get_width(spr_gourd_icon));
    var sh = max(1, sprite_get_height(spr_gourd_icon));
    var target_d = is_sel ? node_px_sel : node_px;     // desired diameter in px
    var scale = target_d / max(sw, sh); // keep aspect
    var rot = 0;

    // draw tinted icon
    draw_set_alpha(dim_alpha);
    draw_sprite_ext(spr_gourd_icon, 0, nx, ny, scale, scale, rot, node_col, 1);

	draw_set_alpha(1);

    // draw cooldown overlay
    if (is_struct(g) && variable_struct_exists(g, "cooldown_timer") && variable_struct_exists(g, "cooldown")) {
        if (g.cooldown_timer > 0 && g.cooldown > 0) {
            var cd_ratio = g.cooldown_timer / g.cooldown;
            var overlay_radius = target_d / 2;

            // draw semi-transparent dark overlay
            draw_set_alpha(0.7);
            draw_set_color(c_black);
            draw_circle(nx, ny, overlay_radius, false);

            // draw cooldown text (with 1 decimal place)
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var cd_seconds = g.cooldown_timer / game_get_speed(gamespeed_fps);
            var cd_text = string_format(cd_seconds, 0, 1); // Show 1 decimal place
            draw_text(nx, ny, cd_text);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }

}
draw_set_alpha(1);

// label for selected (keep your existing right-side label)
var sel_g = p.inv[p.sel_slot];
var sel_name = (is_struct(sel_g) && !is_undefined(sel_g.name)) ? sel_g.name : "Empty";
draw_set_color(col_text);
//draw_text(ui_x + ring_R + 16, ui_y - 6, sel_name);
draw_text(ui_x - 15 , ui_y + 100, sel_name);