// Creator (player who used Destruction)
creator = obj_player;

// Get camera bounds for screen coverage
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Position effect at camera center
x = cam_x + cam_w / 2;
y = cam_y + cam_h / 2;

// Scale to cover entire screen with some padding
var screen_scale_x = (cam_w + 200) / sprite_get_width(sprite_index); // +200 for padding
var screen_scale_y = (cam_h + 200) / sprite_get_height(sprite_index);
image_xscale = screen_scale_x;
image_yscale = screen_scale_y;

// Visual properties
image_alpha = 0;
image_blend = make_color_rgb(255, 100, 100); // Red destruction tint
image_angle = 0;

// Effect timing (in seconds)
flash_duration_seconds = 0.3;  // Quick intense flash
fade_duration_seconds = 0.5;   // Slower fade out
total_duration_seconds = flash_duration_seconds + fade_duration_seconds;

// Convert to frames
flash_duration = flash_duration_seconds * game_get_speed(gamespeed_fps);
fade_duration = fade_duration_seconds * game_get_speed(gamespeed_fps);
total_duration = total_duration_seconds * game_get_speed(gamespeed_fps);
effect_timer = total_duration;

// Damage properties
destruction_damage = 6; // High damage for screen-clearing ability
has_damaged = false; // Only damage once during the flash

// Camera shake properties
shake_intensity = 8; // Reduced from 80 - was way too high
shake_duration_seconds = 0.6; // Shake duration
shake_duration = shake_duration_seconds * game_get_speed(gamespeed_fps);
shake_timer = shake_duration;

// Set depth to render above everything
depth = -1000;

// Start camera shake
if (instance_exists(obj_camera)) {
    obj_camera.shake_intensity = shake_intensity;
    obj_camera.shake_timer = shake_timer;
    obj_camera.shake_duration = shake_duration; // Also set the duration
    show_debug_message("Camera shake started - intensity: " + string(shake_intensity) + ", duration: " + string(shake_duration));
}

show_debug_message("Destruction effect created - covering screen with " + string(image_xscale) + "x" + string(image_yscale) + " scale");