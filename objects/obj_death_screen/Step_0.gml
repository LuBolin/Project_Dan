/// Death Screen - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check element slot hover and click
for (var i = 0; i < array_length(player_elements); i++) {
    var slot_x = element_start_x + i * (element_slot_size + element_slot_spacing);
    var slot_y = element_start_y;

    if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + element_slot_size, slot_y + element_slot_size)) {
        if (mouse_check_button_pressed(mb_left)) {
            selected_element_index = i;
        }
    }
}

// Check "Start Fresh" button hover and click
fresh_button_hover = point_in_rectangle(mx, my, fresh_button_x, fresh_button_y,
    fresh_button_x + fresh_button_width, fresh_button_y + button_height);

if (fresh_button_hover && mouse_check_button_pressed(mb_left)) {
    selected_element_index = -1; // Reset to "Start Fresh"
}

// Check "Start New Run" button hover and click
start_button_hover = point_in_rectangle(mx, my, start_button_x, start_button_y,
    start_button_x + button_width, start_button_y + button_height);

if (start_button_hover && mouse_check_button_pressed(mb_left)) {
    // Store the selected element for the next run
    if (selected_element_index >= 0 && selected_element_index < array_length(player_elements)) {
        global.carried_over_element = player_elements[selected_element_index];
    } else {
        global.carried_over_element = undefined;
    }

    // Reset game state
    global.level_progress = 1;

    // Clean up death inventory
    if (variable_global_exists("player_death_inventory")) {
        global.player_death_inventory = undefined;
    }

    // Clear mouse button state to prevent click carrying over to next room
    io_clear();

    // Destroy this death screen
    instance_destroy();

    // Start new run from Level0
    room_goto(Level0);
}

// Check "Main Menu" button hover and click
menu_button_hover = point_in_rectangle(mx, my, menu_button_x, menu_button_y,
    menu_button_x + button_width, menu_button_y + button_height);

if (menu_button_hover && mouse_check_button_pressed(mb_left)) {
    // Clean up
    if (variable_global_exists("player_death_inventory")) {
        global.player_death_inventory = undefined;
    }
    if (variable_global_exists("carried_over_element")) {
        global.carried_over_element = undefined;
    }

    // Clear mouse button state to prevent click carrying over to next room
    io_clear();

    // Destroy this death screen
    instance_destroy();

    // Go to main menu
    room_goto(MainMenu);
}
