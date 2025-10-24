event_inherited()
has_charged = false;

// Please check scr_enemy_fsm_state
states_array[STATES.ALERT] = new BoarAlertState(self, 8, true);
states_array[STATES.CHASE] = new BoarChaseState(self, 20, true);
states_array[STATES.ATTACK] = new BoarAttackState(self, 38, true);