// Draw the clone with golden tint and transparency
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Draw health bar above clone
if (hp < max_hp) {
    var bar_width = 32;
    var bar_height = 4;
    var bar_x = x - bar_width / 2;
    var bar_y = y - sprite_height / 2 - 8;
    
    // Background
    draw_set_color(c_black);
    draw_rectangle(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1, false);
    
    // Health bar
    var health_percent = hp / max_hp;
    draw_set_color(c_red);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
    draw_set_color(c_lime);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_width * health_percent), bar_y + bar_height, false);
    
    draw_set_color(c_white);
}

// NO STATUS EFFECTS - Skip drawing status texts

// Always draw detection radius
draw_set_color(make_color_rgb(255, 215, 0));
draw_set_alpha(0.2);
draw_circle(x, y, detection_radius, false);
draw_set_alpha(1);
draw_circle(x, y, detection_radius, true);
draw_set_color(c_white);

// Draw "ZZZ" if no enemy in radius
if (!instance_exists(target_enemy)) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var zzz_y = y - sprite_height / 2 - 12;
    draw_text(x, zzz_y, "ZZZ");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Debug: Draw target line if enabled
if (global.debug_draw_collisions) {
    if (instance_exists(target_enemy)) {
        draw_set_color(c_yellow);
        draw_line(x, y, target_enemy.x, target_enemy.y);
        draw_set_color(c_white);
    }
}