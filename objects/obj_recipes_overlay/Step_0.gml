// Update layout on window resize
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

overlay_width = gui_width * 0.9;
overlay_height = gui_height * 0.9;
overlay_x = (gui_width - overlay_width) / 2;
overlay_y = (gui_height - overlay_height) / 2;

close_button_x = overlay_x + overlay_width - close_button_size - 10;
close_button_y = overlay_y + 10;

tree_panel_x = overlay_x + 40;
tree_panel_y = overlay_y + 80;
tree_panel_w = overlay_width - 80;
tree_panel_h = overlay_height - 120;

tree_start_x = tree_panel_x + tree_panel_w / 2;
tree_start_y = tree_panel_y + 60;

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check close button hover
close_button_hovered = point_in_rectangle(mx, my, close_button_x, close_button_y,
                                         close_button_x + close_button_size, close_button_y + close_button_size);

// Check for close button click
if (close_button_hovered && mouse_check_button_pressed(mb_left)) {
    instance_destroy();
    mouse_clear(mb_left);
}

// Close with Escape key
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    keyboard_clear(vk_escape);
}
