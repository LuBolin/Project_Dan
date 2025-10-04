/// Pause Menu Controller - Escape Key Press

// Don't pause in main menu
if (room == MainMenu) exit;

// Toggle pause state
is_paused = !is_paused;

if (is_paused) {
    // Deactivate all instances except pause menu
    instance_deactivate_all(true);
    instance_activate_object(obj_pause_menu);
} else {
    // Reactivate all instances
    instance_activate_all();
}
