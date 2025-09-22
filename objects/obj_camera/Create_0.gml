/// obj_camera - Create

// target to follow
follow = noone;

// smoothness of movement (0..1)
smooth = 0.12;

// desired ratio of player height to camera height
// e.g. 0.2 = player takes 20% of the camera height
preferred_ratio = 0.2;

// clamp zoom
min_zoom = 0.5;   // zoom in limit (smaller view)
max_zoom = 2.0;   // zoom out limit (bigger view)

// ensure view 0 exists
if (!view_enabled)  view_enabled = true;
if (!view_visible[0]) view_visible[0] = true;

cam = view_camera[0];
if (cam == -1) {
    var vw = 640, vh = 360; // default size
    cam = camera_create_view(0, 0, vw, vh, 0, noone, -1, -1, -1, -1);
    view_camera[0] = cam;
}
