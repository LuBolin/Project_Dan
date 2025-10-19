/// Projectile - Destroy Event

// Call on_destroy callback if it exists
if (variable_struct_exists(proj_data, "on_destroy")) {
	proj_data.on_destroy(self);
}
