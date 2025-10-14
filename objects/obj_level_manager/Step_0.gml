// Track enemy kills by counting how many are left
if (enemy_count_complete) {
    var enemies_alive = instance_number(obj_enemy_abstract);
    current_kills = total_enemies - enemies_alive;

    // Update exit door's to_kill value
    var exit_door = instance_find(obj_exit_dungeon_door, 0);
    if (instance_exists(exit_door)) {
        exit_door.to_kill = max(0, required_kills - current_kills);
    }
}
