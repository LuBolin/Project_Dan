event_inherited()

// Please check scr_enemy_fsm_state
states_array[STATES.ALERT] = new AlertState(self);
states_array[STATES.CHASE] = new FoxChaseState(self);


function if_death() {
    // Check for death
    if (hp <= 0) {
        instance_destroy();
        var chi_struct
        for (var i = 0; i < 3; i += 1) {
            chi_struct = instance_create_depth(x, y, 0, obj_chi);
            chi_struct.x = random_range(x - obj_chi.sprite_width/2, x + obj_chi.sprite_width/2)
            chi_struct.y = random_range(y - obj_chi.sprite_height/2, y + obj_chi.sprite_height/2)
        }
        
        exit;
    }
}
