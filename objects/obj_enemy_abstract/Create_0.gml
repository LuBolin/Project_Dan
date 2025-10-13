target_x = random_range(xstart - 100, xstart + 100);
target_y = random_range(ystart - 100, ystart + 100);

alarm[0] = 1;

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

// FSM related variables
player_last_known_x = false;
player_last_known_y = false;
 
// Pauses all activity for the enemy
pause = false;

state = STATES.ROAM;

states_array[STATES.ROAM] = new RoamState(self, 20, true)
states_array[STATES.CHASE] = new ChaseState(self, 15, true)


curr_state = states_array[state]
