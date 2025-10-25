event_inherited()

states_array[STATES.ROAM] = new EvilTreeRoamState(self);
states_array[STATES.ALERT] = new AlertState(self);
states_array[STATES.CHASE] = new EvilTreeChaseState(self);
states_array[STATES.ATTACK] = new GhostAttackState(self);

attack_cooldown_sec = 1.25; // tweak this
attack_cd_timer = 0;        // counts down in frames