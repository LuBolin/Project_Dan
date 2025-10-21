event_inherited()

states_array[STATES.ROAM] = new EvilTreeRoamState(self, undefined, false);
states_array[STATES.ALERT] = new AlertState(self, 18, true);
states_array[STATES.CHASE] = new EvilTreeChaseState(self, 120, true);
states_array[STATES.ATTACK] = new GhostAttackState(self, 18, true);

attack_cooldown_sec = 1.25; // tweak this
attack_cd_timer = 0;        // counts down in frames