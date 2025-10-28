// Draw with alpha for fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);

// Add glowing effect (pulsing orange glow)
var glow_alpha = alpha * (0.3 + sin(glow_timer) * 0.2);
draw_set_alpha(glow_alpha);
draw_set_color(make_color_rgb(255, 100, 0)); // Orange glow

// Fix: Use collision mask size instead of visual sprite size
// The collision happens with the actual sprite bounds, so glow should match
var collision_radius = max(sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index),
                          sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)) / 2;

// Apply the same scaling as the sprite
var actual_collision_radius = collision_radius * max(image_xscale, image_yscale);
draw_circle(x, y, actual_collision_radius, false);

// Add secondary glow ring
draw_set_alpha(glow_alpha * 0.5);
draw_set_color(make_color_rgb(255, 150, 0)); // Yellow outer glow
draw_circle(x, y, actual_collision_radius * 1.2, false);

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