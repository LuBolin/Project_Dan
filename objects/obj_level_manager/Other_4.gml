// Room Start event - count all enemies
total_enemies = instance_number(obj_enemy_abstract);
current_kills = 0;
required_kills = ceil(total_enemies * kill_percentage);

// Update exit door with required kills
var exit_door = instance_find(obj_exit_dungeon_door, 0);
if (instance_exists(exit_door)) {
    exit_door.to_kill = required_kills;
}

enemy_count_complete = true;
