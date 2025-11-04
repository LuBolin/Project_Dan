// Update status effects
update_status_effects(self);

if_death()

if (!pause) {
	if (attack_cd_timer > 0) attack_cd_timer -= 1;
    curr_state.step()
}
