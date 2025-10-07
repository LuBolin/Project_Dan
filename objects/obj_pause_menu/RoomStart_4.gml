/// Pause Menu Controller - Room Start Event

// Destroy pause menu in MainMenu
if (room == MainMenu) {
    instance_destroy();
    exit;
}

// Unpause when entering any room
is_paused = false;
instance_activate_all();
