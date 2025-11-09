if (spawn_cd <= 0 and distance_to_object(obj_player) < 30) {
    spawn_hazard()
    spawn_cd = spawn_freq;
}

spawn_cd -= delta_time / 1000000;