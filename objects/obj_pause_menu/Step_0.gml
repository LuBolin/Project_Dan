/// Pause Menu Controller - Step Event

// Only process if paused and not in main menu
if (!is_paused || room == MainMenu) exit;

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

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
        }
        break;
    }
}
