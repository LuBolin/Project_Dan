target_x = random_range(xstart - 100, xstart + 100);
target_y = random_range(ystart - 100, ystart + 100);

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

// FSM related variables
player_last_known_x = undefined;
player_last_known_y = undefined;
 
// Pauses all activity for the enemy
pause = false;

// Please check scr_enemy_fsm_state
states_array[STATES.ROAM] = new RoamState(self, 20, true);
states_array[STATES.CHASE] = new ChaseState(self, 120, true);
//states_array[STATES.ATTACK] = new AttackState(self, -1, false);

curr_state = states_array[STATES.ROAM];
curr_state.enter();