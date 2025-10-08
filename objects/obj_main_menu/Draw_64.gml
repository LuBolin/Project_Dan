/// Main Menu Controller - Draw GUI

// Draw title "Dan（丹）"
draw_set_font(fnt_chinese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(col_title);

// Title position (move up to give more space)
var title_y = gui_height * 0.2;
draw_text_transformed(center_x, title_y, "Dan 丹", 2, 2, 0);

// Reset to default font for buttons
draw_set_font(-1);

// Draw buttons
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_w = btn.width;
    var btn_h = btn.height;
    var btn_x = center_x + btn.x_offset - btn_w / 2;
    var btn_y = center_y + btn.y_offset - btn_h / 2;

    // Choose color based on hover state
    var btn_color = (i == hovered_button) ? col_button_hover : col_button_normal;

    // Draw button background
    draw_set_color(btn_color);
    draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);

    // Draw button border
    draw_set_color(col_button_border);
    draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);

    // Draw button text
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Use larger font for Play button
    if (btn.name == "Play") {
        draw_text_transformed(btn_x + btn_w / 2, btn_y + btn_h / 2, btn.name, 1.5, 1.5, 0);
    } else {
        draw_text(btn_x + btn_w / 2, btn_y + btn_h / 2, btn.name);
    }
}

// Reset draw settings
draw_set_alpha(1);
