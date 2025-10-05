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

// Settings content
settings_text = @"Settings:

Volume: 100%
Fullscreen: Off
Difficulty: Normal

(Settings will be implemented here)";
