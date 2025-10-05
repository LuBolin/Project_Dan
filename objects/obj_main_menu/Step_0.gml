/// Main Menu Controller - Step Event

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check for button hover
hovered_button = -1;
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_w = btn.width;
    var btn_h = btn.height;
    var btn_x = center_x + btn.x_offset - btn_w / 2;
    var btn_y = center_y + btn.y_offset - btn_h / 2;

    if (point_in_rectangle(mx, my, btn_x, btn_y, btn_x + btn_w, btn_y + btn_h)) {
        hovered_button = i;

        // Check for click
        if (mouse_check_button_pressed(mb_left)) {
            btn.action();
        }
        break;
    }
}
