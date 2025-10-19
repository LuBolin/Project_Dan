// Update status effects
update_status_effects(self);

// Check for death
if (hp <= 0) {
    instance_destroy();
    instance_create_depth(x, y, 0, obj_chi);
    exit;
}

if (!pause) {
    curr_state.step()
}

