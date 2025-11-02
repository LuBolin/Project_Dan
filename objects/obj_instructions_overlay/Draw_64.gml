/// Instructions Overlay - Draw GUI

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
draw_text_transformed(gui_width / 2, overlay_y + 30, "Instructions", 2, 2, 0);

// Draw overarching instructions at top
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var overarching_y = overlay_y + 100;
draw_text_ext(gui_width / 2, overarching_y, overarching_text, 25, overlay_width - 80);

// Calculate starting Y for columns (below overarching text)
var overarching_height = string_height_ext(overarching_text, 25, overlay_width - 80);
var columns_start_y = overarching_y + overarching_height + 50;

// Define column dimensions
var column_padding = 40;
var column_spacing = 40;
var column_width = (overlay_width - column_padding * 2 - column_spacing) / 2;
var left_column_x = overlay_x + column_padding;
var right_column_x = left_column_x + column_width + column_spacing;

// Draw separator line
draw_set_color(col_panel_border);
draw_line_width(overlay_x + column_padding, columns_start_y - 20,
                overlay_x + overlay_width - column_padding, columns_start_y - 20, 2);

// === LEFT COLUMN: Exploration ===
draw_set_color(col_title);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed(left_column_x, columns_start_y, "Exploration", 1.3, 1.3, 0);

draw_set_color(col_text);
draw_text_ext(left_column_x, columns_start_y + 40, exploration_text, 22, column_width);

// === RIGHT COLUMN: Alchemy ===
draw_set_color(col_title);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed(right_column_x, columns_start_y, "Alchemy", 1.3, 1.3, 0);

draw_set_color(col_text);
draw_text_ext(right_column_x, columns_start_y + 40, alchemy_text, 22, column_width);

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
