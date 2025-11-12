/// Pause Menu Controller - Escape Key Press

// Don't pause in main menu
if (room == MainMenu) exit;

// Don't pause during victory credits
if (instance_exists(obj_victory_credits)) exit;

// Toggle pause state
is_paused = !is_paused;

if (is_paused) {
    // Deactivate all instances except pause menu
    instance_deactivate_all(true);
    instance_activate_object(obj_pause_menu);
} else {
    // Reactivate all instances
    instance_activate_all();

    // In alchemy room, player should remain deactivated
    if (room == AlchemyRoom && instance_exists(obj_player)) {
        instance_deactivate_object(obj_player);
    }
}
