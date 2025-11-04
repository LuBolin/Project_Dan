draw_self();

if (hp > 0) {
    var bar_width = 32;
    var bar_height = 4;
    var bar_x = x - bar_width / 2;
    var bar_y = y - sprite_height / 2 - 8;

    var hp_percent = hp / max_hp;

    draw_set_color(c_black);
    draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);

    draw_set_color(c_red);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

    draw_set_color(c_lime);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_width * hp_percent), bar_y + bar_height, false);

    draw_set_color(c_white);
}

// Draw status effects above enemy head
if (array_length(status_texts) > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(-1); // Use default font

    // Position above health bar
    var status_x = x;
    var status_y = y - sprite_height / 2 - 18; // Above health bar

    // Draw each status text
    for (var i = 0; i < array_length(status_texts); i++) {
        var text = status_texts[i];

        // Draw text shadow for readability
        draw_set_color(c_black);
        draw_text(status_x + 1, status_y - (i * 12) + 1, text);

        // Draw text
        draw_set_color(c_yellow);
        draw_text(status_x, status_y - (i * 12), text);
    }

    // Reset draw settings
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}

// For drawing sprite effects if and when we have them (like a fire for BurnEffect)
// This is a temporary fix
if !is_undefined(effect_sprite) {
    draw_sprite_ext(effect_sprite, 0, x, y + 20, 0.05, 0.05, 0, c_white, 1);
}

if (!is_undefined(curr_state)) {
    curr_state.draw()
}