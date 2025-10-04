/// Main Menu Controller - Draw GUI

// Draw title "Dan（丹）"
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(col_title);

// Title position (upper third of screen)
var title_y = gui_height * 0.25;
draw_text_transformed(center_x, title_y, "Dan（丹）", 3, 3, 0);

// Draw buttons
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_x = center_x - button_width / 2;
    var btn_y = center_y + btn.y_offset - button_height / 2;

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
