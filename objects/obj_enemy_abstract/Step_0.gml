// Update status effects
update_status_effects(self);

// Check for death
if (hp <= 0) {
    instance_destroy();
    exit;
}

if (!pause) {
    curr_state.step()
}

