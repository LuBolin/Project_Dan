/// Mud Pool - Draw Event

// Draw with alpha for fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);

// Debug: Draw collision shape if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_set_alpha(alpha);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
