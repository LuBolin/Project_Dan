life_steps--;
if (life_steps <= 0) instance_destroy();

// Call on_step callback if it exists
if (variable_struct_exists(proj_data, "on_step")) {
	proj_data.on_step(self);
}

// NEW: If this projectile uses circular collision, check it first
if (variable_instance_exists(self, "collision_radius") && collision_radius > 0) {
    // SAFE: Check if damage_enemies exists before reading
    var can_damage_enemies = variable_instance_exists(self, "damage_enemies") ? damage_enemies : false;
    var can_damage_player = variable_instance_exists(self, "damage_player") ? damage_player : false;

    // Check enemies using circle (for Current gust, Plant particles, etc.)
    if (can_damage_enemies) {
        var enemy_list = ds_list_create();
        var n = collision_circle_list(x, y, collision_radius, obj_enemy_abstract, false, true, enemy_list, false);
        for (var i = 0; i < n; i++) {
            var e = enemy_list[| i];
            if (instance_exists(e)) {
                if (is_struct(proj_data) && variable_struct_exists(proj_data, "on_hit"))
                    proj_data.on_hit(self, e);
            }
        }
        ds_list_destroy(enemy_list);
    }
    
    // Check player using circle
    if (can_damage_player && instance_exists(obj_player)) {
        if (point_distance(x, y, obj_player.x, obj_player.y) <= collision_radius) {
            if (is_struct(proj_data) && variable_struct_exists(proj_data, "on_hit"))
                proj_data.on_hit(self, obj_player);
        }
    }
    
    // Skip bbox collision checks if using circular
    exit;
}

// Check for wall collision - always check, destroy by default, include clay walls
var check_dist = speed > 0 ? speed : 1;
if (place_meeting(x, y, layer_tilemap_get_id("Tile_Collision")) ||
    place_meeting(x + lengthdir_x(check_dist, direction), y + lengthdir_y(check_dist, direction), layer_tilemap_get_id("Tile_Collision")) ||
    place_meeting(x, y, obj_clay_wall) ||
    place_meeting(x + lengthdir_x(check_dist, direction), y + lengthdir_y(check_dist, direction), obj_clay_wall)) {
    
    // Call custom on_wall_hit if it exists, otherwise destroy by default
    if (variable_struct_exists(proj_data, "on_wall_hit")) {
        proj_data.on_wall_hit(self);
    } else {
        instance_destroy();
    }
}
