target_x = x;
target_y = y;

alarm[0] = 0;

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

// FSM related variables
is_player_detected = false
player_last_known_x = false
player_last_known_y = false
 
// Pauses all activity for the enemy
pause = false;

state = "roam"
