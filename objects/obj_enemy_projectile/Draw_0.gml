draw_self();

// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_yellow); // Yellow for enemy projectiles
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}