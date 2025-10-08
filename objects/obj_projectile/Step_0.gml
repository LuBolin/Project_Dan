life_steps--;
if (life_steps <= 0) instance_destroy();

// Call on_step callback if it exists
if (variable_struct_exists(proj_data, "on_step")) {
	proj_data.on_step(self);
}

// Check for wall collision if projectile has on_wall_hit callback
if (variable_struct_exists(proj_data, "on_wall_hit")) {
	// Check if currently touching a wall or about to hit one
	var check_dist = speed > 0 ? speed : 1;
	if (place_meeting(x, y, layer_tilemap_get_id("Tile_Collision")) ||
	    place_meeting(x + lengthdir_x(check_dist, direction), y + lengthdir_y(check_dist, direction), layer_tilemap_get_id("Tile_Collision"))) {
		proj_data.on_wall_hit(self);
	}
}