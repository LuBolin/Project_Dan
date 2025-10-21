target_x = random_range(xstart - 100, xstart + 100);
target_y = random_range(ystart - 100, ystart + 100);

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

// FSM related variables
player_last_known_x = undefined;
player_last_known_y = undefined;

// Pauses all activity for the enemy
pause = true;

// Status effects display
status_texts = []; // Array of status effect strings to display above enemy

// Please check scr_enemy_fsm_state
states_array[STATES.ROAM] = new RoamState(self, 20, true);
states_array[STATES.CHASE] = new ChaseState(self, 120, true);
curr_state = undefined

function if_death() {
    // Check for death
    if (hp <= 0) {
        instance_destroy();
        instance_create_depth(x, y, 0, obj_chi);
        exit;
    }
}

function changeState(next_state) {
    curr_state.leave()
    curr_state = states_array[next_state]
    curr_state.enter()
}

// Effect Sprite for Burn Effect, etc
// Switch to a Hashmap or sth if needed 
effect_sprite = undefined