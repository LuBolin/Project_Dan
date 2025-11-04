/// Death Screen - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check element slot hover and click (first 3 slots are player elements)
for (var i = 0; i < array_length(player_elements); i++) {
    var slot_x = element_start_x + i * (element_slot_size + element_slot_spacing);
    var slot_y = element_start_y;

    if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + element_slot_size, slot_y + element_slot_size)) {
        if (mouse_check_button_pressed(mb_left)) {
            selected_element_index = i;
        }
    }
}

// Check "Bring nothing" button (4th slot) hover and click
var bring_nothing_x = element_start_x + bring_nothing_index * (element_slot_size + element_slot_spacing);
var bring_nothing_y = element_start_y;
bring_nothing_hover = point_in_rectangle(mx, my, bring_nothing_x, bring_nothing_y,
    bring_nothing_x + element_slot_size, bring_nothing_y + element_slot_size);

if (bring_nothing_hover && mouse_check_button_pressed(mb_left)) {
    selected_element_index = bring_nothing_index; // Select "Bring nothing"
}

// Check "Start New Run" button hover and click
start_button_hover = point_in_rectangle(mx, my, start_button_x, start_button_y,
    start_button_x + button_width, start_button_y + button_height);

// Only allow clicking start button if an option is selected
var can_start = (selected_element_index >= 0);

if (start_button_hover && can_start && mouse_check_button_pressed(mb_left)) {
    // Store the selected element for the next run
    if (selected_element_index == bring_nothing_index) {
        // "Bring nothing" selected
        global.carried_over_element = undefined;
    } else if (selected_element_index >= 0 && selected_element_index < array_length(player_elements)) {
        // Element selected
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
