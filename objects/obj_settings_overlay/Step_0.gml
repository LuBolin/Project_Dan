/// Settings Overlay - Step Event

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

// === VOLUME SLIDER ===
var handle_x = slider_x + (global.master_volume * slider_width) - slider_handle_width / 2;
var handle_y = slider_y - (slider_handle_height - slider_height) / 2;

// Check if mouse is over slider handle
var handle_hover = point_in_rectangle(mx, my, handle_x, handle_y, handle_x + slider_handle_width, handle_y + slider_handle_height);

// Start dragging
if (handle_hover && mouse_check_button_pressed(mb_left)) {
    slider_dragging = true;
}

// Stop dragging
if (mouse_check_button_released(mb_left)) {
    slider_dragging = false;
}

// Update volume while dragging
if (slider_dragging) {
    var new_volume = clamp((mx - slider_x) / slider_width, 0, 1);
    global.master_volume = new_volume;
    audio_master_gain(global.master_volume);
}

// === FULLSCREEN BUTTON ===
fullscreen_button_hovered = point_in_rectangle(mx, my, fullscreen_button_x, fullscreen_button_y, fullscreen_button_x + fullscreen_button_width, fullscreen_button_y + fullscreen_button_height);

if (fullscreen_button_hovered && mouse_check_button_pressed(mb_left)) {
    global.is_fullscreen = !global.is_fullscreen;
    window_set_fullscreen(global.is_fullscreen);
    mouse_clear(mb_left);
}
