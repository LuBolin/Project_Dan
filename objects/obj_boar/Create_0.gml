event_inherited()
is_charging = false;
has_charged = false;

// Please check scr_enemy_fsm_state
states_array[STATES.ALERT] = new BoarAlertState(self);
states_array[STATES.CHASE] = new BoarChaseState(self);
states_array[STATES.ATTACK] = new BoarAttackState(self);