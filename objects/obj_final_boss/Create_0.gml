// Inherit the parent event
event_inherited();

states_array[STATES.ATTACK] = new FinalBossPhase_1(self);
states_array[STATES.CHASE] = new FinalBossPhase_2(self);

curr_state = STATES.ATTACK;