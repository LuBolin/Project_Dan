/// Pause Menu Controller - Step Event

// Only process if paused and not in main menu
if (!is_paused || room == MainMenu) exit;

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// === VOLUME SLIDER INTERACTION ===
// Recalculate slider position (same as in Draw event)
var label_text = "Volume:";
var label_width = string_width(label_text);
var label_margin = 15;
var slider_start_x = volume_control_start_x + label_width + label_margin;
var volume_slider_width = volume_control_usable_width - label_width - label_margin - 40;

// Check if clicking on volume slider handle
var volume_handle_x = slider_start_x + (global.master_volume * volume_slider_width) - volume_slider_handle_width / 2;
var volume_handle_y = volume_slider_y - (volume_slider_handle_height - volume_slider_height) / 2;

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mx, my, volume_handle_x, volume_handle_y, volume_handle_x + volume_slider_handle_width, volume_handle_y + volume_slider_handle_height)) {
        volume_slider_dragging = true;
    }
}

if (mouse_check_button_released(mb_left)) {
    volume_slider_dragging = false;
}

// Update volume while dragging
if (volume_slider_dragging) {
    var new_volume = clamp((mx - slider_start_x) / volume_slider_width, 0, 1);
    global.master_volume = new_volume;
    audio_master_gain(global.master_volume);
}

// Check for button hover
hovered_button = -1;
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_x = center_x - button_width / 2;
    var btn_y = button_start_y + btn.y_offset;

    if (point_in_rectangle(mx, my, btn_x, btn_y, btn_x + button_width, btn_y + button_height)) {
        hovered_button = i;

        // Check for click
        if (mouse_check_button_pressed(mb_left)) {
            btn.action();
            mouse_clear(mb_left);
        }
        break;
    }
}
