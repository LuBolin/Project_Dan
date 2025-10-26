// Draw the wall sprite with fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);

// Debug: Draw collision shape if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_orange);
    draw_set_alpha(alpha * 0.7);
    
    // Get sprite dimensions with scaling
    var sprite_w = sprite_get_width(sprite_index) * image_xscale;
    var sprite_h = sprite_get_height(sprite_index) * image_yscale;
    
    // Draw center cross showing orientation
    var cross_size = max(sprite_w, sprite_h) / 2;
    
    // Main axis (along the wall's length)
    var end1_x = x + lengthdir_x(cross_size, image_angle);
    var end1_y = y + lengthdir_y(cross_size, image_angle);
    var end2_x = x + lengthdir_x(cross_size, image_angle + 180);
    var end2_y = y + lengthdir_y(cross_size, image_angle + 180);
    
    draw_line_width(end1_x, end1_y, end2_x, end2_y, 3);
    
    // Cross axis (perpendicular to wall)
    var perp1_x = x + lengthdir_x(cross_size * 0.5, image_angle + 90);
    var perp1_y = y + lengthdir_y(cross_size * 0.5, image_angle + 90);
    var perp2_x = x + lengthdir_x(cross_size * 0.5, image_angle - 90);
    var perp2_y = y + lengthdir_y(cross_size * 0.5, image_angle - 90);
    
    draw_line_width(perp1_x, perp1_y, perp2_x, perp2_y, 2);
    
    // Draw center point
    draw_circle(x, y, 3, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}