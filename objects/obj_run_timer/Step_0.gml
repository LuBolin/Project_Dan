// Only increment timer if active and game is not paused
if (is_active) {
    var is_paused = false;
    
    // Check if pause menu exists and is paused
    if (instance_exists(obj_pause_menu)) {
        is_paused = obj_pause_menu.is_paused;
    }
    
    // Don't increment if paused or in alchemy room
    if (!is_paused && room != AlchemyRoom && room != MainMenu) {
        run_time_seconds += delta_time / 1000000; // Convert microseconds to seconds
    }
}