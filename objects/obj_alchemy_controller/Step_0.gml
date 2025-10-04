/// Alchemy Controller - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// === DRAG & DROP SYSTEM ===

// Start dragging
if (mouse_check_button_pressed(mb_left) && !dragging) {
    // Check if clicking on any draggable item
    for (var i = 0; i < array_length(draggable_items); i++) {
        var item = draggable_items[i];

        if (point_in_rectangle(mx, my, item.x, item.y, item.x + item.w, item.y + item.h)) {
            dragging = true;
            drag_item = i;
            drag_offset_x = mx - item.x;
            drag_offset_y = my - item.y;
            break;
        }
    }
}

// Stop dragging
if (mouse_check_button_released(mb_left) && dragging) {
    // Update item position to where it was dropped
    var item = draggable_items[drag_item];
    item.x = mx - drag_offset_x;
    item.y = my - drag_offset_y;

    // Clamp to main panel bounds
    item.x = clamp(item.x, main_panel_x, main_panel_x + main_panel_w - item.w);
    item.y = clamp(item.y, main_panel_y, main_panel_y + main_panel_h - item.h);

    dragging = false;
    drag_item = noone;
}

// === SCROLLING SYSTEM ===

// Check if mouse is in scroll area
var tree_start_y = side_panel_y + 60;
var tree_end_y = button_y - 20;

if (point_in_rectangle(mx, my, side_panel_x, tree_start_y, side_panel_x + side_panel_w, tree_end_y)) {
    var wheel = mouse_wheel_down() - mouse_wheel_up();
    scroll_offset += wheel * scroll_speed;
    scroll_offset = clamp(scroll_offset, 0, scroll_max);
}

// === CONTINUE BUTTON ===
// Check hover state
button_hover = point_in_rectangle(mx, my, button_x, button_y, button_x + button_w, button_y + button_h);

// Check click
if (button_hover && mouse_check_button_pressed(mb_left)) {
    // Clear mouse button state to prevent click carrying over to next room
    io_clear();
    room_goto(GameSandbox);
}
