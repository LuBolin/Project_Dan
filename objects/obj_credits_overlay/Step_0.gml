/// Credits Overlay - Step Event

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check close button hover
close_button_hovered = point_in_rectangle(mx, my, close_button_x, close_button_y, close_button_x + close_button_size, close_button_y + close_button_size);

// Check for close button click
if (close_button_hovered && mouse_check_button_pressed(mb_left)) {
    instance_destroy();
    mouse_clear(mb_left);
}

// Also close with Escape key
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    keyboard_clear(vk_escape);
}

// Handle scrolling with mouse wheel
var mouse_wheel = mouse_wheel_up() - mouse_wheel_down();
if (mouse_wheel != 0) {
    scroll_y += mouse_wheel * scroll_speed;

    // Calculate total text height
    var line_height = 25;
    var text_height = string_height_ext(credits_text, line_height, overlay_width - 80);

    // Clamp scroll position
    var max_scroll = max(0, text_height - text_area_height);
    scroll_y = clamp(scroll_y, -max_scroll, 0);
}
