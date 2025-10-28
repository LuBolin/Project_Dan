// Draw the healing area sprite with green tint
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, make_color_rgb(100, 255, 100), image_alpha);

// Debug: Draw healing radius if enabled
if (global.debug_draw_collisions) {
    draw_set_color(make_color_rgb(100, 255, 100));
    draw_set_alpha(image_alpha * 0.3);
    draw_circle(x, y, healing_radius, false);
    draw_set_alpha(image_alpha);
    draw_circle(x, y, healing_radius, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}