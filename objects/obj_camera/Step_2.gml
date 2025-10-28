// Camera shake effect
var shake_offset_x = 0;
var shake_offset_y = 0;

if (variable_instance_exists(self, "shake_timer") && shake_timer > 0) {
    shake_timer--;
    
    if (variable_instance_exists(self, "shake_intensity")) {
        // Apply random shake offset
        var shake_x = random_range(-shake_intensity, shake_intensity);
        var shake_y = random_range(-shake_intensity, shake_intensity);
        
        // Reduce shake intensity over time
        var shake_strength = shake_timer / shake_duration;
        shake_offset_x = shake_x * shake_strength;
        shake_offset_y = shake_y * shake_strength;
    }
}

/// obj_camera - End Step
if (!instance_exists(follow)) exit;

// refresh handle if needed
if (cam != view_camera[0]) cam = view_camera[0];

// current camera info
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

// get player size (scaled sprite height)
var ph = sprite_get_height(follow.sprite_index) * abs(follow.image_yscale);

// how much of the camera height the player currently takes
var current_ratio = ph / vh;

// how far off from desired ratio
var zoom_factor = current_ratio / preferred_ratio;

// clamp zoom factor
zoom_factor = clamp(zoom_factor, min_zoom, max_zoom);

// apply new view size
var new_w = vw * zoom_factor;
var new_h = vh * zoom_factor;
camera_set_view_size(cam, new_w, new_h);

// recalc view dims
vw = camera_get_view_width(cam);
vh = camera_get_view_height(cam);

// desired position (center follow)
var tx = follow.x - vw * 0.5;
var ty = follow.y - vh * 0.5;

// smooth movement
var k = clamp(smooth, 0, 1);
tx = lerp(cx, tx, k);
ty = lerp(cy, ty, k);

// Apply shake offset to final camera position
tx += shake_offset_x;
ty += shake_offset_y;

// apply camera position
camera_set_view_pos(cam, tx, ty);