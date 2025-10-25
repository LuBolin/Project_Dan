event_inherited()
states_array[STATES.ALERT]  = new GhostAlertState(id);
states_array[STATES.CHASE]  = new GhostChaseState(id);
states_array[STATES.ATTACK] = new GhostAttackState(id);

attack_cooldown_sec = 1.25; // tweak this
attack_cd_timer = 0;        // counts down in frames