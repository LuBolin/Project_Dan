var gw = gui_width;
var gh = gui_height;

// Draw the current sprite full-screen (letterboxed)
if (sprite_exists(current_sprite)) {
    var sw = max(1, sprite_get_width(current_sprite));
    var sh = max(1, sprite_get_height(current_sprite));
    var scale = min(gw / sw, gh / sh);
    var cx = gw * 0.5;
    var cy = gh * 0.5;

    draw_sprite_ext(current_sprite, floor(image_index), cx, cy, scale, scale, 0, c_white, 1);
}

// Draw narration box only during SHOW_TEXT
if (state == INTRO_STATE.SHOW_TEXT) {
    var dialog_box_height = 150;
    var dialog_box_y = gh - dialog_box_height;

    // Panel
    draw_set_alpha(0.95);
    draw_set_color(col_dialog_bg);
    draw_rectangle(0, dialog_box_y, gw, gh, false);
    draw_set_alpha(1);

    // Border
    draw_set_color(col_dialog_border);
    draw_rectangle(0, dialog_box_y, gw, gh, true);
    draw_line_width(0, dialog_box_y, gw, dialog_box_y, 3);

    // Text (typewriter substring)
    draw_set_color(col_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var margin = 40;
    var text_x = margin;
    var text_y = dialog_box_y + 30;
    var text_w = gw - margin * 2;
    var typed = string_copy(narration_text, 1, visible_chars);
    draw_text_ext(text_x, text_y, typed, 24, text_w);
}

// Skip prompt (bottom-right), always visible during intro
var prompt_text = "Press any key to skip";
var blink_alpha = 0.5 + sin(blink_t / 10) * 0.5;
draw_set_alpha(blink_alpha);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(gw - 20, gh - 20, prompt_text);
draw_set_alpha(1);

// Fade-to-black overlay
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}