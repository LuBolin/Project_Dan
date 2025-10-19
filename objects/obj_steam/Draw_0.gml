/// Steam Cloud - Draw Event

// Draw with alpha for fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);

// Debug: Draw collision shape if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_aqua);
    draw_set_alpha(image_alpha);
    draw_circle(x, y, sprite_width * image_xscale / 2, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}