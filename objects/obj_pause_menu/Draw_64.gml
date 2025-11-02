/// Pause Menu Controller - Draw GUI

// Don't draw in main menu or if not paused
if (!is_paused || room == MainMenu) exit;

// Update instructions based on current room
var current_instructions = "";
if (room == AlchemyRoom) {
    current_instructions = @"Drag elements from your inventory or new elements into the crafting area to synthesize!
    
Drag synthesized elements from the crafting area to your inventory or new elements to use them in combat
    
You can only carry at most only 3 elements inventory.";
} else if (room == Level0) {
    current_instructions = @"WASD - Move your character
Mouse - Aim
Left Click - Activate active element
Q/E or Mouse Wheel - Cycle active element
Enter door to access Alchemy Room";
} else {
    current_instructions = @"Use arrow keys or WASD to move.
Click to attack.";
}

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

// Draw title "PAUSED"
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(center_x, panel_y + 30, "PAUSED", 2, 2, 0);

// === DRAW VOLUME CONTROL ===
// Draw volume label
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_font(-1);
var label_text = "Volume:";
draw_text(volume_control_start_x, volume_label_y, label_text);

// Measure label width and add margin
var label_width = string_width(label_text);
var label_margin = 15;
var slider_start_x = volume_control_start_x + label_width + label_margin;

// Calculate slider width - use remaining space in usable area
var volume_slider_width = volume_control_usable_width - label_width - label_margin - 40; // 40 for percentage text
var percentage_text_width = 40;

// Draw volume slider background
draw_set_color(col_slider);
draw_rectangle(slider_start_x, volume_slider_y - volume_slider_height / 2, slider_start_x + volume_slider_width, volume_slider_y + volume_slider_height / 2, false);

// Draw volume slider border
draw_set_color(col_text);
draw_rectangle(slider_start_x, volume_slider_y - volume_slider_height / 2, slider_start_x + volume_slider_width, volume_slider_y + volume_slider_height / 2, true);

// Draw volume slider handle
var volume_handle_x = slider_start_x + (global.master_volume * volume_slider_width) - volume_slider_handle_width / 2;
var volume_handle_y = volume_slider_y - (volume_slider_handle_height - volume_slider_height) / 2;
draw_set_color(col_slider_handle);
draw_rectangle(volume_handle_x, volume_handle_y, volume_handle_x + volume_slider_handle_width, volume_handle_y + volume_slider_handle_height, false);
draw_set_color(col_text);
draw_rectangle(volume_handle_x, volume_handle_y, volume_handle_x + volume_slider_handle_width, volume_handle_y + volume_slider_handle_height, true);

// Draw volume percentage
var volume_percent = string(round(global.master_volume * 100));
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_text(slider_start_x + volume_slider_width + 10, volume_slider_y, volume_percent + "%");

// Draw instructions section
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_ext(panel_x + 40, panel_y + 140, "Instructions:\n\n" + current_instructions, 20, panel_width - 80);

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
