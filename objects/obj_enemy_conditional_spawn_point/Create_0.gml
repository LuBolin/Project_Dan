/// Enemy Spawn Point - Create Event
// This object marks where enemies can spawn
// The level manager will use these to spawn enemies based on difficulty

// Mark as inactive after spawning
is_used = false;

check_adjacent = []
if (check_adjacent_enemies) {
    array_push(check_adjacent, obj_enemy_abstract);
}

if (check_adjacent_player) {
    array_push(check_adjacent, obj_player);
}

function _spawn_enemy() {
    if (array_length(check_adjacent) == 0 || collision_circle(x, y, 30, check_adjacent, false, true) == noone) {
    
        // Spawn enemy at spawn point
        var enemy = instance_create_depth(other.x, other.y, 0, enemy_to_spawn);
    
        enemy.curr_state = enemy.states_array[STATES.ROAM];
        enemy.curr_state.enter();
        
    
    }
}

function spawn_enemy() {
    if (array_length(check_adjacent) == 0 || collision_circle(x, y, 30, check_adjacent, false, true) == noone) {
        var telegraphing = instance_create_layer(x, y, "Instances", obj_telegraph_attack); 
        if (instance_exists(telegraphing)) { 
            telegraphing.init_telegraph_attack(_spawn_enemy, c_red, 20);
        } else {
            show_debug_message("ERROR: Telegraphing failed due to invalid spawn coordinates!") 
        }
    }
    
}
