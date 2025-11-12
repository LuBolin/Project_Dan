event_inherited()
states_array[STATES.ALERT]  = new GhostAlertState(id);
states_array[STATES.CHASE]  = new GhostChaseState(id);
states_array[STATES.ATTACK] = new GhostAttackState(id);

attack_cooldown_sec = 1.25; // tweak this
attack_cd_timer = 0;        // counts down in frames

// Scale sprite to match original size (64x64 from 128x128)
image_xscale = 0.5;
image_yscale = 0.5;
sprite_face_dir = -1; // ghost sprite faces left by default