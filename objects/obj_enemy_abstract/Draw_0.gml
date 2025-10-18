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

// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}

