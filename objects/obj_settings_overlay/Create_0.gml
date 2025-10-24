/// Settings Overlay - Create Event

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Overlay properties (80% of screen)
overlay_width = gui_width * 0.8;
overlay_height = gui_height * 0.8;
overlay_x = (gui_width - overlay_width) / 2;
overlay_y = (gui_height - overlay_height) / 2;

// Close button properties
close_button_size = 40;
close_button_x = overlay_x + overlay_width - close_button_size - 10;
close_button_y = overlay_y + 10;
close_button_hovered = false;

// Colors
col_overlay_bg = c_black;
col_panel_bg = make_color_rgb(40, 30, 25);
col_panel_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);
col_close_normal = make_color_rgb(80, 50, 40);
col_close_hover = make_color_rgb(120, 80, 60);
col_slider = make_color_rgb(100, 80, 60);
col_slider_handle = make_color_rgb(180, 140, 100);
col_button = make_color_rgb(80, 60, 50);
col_button_hover = make_color_rgb(120, 90, 70);

// Initialize global settings if they don't exist
if (!variable_global_exists("master_volume")) {
    global.master_volume = 0.5; // 0.0 to 1.0 (starts at 50%)
}
if (!variable_global_exists("is_fullscreen")) {
    global.is_fullscreen = window_get_fullscreen();
}

// Apply current volume
audio_master_gain(global.master_volume);

// Volume slider properties
slider_x = overlay_x + 120;
slider_y = overlay_y + 150;
slider_width = 300;
slider_height = 8;
slider_handle_width = 20;
slider_handle_height = 30;
slider_dragging = false;

// Fullscreen button properties
fullscreen_button_x = overlay_x + 180;
fullscreen_button_y = overlay_y + 230;
fullscreen_button_width = 100;
fullscreen_button_height = 40;
fullscreen_button_hovered = false;
