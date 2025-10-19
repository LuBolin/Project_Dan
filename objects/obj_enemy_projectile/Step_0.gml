life_steps--;
if (life_steps <= 0) instance_destroy();

// Call on_step callback if it exists
if (variable_struct_exists(proj_data, "on_step")) {
    proj_data.on_step(self);
}

// Check for wall collision - always check, destroy by default
var check_dist = speed > 0 ? speed : 1;
if (place_meeting(x, y, layer_tilemap_get_id("Tile_Collision")) ||
    place_meeting(x + lengthdir_x(check_dist, direction), y + lengthdir_y(check_dist, direction), layer_tilemap_get_id("Tile_Collision"))) {
    // Call custom on_wall_hit if it exists, otherwise destroy by default
    if (variable_struct_exists(proj_data, "on_wall_hit")) {
        proj_data.on_wall_hit(self);
    } else {
        instance_destroy();
    }
}