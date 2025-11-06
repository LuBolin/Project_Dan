/// Run Timer - Step

// Global pause conditions
var paused = false;
paused |= (instance_exists(obj_pause_menu) && obj_pause_menu.is_paused);
paused |= instance_exists(obj_cutscene_manager);
paused |= instance_exists(obj_death_screen);
paused |= (room == AlchemyRoom) || (room == MainMenu);

// Only advance when active and not paused
if (is_active && !paused) {
    run_time_seconds += (delta_time / 1000000); // microseconds -> seconds
}

// Persist so room changes won't reset
global.run_time_seconds_saved = run_time_seconds;