if (spawn_cd <= 0 && (!is_player_activated || (is_player_activated && distance_to_object(obj_player) < 30))) {
    spawn_hazard()
    spawn_cd = spawn_freq + delay;
}

spawn_cd -= delta_time / 1000000;