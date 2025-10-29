// Update status effects
update_status_effects(self);

if_death();

if (!pause && !is_undefined(curr_state)) {
    curr_state.step();
} else {
    path_end();
}

