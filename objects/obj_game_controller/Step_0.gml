// Game Controller - Step Event

// Toggle hitbox drawing with H key
if (keyboard_check_pressed(ord("H"))) {
    global.debug_draw_collisions = !global.debug_draw_collisions;
    show_debug_message("Hitbox drawing: " + (global.debug_draw_collisions ? "ON" : "OFF"));
}

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
