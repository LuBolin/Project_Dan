// Update status effects
update_status_effects(self);

// Check for death
if (hp <= 0) {
    instance_destroy();
    exit;
}

if (!pause) {
	if (attack_cd_timer > 0) attack_cd_timer -= 1;
    curr_state.step()
}
