target_x = xstart;
target_y = ystart;

alarm[0] = 1;

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

// FSM related variables
is_player_detected = false;
player_last_known_x = false;
player_last_known_y = false;
 
// Pauses all activity for the enemy
pause = false;

state = STATES.ROAM;

states_array[STATES.ROAM] = new RoamState(self, 300, true)
states_array[STATES.CHASE] = new ChaseState(self, 200, true)


curr_state = states_array[state]
