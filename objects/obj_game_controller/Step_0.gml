// Game Controller - Step Event

// Check if player exists and is dead
if (instance_exists(obj_player) && obj_player.hp <= 0) {
    if (death_timer == 0) {
        death_timer = game_get_speed(gamespeed_fps) * 1; // 1 second
    } else {
        death_timer--;
        if (death_timer <= 0) {
            room_goto(MainMenu);
        }
    }
}
