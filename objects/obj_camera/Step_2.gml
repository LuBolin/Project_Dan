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

// safe clamp to room
//var max_x = room_width  - vw;
//var max_y = room_height - vh;
//if (max_x > 0) tx = clamp(tx, 0, max_x); else tx = (room_width - vw) * 0.5;
//if (max_y > 0) ty = clamp(ty, 0, max_y); else ty = (room_height - vh) * 0.5;

// smooth movement
var k = clamp(smooth, 0, 1);
tx = lerp(cx, tx, k);
ty = lerp(cy, ty, k);

// apply camera position
camera_set_view_pos(cam, tx, ty);
