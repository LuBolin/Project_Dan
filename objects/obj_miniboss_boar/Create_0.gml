event_inherited()
has_charged = false;

// Fire Boar specific variables
fireball_cooldown = 0; // Cooldown for shooting fireballs
fireball_cooldown_max = 90; // 1.5 seconds at 60 fps
is_miniboss = true;

// Scale up the sprite to 1.5x size
image_xscale = 1.5;
image_yscale = 1.5;

// Use custom Fire Boar states
states_array[STATES.ROAM] = new FireBoarRoamState(self)
states_array[STATES.ALERT] = new FireBoarAlertState(self);
states_array[STATES.CHASE] = new FireBoarChaseState(self);
states_array[STATES.ATTACK] = new FireBoarAttackState(self);