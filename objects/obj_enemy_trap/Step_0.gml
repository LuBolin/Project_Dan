if (!has_spawned && distance_to_object(obj_player) < 30) {
    my_trap = instance_nearest(x, y, obj_enemy_conditional_spawn_point); 
    if (instance_exists(my_trap)) {
        with(my_trap) {
            spawn_enemy()            
        }
    }
    has_spawned = true;
}

