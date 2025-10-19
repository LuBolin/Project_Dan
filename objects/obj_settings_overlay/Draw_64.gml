/// Settings Overlay - Draw GUI

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
draw_text_transformed(gui_width / 2, overlay_y + 30, "Settings", 2, 2, 0);

// === DRAW VOLUME SLIDER ===
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(col_text);
draw_text(overlay_x + 40, slider_y, "Volume:");

// Draw slider track
draw_set_color(col_slider);
draw_rectangle(slider_x, slider_y - slider_height / 2, slider_x + slider_width, slider_y + slider_height / 2, false);
draw_set_color(col_panel_border);
draw_rectangle(slider_x, slider_y - slider_height / 2, slider_x + slider_width, slider_y + slider_height / 2, true);

// Draw slider handle
var handle_x = slider_x + (global.master_volume * slider_width) - slider_handle_width / 2;
var handle_y = slider_y - (slider_handle_height - slider_height) / 2;
draw_set_color(col_slider_handle);
draw_rectangle(handle_x, handle_y, handle_x + slider_handle_width, handle_y + slider_handle_height, false);
draw_set_color(col_panel_border);
draw_rectangle(handle_x, handle_y, handle_x + slider_handle_width, handle_y + slider_handle_height, true);

// Draw volume percentage
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_text(slider_x + slider_width + 20, slider_y, string(round(global.master_volume * 100)) + "%");

// === DRAW FULLSCREEN BUTTON ===
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(col_text);
draw_text(overlay_x + 40, fullscreen_button_y + fullscreen_button_height / 2, "Fullscreen:");

var button_color = fullscreen_button_hovered ? col_button_hover : col_button;
draw_set_color(button_color);
draw_rectangle(fullscreen_button_x, fullscreen_button_y, fullscreen_button_x + fullscreen_button_width, fullscreen_button_y + fullscreen_button_height, false);
draw_set_color(col_panel_border);
draw_rectangle(fullscreen_button_x, fullscreen_button_y, fullscreen_button_x + fullscreen_button_width, fullscreen_button_y + fullscreen_button_height, true);

// Draw button text
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var button_text = global.is_fullscreen ? "On" : "Off";
draw_text(fullscreen_button_x + fullscreen_button_width / 2, fullscreen_button_y + fullscreen_button_height / 2, button_text);

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
