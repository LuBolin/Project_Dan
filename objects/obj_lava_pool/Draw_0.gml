
if (damage_player) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, alpha);
} else {
    // Draw with alpha for fade effect
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, alpha);
}

// Add glowing effect (pulsing orange glow)
var glow_alpha = alpha * (0.3 + sin(glow_timer) * 0.2);
draw_set_alpha(glow_alpha);
draw_set_color(make_color_rgb(255, 100, 0)); // Orange glow
draw_circle(x, y, aoe_radius, false);

// Secondary outer ring
draw_set_alpha(glow_alpha * 0.5);
draw_set_color(make_color_rgb(255, 150, 0));
draw_circle(x, y, aoe_radius * 1.2, false);

draw_set_alpha(1);
draw_set_color(c_white);

// Debug hitbox
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_set_alpha(0.35);
    draw_circle(x, y, aoe_radius, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}