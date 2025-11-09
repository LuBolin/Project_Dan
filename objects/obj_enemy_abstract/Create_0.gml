//colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract, obj_clay_wall];

// To prevent enemies from getting stuck on one another :<
colliders = [layer_tilemap_get_id("Tile_Collision"), obj_clay_wall];

if (!variable_instance_exists(self, "status_effects_list")) status_effects_list = [];
if (!variable_instance_exists(self, "invuln")) invuln = false;

// FSM related variables
player_last_known_x = undefined;
player_last_known_y = undefined;

// Status effects display
status_texts = []; // Array of status effect strings to display above enemy

// Please check scr_enemy_fsm_state
states_array = [];
states_array[STATES.ROAM] = new RoamState(self);
states_array[STATES.CHASE] = new ChaseState(self);
curr_state = undefined

depth = 0

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

// Path for more advanced pathfinding
path = path_add();
pause = false

plant_healing_pending = undefined