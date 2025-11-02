/// Death Screen - Draw GUI

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
    // Draw white text on top
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}

// Draw semi-transparent overlay
draw_set_alpha(0.8);
draw_set_color(col_overlay);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw panel background
draw_set_color(col_panel_bg);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);

// Draw panel border
draw_set_color(col_panel_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);

// Draw title "YOU DIED"
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(panel_x + panel_width / 2, panel_y + 30, "YOU DIED", 2, 2, 0);

// Draw instruction text
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var instruction_y = panel_y + 80;
draw_text(panel_x + panel_width / 2, instruction_y, "Choose one option to continue:");

// Draw element slots (3 player elements + "Bring nothing")
for (var i = 0; i < 4; i++) {
    var slot_x = element_start_x + i * (element_slot_size + element_slot_spacing);
    var slot_y = element_start_y;
    var is_selected = (selected_element_index == i);

    // Determine slot content and color
    var slot_text = "";
    var slot_color = col_button;

    if (i < array_length(player_elements)) {
        // Player element slot
        var element = player_elements[i];
        slot_text = element.name;
        slot_color = element.color;
    } else if (i == bring_nothing_index) {
        // "Bring nothing" slot
        slot_text = "Bring\nnothing";
        slot_color = col_button;
    }

    // Draw slot background
    draw_set_color(slot_color);
    draw_rectangle(slot_x, slot_y, slot_x + element_slot_size, slot_y + element_slot_size, false);

    // Draw slot border (thicker if selected)
    if (is_selected) {
        draw_set_color(col_button_selected);
        for (var border = 0; border < 4; border++) {
            draw_rectangle(slot_x - border, slot_y - border,
                slot_x + element_slot_size + border, slot_y + element_slot_size + border, true);
        }
    } else {
        draw_set_color(col_panel_border);
        draw_rectangle(slot_x, slot_y, slot_x + element_slot_size, slot_y + element_slot_size, true);
    }

    // Draw slot text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_outlined(slot_x + element_slot_size / 2, slot_y + element_slot_size / 2, slot_text);
}

// Draw separator line
var separator_y = element_start_y + element_slot_size + 40;
draw_set_color(col_panel_border);
draw_line_width(panel_x + 50, separator_y, panel_x + panel_width - 50, separator_y, 2);

// Draw "Start New Run" button
var can_start = (selected_element_index >= 0);
var start_col = col_button;

// Determine button color based on state
if (!can_start) {
    start_col = make_color_rgb(40, 40, 50); // Disabled/grayed out
} else if (start_button_hover) {
    start_col = col_button_hover;
}

draw_set_color(start_col);
draw_rectangle(start_button_x, start_button_y, start_button_x + button_width, start_button_y + button_height, false);
draw_set_color(col_panel_border);
draw_rectangle(start_button_x, start_button_y, start_button_x + button_width, start_button_y + button_height, true);

// Draw button text
var text_col = can_start ? col_text : make_color_rgb(100, 100, 110); // Dimmed text when disabled
draw_set_color(text_col);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var start_text = "Start New Run";
if (selected_element_index >= 0 && selected_element_index < array_length(player_elements)) {
    start_text += "\n(with " + player_elements[selected_element_index].name + ")";
} else if (selected_element_index == bring_nothing_index) {
    start_text += "\n(with nothing)";
}
draw_text(start_button_x + button_width / 2, start_button_y + button_height / 2, start_text);

// Draw "Main Menu" button
var menu_col = menu_button_hover ? col_button_hover : col_button;
draw_set_color(menu_col);
draw_rectangle(menu_button_x, menu_button_y, menu_button_x + button_width, menu_button_y + button_height, false);
draw_set_color(col_panel_border);
draw_rectangle(menu_button_x, menu_button_y, menu_button_x + button_width, menu_button_y + button_height, true);

draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(menu_button_x + button_width / 2, menu_button_y + button_height / 2, "Main Menu");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
