/// Mud Pool - Draw Event

// Draw with alpha for fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);

// Debug: Draw AoE circle if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_yellow);
    draw_set_alpha(alpha * 0.5);
    draw_circle(x, y, aoe_radius, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
