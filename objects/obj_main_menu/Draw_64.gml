/// Main Menu Controller - Draw GUI

// Draw title "Dan（丹）" with fade effect and position animation
draw_set_font(fnt_chinese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(col_title);

// Apply fade alpha for title
draw_set_alpha(title_alpha);

// Use animated title position
draw_text_transformed(center_x, title_y_current, "Dan 丹", 2, 2, 0);

// Reset alpha
draw_set_alpha(1);

// Reset to default font
draw_set_font(-1);

// If buttons haven't been shown yet, draw "Press any key to continue" (only if not auto-transition)
if (!show_buttons && !auto_transition && prompt_alpha > 0) {
    draw_set_alpha(prompt_alpha);
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var prompt_y = gui_height * 0.85;

    // Draw "Press " in normal font
    draw_set_font(-1);
    var text_before = "Press ";
    var text_bold = "any key";
    var text_after = " to continue";

    // Measure text widths to position correctly
    var before_width = string_width(text_before);
    var bold_width = string_width(text_bold);
    var after_width = string_width(text_after);
    var total_width = before_width + bold_width + after_width;

    // Starting x position (centered)
    var start_x = center_x - total_width / 2;

    // Draw "Press " normally
    draw_text(start_x + before_width / 2, prompt_y, text_before);

    // Draw "any key" in bold (simulated with multiple draws offset slightly)
    var bold_x = start_x + before_width + bold_width / 2;
    draw_text(bold_x, prompt_y, text_bold);
    draw_text(bold_x + 1, prompt_y, text_bold); // Offset for bold effect
    draw_text(bold_x, prompt_y + 1, text_bold); // Offset for bold effect

    // Draw " to continue" normally
    draw_text(start_x + before_width + bold_width + after_width / 2, prompt_y, text_after);

    draw_set_alpha(1);
}

// Draw buttons (with fade-in effect during transition)
if (show_buttons || transitioning) {
    // Apply fade alpha for buttons during transition
    if (transitioning || buttons_alpha < 1) {
        draw_set_alpha(buttons_alpha);
    }

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
}

// Reset draw settings
draw_set_alpha(1);
