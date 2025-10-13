// Update status effects
update_status_effects(self);

// Check for death
if (hp <= 0) {
    instance_destroy();
    exit;
}

if (!pause) {
    
    // Chase Behaviour
    if (instance_exists(obj_player) && is_player_detected) {
        target_x = player_last_known_x
        target_y = player_last_known_y
        state = "chase"
    } else {
        state = "roam"
    }

    var _hor = clamp(target_x - x, -1, 1)
    var _vert = clamp(target_y - y, -1, 1)

    var magnitude = sqrt(_hor * _hor + _vert * _vert)

    if (magnitude != 0) {
        // Convert units per second to pixels per frame
        // units/sec * pixels/unit / frames/sec = pixels/frame
        var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);

        var _norm_hor = (_hor / magnitude) * move_speed_this_frame;
        var _norm_vert = (_vert / magnitude) * move_speed_this_frame;

        move_and_collide(_norm_hor, _norm_vert, colliders)
    }

}

