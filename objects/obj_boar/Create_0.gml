event_inherited()
is_charging = false;
has_charged = false;
sprite_face_dir = -1; // boar sprite faces left by default

// Please check scr_enemy_fsm_state
states_array[STATES.ALERT] = new BoarAlertState(self);
states_array[STATES.CHASE] = new BoarChaseState(self);
states_array[STATES.ATTACK] = new BoarAttackState(self);