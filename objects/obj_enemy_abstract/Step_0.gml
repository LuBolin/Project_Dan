if (!pause) {
    if (chase) {
        target_x = obj_player.x
        target_y = obj_player.y
    }

    var _hor = clamp(target_x - x, -1, 1)
    var _vert = clamp(target_y - y, -1, 1)

    var magnitude = sqrt(_hor * _hor + _vert * _vert)

    if (magnitude != 0) {
        var _norm_hor = (_hor / magnitude) * move_speed + knockback_x;
        var _norm_vert = (_vert / magnitude) * move_speed + knockback_y;

        move_and_collide(_norm_hor, _norm_vert, colliders)
    }

}

