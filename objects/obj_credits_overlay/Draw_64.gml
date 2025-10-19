/// Credits Overlay - Draw GUI

// Draw semi-transparent overlay
draw_set_alpha(0.7);
draw_set_color(col_overlay_bg);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw panel background with transparency
draw_set_alpha(0.95);
draw_set_color(col_panel_bg);
draw_rectangle(overlay_x, overlay_y, overlay_x + overlay_width, overlay_y + overlay_height, false);
draw_set_alpha(1);

// Draw panel border
draw_set_color(col_panel_border);
draw_rectangle(overlay_x, overlay_y, overlay_x + overlay_width, overlay_y + overlay_height, true);

// Draw title
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(gui_width / 2, overlay_y + 30, "Credits", 2, 2, 0);

// Set up clipping rectangle for scrollable text area
gpu_set_scissor(overlay_x + 40, text_start_y, overlay_width - 80, text_area_height);

// Draw credits text with scroll offset
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_ext(gui_width / 2, text_start_y + scroll_y, credits_text, 25, overlay_width - 80);

// Disable clipping
gpu_set_scissor(-1, -1, -1, -1);

// Draw scroll bar
var line_height = 25;
var text_height = string_height_ext(credits_text, line_height, overlay_width - 80);
var max_scroll = max(0, text_height - text_area_height);

if (max_scroll > 0) {
    // Draw scroll bar track
    draw_set_color(make_color_rgb(60, 50, 45));
    draw_rectangle(scrollbar_x, scrollbar_track_y, scrollbar_x + scrollbar_width, scrollbar_track_y + scrollbar_track_height, false);

    // Draw scroll bar border
    draw_set_color(col_panel_border);
    draw_rectangle(scrollbar_x, scrollbar_track_y, scrollbar_x + scrollbar_width, scrollbar_track_y + scrollbar_track_height, true);

    // Calculate scroll handle position and size
    var content_ratio = text_area_height / text_height; // Ratio of visible area to total content
    var handle_height = max(scrollbar_handle_min_height, scrollbar_track_height * content_ratio);

    var scroll_ratio = abs(scroll_y) / max_scroll; // How far we've scrolled (0 to 1)
    var handle_y = scrollbar_track_y + (scrollbar_track_height - handle_height) * scroll_ratio;

    // Draw scroll handle
    draw_set_color(make_color_rgb(120, 100, 80));
    draw_rectangle(scrollbar_x + 2, handle_y, scrollbar_x + scrollbar_width - 2, handle_y + handle_height, false);

    // Draw scroll handle border
    draw_set_color(col_panel_border);
    draw_rectangle(scrollbar_x + 2, handle_y, scrollbar_x + scrollbar_width - 2, handle_y + handle_height, true);
}

// Draw close button (X)
var close_color = close_button_hovered ? col_close_hover : col_close_normal;
draw_set_color(close_color);
draw_rectangle(close_button_x, close_button_y, close_button_x + close_button_size, close_button_y + close_button_size, false);
draw_set_color(col_panel_border);
draw_rectangle(close_button_x, close_button_y, close_button_x + close_button_size, close_button_y + close_button_size, true);

// Draw X
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(close_button_x + close_button_size / 2, close_button_y + close_button_size / 2, "X", 1.5, 1.5, 0);

// Reset draw settings
draw_set_alpha(1);
