/// Victory Credits - Draw GUI

// Draw black background
draw_set_color(col_bg);
draw_rectangle(0, 0, gui_width, gui_height, false);

// Set up text drawing
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);

// Draw each line with Star Wars perspective effect
for (var i = 0; i < array_length(credits_lines); i++) {
    var line = credits_lines[i];
    var line_y = scroll_y + (i * line_height);

    // Only draw if line is on screen (with some buffer)
    if (line_y > -line_height && line_y < gui_height + line_height) {

        // Calculate position in screen space (0 at center, -1 at top, +1 at bottom)
        var screen_center = gui_height / 2;
        var distance_from_center = (line_y - screen_center) / screen_center;

        // Calculate perspective scale (smaller at top, larger at bottom)
        // Lines far from center (towards edges) appear smaller
        var perspective_factor = 1.0 - (abs(distance_from_center) * 0.3);
        perspective_factor = max(0.3, perspective_factor); // Minimum scale

        // Calculate alpha fade (fade out at top and bottom edges)
        var alpha = 1.0;

        // Fade at top
        if (line_y < fade_distance) {
            alpha = line_y / fade_distance;
        }

        // Fade at bottom
        if (line_y > gui_height - fade_distance) {
            alpha = (gui_height - line_y) / fade_distance;
        }

        alpha = clamp(alpha, 0, 1);

        // Calculate y offset based on distance from center (perspective skew)
        var y_offset = distance_from_center * 20; // Slight vertical compression

        // Determine if this is a title line (all caps or special formatting)
        var is_title = (line == string_upper(line)) && (line != "") && (string_length(line) < 30);
        var text_scale = is_title ? 1.5 * perspective_factor : 1.0 * perspective_factor;

        // Draw the text with perspective
        draw_set_alpha(alpha);
        draw_set_color(col_text);

        // Add slight glow effect for titles
        if (is_title && alpha > 0.5) {
            // Draw glow (slightly larger, more transparent)
            draw_set_alpha(alpha * 0.3);
            draw_text_transformed(gui_width / 2, line_y + y_offset, line, text_scale * 1.1, text_scale * 1.1, 0);
        }

        // Draw main text
        draw_set_alpha(alpha);
        draw_text_transformed(gui_width / 2, line_y + y_offset, line, text_scale, text_scale, 0);
    }
}

// Draw control prompts in bottom-right corner (2 separate lines)
if (!credits_complete) {
    draw_set_alpha(0.5);
    draw_set_color(c_white);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);

    var prompt_x = gui_width - 20;
    var prompt_y = gui_height - 20;
    var line_spacing = 25;

    draw_text(prompt_x, prompt_y, "ESC to skip");
    draw_text(prompt_x, prompt_y - line_spacing, "Hold any key to speed up");
}

// Reset draw settings
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
