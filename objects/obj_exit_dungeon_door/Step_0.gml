/// Check if door is on-screen or off-screen

// Get camera info
var cam = view_camera[0];
if (cam == -1) exit;

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Calculate if door is on screen
var door_bbox_left = bbox_left;
var door_bbox_right = bbox_right;
var door_bbox_top = bbox_top;
var door_bbox_bottom = bbox_bottom;

// Check if door is within camera bounds
is_on_screen = (door_bbox_right >= cam_x &&
                door_bbox_left <= cam_x + cam_w &&
                door_bbox_bottom >= cam_y &&
                door_bbox_top <= cam_y + cam_h);

// Calculate arrow position and angle when off-screen
if (!is_on_screen) {
    // Direction from camera center to door
    var cam_center_x = cam_x + cam_w / 2;
    var cam_center_y = cam_y + cam_h / 2;

    arrow_angle = point_direction(cam_center_x, cam_center_y, x, y);

    // Calculate edge position for arrow
    // Find intersection point on screen edge
    var dx = x - cam_center_x;
    var dy = y - cam_center_y;

    // Margin from edge
    var edge_margin = 32;

    // Calculate screen bounds with margin
    var screen_left = cam_x + edge_margin;
    var screen_right = cam_x + cam_w - edge_margin;
    var screen_top = cam_y + edge_margin;
    var screen_bottom = cam_y + cam_h - edge_margin;

    // Find where the line from center to door intersects screen edge
    var t = 1; // parameter for line interpolation

    // Check each edge
    if (dx != 0) {
        // Left/right edges
        var t_horizontal = dx > 0 ? (screen_right - cam_center_x) / dx : (screen_left - cam_center_x) / dx;
        t = min(t, t_horizontal);
    }

    if (dy != 0) {
        // Top/bottom edges
        var t_vertical = dy > 0 ? (screen_bottom - cam_center_y) / dy : (screen_top - cam_center_y) / dy;
        t = min(t, t_vertical);
    }

    // Calculate base edge position
    var edge_x = cam_center_x + dx * t;
    var edge_y = cam_center_y + dy * t;

    // The arrow sprite has origin at left-middle (the tip at x=0)
    // Arrow is 64 pixels wide, scaled to 0.75x = 48 pixels total length
    // We want the TIP at the edge, so we need to move the arrow BACK
    // by its length in the opposite direction it's pointing
    var arrow_length = sprite_get_width(spr_aim_arrow) * 0.75; // 48 pixels

    // Move arrow position back toward center by arrow length
    // so when drawn, the tip reaches the edge
    arrow_x = edge_x - lengthdir_x(arrow_length, arrow_angle);
    arrow_y = edge_y - lengthdir_y(arrow_length, arrow_angle);
}
