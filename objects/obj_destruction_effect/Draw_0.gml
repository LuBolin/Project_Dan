// Draw the destruction effect sprite covering the screen
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Add additional visual effects
if (image_alpha > 0.4) {
    // Draw pulsing outer glow during intense phase
    var glow_alpha = image_alpha * 0.3;
    var glow_scale = max(image_xscale, image_yscale) * 1.2;
    
    draw_sprite_ext(sprite_index, image_index, x, y, glow_scale, glow_scale, image_angle, c_white, glow_alpha);
}

// Debug: Draw screen bounds if enabled
if (global.debug_draw_collisions) {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_rectangle(cam_x, cam_y, cam_x + cam_w, cam_y + cam_h, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}