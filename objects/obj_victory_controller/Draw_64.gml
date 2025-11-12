/// Victory Controller - Draw GUI

// Only show overlay during narration and waiting phases
if (state == VICTORY_STATE.NARRATION || state == VICTORY_STATE.WAITING_INPUT) {

    // Helper function to draw text with black outline
    function draw_text_outlined(_x, _y, _text) {
        // Draw black outline
        draw_set_color(c_black);
        for (var ox = -1; ox <= 1; ox++) {
            for (var oy = -1; oy <= 1; oy++) {
                if (ox != 0 || oy != 0) {
                    draw_text(_x + ox, _y + oy, _text);
                }
            }
        }
        // Draw colored text on top
        draw_set_color(col_text);
        draw_text(_x, _y, _text);
    }

    // Draw semi-transparent overlay
    draw_set_alpha(0.85);
    draw_set_color(col_overlay);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    draw_set_alpha(1);

    // Draw panel background
    draw_set_color(col_panel_bg);
    draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);

    // Draw panel border with golden color
    draw_set_color(col_panel_border);
    for (var i = 0; i < 3; i++) {
        draw_rectangle(panel_x - i, panel_y - i, panel_x + panel_width + i, panel_y + panel_height + i, true);
    }

    // Draw title "VICTORY"
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(col_title);
    draw_text_transformed(panel_x + panel_width / 2, panel_y + 30, "VICTORY", 2.5, 2.5, 0);

    // Draw narration text
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    var text_start_y = panel_y + 100;
    var line_height = 20;

    for (var i = 0; i < array_length(narration_lines); i++) {
        var line_y = text_start_y + i * line_height;
        draw_text(panel_x + panel_width / 2, line_y, narration_lines[i]);
    }

    // Draw "Continue" button only in waiting state
    if (state == VICTORY_STATE.WAITING_INPUT) {
        var button_col = button_hover ? col_button_hover : col_button;
        draw_set_color(button_col);
        draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
        draw_set_color(col_panel_border);
        draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);

        draw_set_color(col_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(button_x + button_width / 2, button_y + button_height / 2, "Continue");
    }

    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
