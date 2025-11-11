/// Boss Retry Screen - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check "Retry" button hover and click
retry_button_hover = point_in_rectangle(mx, my, retry_button_x, retry_button_y,
    retry_button_x + button_width, retry_button_y + button_height);

if (retry_button_hover && mouse_check_button_pressed(mb_left)) {
    // Restore the inventory with Lightning converted back to Elixir (already done in player death)
    global.carried_over_element = undefined;

    // Reset run timer for this attempt
    if (instance_exists(obj_run_timer)) {
        obj_run_timer.run_time_seconds = global.run_time_seconds_saved;
        obj_run_timer.is_active = false;
    }

    // Store inventory and selected slot to restore after room restart
    global.boss_retry_inventory = player_inventory;
    global.boss_retry_sel_slot = player_sel_slot;

    // Clean up death inventory
    if (variable_global_exists("player_death_inventory")) {
        global.player_death_inventory = undefined;
    }
    if (variable_global_exists("player_death_sel_slot")) {
        global.player_death_sel_slot = undefined;
    }

    // Clear mouse button state
    io_clear();

    // Create new player at the boss room entrance position
    var new_player = instance_create_layer(144, 368, "Instances", obj_player);
    new_player.persistent = true;

    // Destroy this retry screen
    instance_destroy();

    // Restart the final boss room
    room_goto(Level_FinalBoss);
}

// Check "Give Up" button hover and click
giveup_button_hover = point_in_rectangle(mx, my, giveup_button_x, giveup_button_y,
    giveup_button_x + button_width, giveup_button_y + button_height);

if (giveup_button_hover && mouse_check_button_pressed(mb_left)) {
    // Clean up retry screen
    instance_destroy();

    // Create the standard death screen
    if (!instance_exists(obj_death_screen)) {
        instance_create_depth(0, 0, -9999, obj_death_screen);
    }
}
