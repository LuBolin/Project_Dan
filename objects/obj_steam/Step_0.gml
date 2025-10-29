/// Steam Cloud - Step Event

// Follow the owner (player)
if (instance_exists(owner)) {
    x = owner.x;
    y = owner.y;
} else {
    // Owner destroyed, remove steam
    instance_destroy();
    exit;
}

// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > life_duration - fade_in_duration) {
    image_alpha = min(0.7, image_alpha + (0.7 / fade_in_duration));
}
// Fade out near end
else if (life_timer <= fade_out_duration) {
    image_alpha = max(0, image_alpha - (0.7 / fade_out_duration));
}
// Fully visible in between
else {
    image_alpha = 0.7; // Semi-transparent
}

// Rotate for visual effect
image_angle += rotation_speed;

// Damage tick logic
tick_counter++;
if (tick_counter >= tick_rate) {
    tick_counter = 0;

    var curr_time = current_time;

    // Use instance_place_list to find all enemies overlapping with steam's collision circle
    var enemy_list = ds_list_create();
    var collision_box_radius = collision_radius;

    // Check all enemies in range using a rectangular area check first
    var check_area_x1 = x - collision_box_radius;
    var check_area_y1 = y - collision_box_radius;
    var check_area_x2 = x + collision_box_radius;
    var check_area_y2 = y + collision_box_radius;

    var num_enemies = collision_rectangle_list(check_area_x1, check_area_y1, check_area_x2, check_area_y2, 
        instance_exists(obj_player) && owner == obj_player ? obj_enemy_abstract : obj_player, false, true, enemy_list, false);

    // Process each enemy in the collision area
    for (var i = 0; i < num_enemies; i++) {
        var enemy = enemy_list[| i];
        var enemy_id = enemy.id;
        var last_hit_time = ds_map_find_value(hit_cooldown_map, enemy_id);

        // Check if enemy is within the circular collision radius
        var distance = point_distance(enemy.x, enemy.y, x, y);
        if (distance <= collision_box_radius) {
            // If never hit or cooldown expired (0.5 seconds)
            if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= 500)) {
                // Apply damage
                if (instance_exists(enemy)) {
                    damage_entity(enemy, damage_per_tick);

                    // Record hit time
                    ds_map_set(hit_cooldown_map, enemy_id, curr_time);

                    // Apply burn effect for 1 second
                    add_status_effect(enemy, new BurnEffect(game_get_speed(gamespeed_fps) * 1, damage_per_tick));

                    // Apply 20% slow effect for 1 second
                    add_status_effect(enemy, new SlowEffect(game_get_speed(gamespeed_fps) * 1, 0.2));
                }
            }
        }
    }

    ds_list_destroy(enemy_list);

    // Clean up cooldown entries for dead enemies (only on damage ticks to avoid excessive checking)
    var keys_to_delete = ds_list_create();
    var key = ds_map_find_first(hit_cooldown_map);
    while (!is_undefined(key)) {
        if (!instance_exists(key)) {
            ds_list_add(keys_to_delete, key);
        }
        key = ds_map_find_next(hit_cooldown_map, key);
    }

    // Delete the dead enemy entries
    for (var i = 0; i < ds_list_size(keys_to_delete); i++) {
        ds_map_delete(hit_cooldown_map, keys_to_delete[| i]);
    }
    ds_list_destroy(keys_to_delete);
}

// Destroy when lifetime expires
if (life_timer <= 0) {
    instance_destroy();
}