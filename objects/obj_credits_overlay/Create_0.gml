/// Credits Overlay - Create Event

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

// Scrolling properties
scroll_y = 0;
scroll_speed = 30;
text_start_y = overlay_y + 100;
text_area_height = overlay_height - 120; // Height available for text

// Scroll bar properties
scrollbar_width = 12;
scrollbar_x = overlay_x + overlay_width - 50;
scrollbar_track_y = text_start_y;
scrollbar_track_height = text_area_height;
scrollbar_handle_min_height = 30;

// Colors
col_overlay_bg = c_black;
col_panel_bg = make_color_rgb(40, 30, 25);
col_panel_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);
col_close_normal = make_color_rgb(80, 50, 40);
col_close_hover = make_color_rgb(120, 80, 60);

// Credits content - split into parts for different fonts
credits_title = "Dan 丹"; // Uses Chinese font

credits_body = @"Designer:
Bolin, Ashley, James

Artist:
Mariyya, Julia

Programmer:
James, Ashley, Bolin

QA:
Julia, James

BGM:
China - Asian China Chinese Music
by Aliaksei Yukhnevich
https://pixabay.com/music/china-china-asian-china-chinese-music-390969/

Special Thanks:
Everyone who played and supported this game!

Assets:
Steam Effect Designed by Freepik
https://www.freepik.com/free-vector/cartoon-smoke-element-animation-frames_13763535.htm

© 2025"; // Uses default font
