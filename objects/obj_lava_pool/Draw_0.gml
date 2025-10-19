// Draw with alpha for fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);

// Add glowing effect (pulsing orange glow)
var glow_alpha = alpha * (0.3 + sin(glow_timer) * 0.2);
draw_set_alpha(glow_alpha);
draw_set_color(make_color_rgb(255, 100, 0)); // Orange glow
draw_circle(x, y, (sprite_width * image_xscale / 2) * (1.1 + sin(glow_timer) * 0.1), false);
draw_set_alpha(1);
draw_set_color(c_white);

// Debug: Draw collision shape if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_set_alpha(alpha);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}