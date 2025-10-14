event_inherited()
states_array[STATES.ALERT]  = new GhostAlertState(id, 18, true);
states_array[STATES.CHASE]  = new GhostChaseState(id, 8, true);
states_array[STATES.ATTACK] = new GhostAttackState(id, 18, true);

attack_cooldown_sec = 1.25; // tweak this
attack_cd_timer = 0;        // counts down in frames