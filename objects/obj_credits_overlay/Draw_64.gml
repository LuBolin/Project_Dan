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

// Draw credits text
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_ext(gui_width / 2, overlay_y + 100, credits_text, 25, overlay_width - 80);

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
