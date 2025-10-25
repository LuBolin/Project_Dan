// Call the on_hit function from the projectile's struct data
if (variable_instance_exists(self, "proj_data") && is_struct(proj_data) && variable_struct_exists(proj_data, "on_hit")) {
	proj_data.on_hit(self, other);
    other.curr_state.player_interact()
}
