/// Pause Menu Controller - Draw GUI

// Don't draw in main menu or if not paused
if (!is_paused || room == MainMenu) exit;

// Draw semi-transparent overlay
draw_set_alpha(0.7);
draw_set_color(col_overlay);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw panel background
draw_set_color(col_panel_bg);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);

// Draw panel border
draw_set_color(col_panel_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);

// Draw title "PAUSED" at top
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(center_x, panel_y + 40, "PAUSED", 2, 2, 0);

// Draw buttons
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_x = center_x - button_width / 2;
    var btn_y = button_start_y + btn.y_offset;

    // Choose color based on hover state
    var btn_color = (i == hovered_button) ? col_button_hover : col_button_normal;

    // Draw button background
    draw_set_color(btn_color);
    draw_rectangle(btn_x, btn_y, btn_x + button_width, btn_y + button_height, false);

    // Draw button border
    draw_set_color(col_button_border);
    draw_rectangle(btn_x, btn_y, btn_x + button_width, btn_y + button_height, true);

    // Draw button text
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + button_width / 2, btn_y + button_height / 2, btn.name);
}

// Reset draw settings
draw_set_alpha(1);
