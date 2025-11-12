event_inherited()
has_charged = false;
is_charging = false;

is_miniboss = true;

// Scale up the sprite to 1.5x size
image_xscale = 1.5;
image_yscale = 1.5;
sprite_face_dir = -1; // miniboss boar sprite faces left by default

// Use custom Fire Boar states
states_array[STATES.ROAM] = new FireBoarRoamState(self)
states_array[STATES.ALERT] = new FireBoarAlertState(self);
states_array[STATES.CHASE] = new FireBoarChaseState(self);
states_array[STATES.ATTACK] = new FireBoarAttackState(self);

function if_death() {
    if (hp <= 0) {
        global.defeated_miniboss_sprite = sprite_index;
        trigger_miniboss_defeat_cutscene();
        instance_destroy();
        exit;
    }
}

invuln = false;