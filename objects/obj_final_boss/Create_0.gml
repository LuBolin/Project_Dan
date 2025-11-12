// Inherit the parent event
event_inherited();

states_array[STATES.ATTACK] = new FinalBossPhase_1(self);
states_array[STATES.CHASE] = new FinalBossPhase_2(self);

curr_state = STATES.ATTACK;

// Override the death function for the final boss
function if_death() {
    // Check for death
    if (hp <= 0) {
        // Spawn victory controller to handle the win sequence
        instance_create_depth(0, 0, -9999, obj_victory_controller);

        // Destroy the boss
        instance_destroy();
        exit;
    }
}
