// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > game_get_speed(gamespeed_fps) * 8 - fade_in_duration) {
    alpha = min(1, alpha + (1 / fade_in_duration));
}
// Fade out near end
else if (life_timer <= fade_out_duration) {
    alpha = max(0, alpha - (1 / fade_out_duration));
}
// Fully visible in between
else {
    alpha = 1;
}

// Glow animation
glow_timer += 0.1;

// Destroy when lifetime expires
if (life_timer <= 0) {
    // Remove burn effects from all affected enemies
    ds_map_destroy(hit_cooldown_map);
    instance_destroy();
    exit;
}

// Damage tick logic
tick_counter++;
if (tick_counter >= tick_rate) {
    tick_counter = 0;
    
    // Find all enemies overlapping with lava pool
    var enemy_list = ds_list_create();
    var num_enemies = 0;

    // Use collision to find all enemies overlapping
    with (obj_enemy_abstract) {
        if (place_meeting(x, y, other)) {
            ds_list_add(enemy_list, id);
            num_enemies++;
        }
    }

    if (num_enemies > 0) {
        show_debug_message("Lava pool damaging " + string(num_enemies) + " enemies");
    }

    var curr_time = current_time;
    
    for (var i = 0; i < num_enemies; i++) {
        var enemy = enemy_list[| i];
        var enemy_id = enemy.id;
        var last_hit_time = ds_map_find_value(hit_cooldown_map, enemy_id);
        
        // If never hit or cooldown expired (match tick_rate)
        if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= (tick_rate / game_get_speed(gamespeed_fps) * 1000))) {
            // Apply damage
            damage_entity(enemy, damage_per_tick);
            
            // Record hit time
            ds_map_set(hit_cooldown_map, enemy_id, curr_time);
            
            // Apply burn effect
            add_status_effect(enemy, new BurnEffect(burn_duration, burn_damage));
            
            // Add "Burning" status text if not already present
            if (variable_instance_exists(enemy, "status_texts")) {
                if (array_get_index(enemy.status_texts, "Burning") == -1) {
                    array_push(enemy.status_texts, "Burning");
                }
            }
        }
    }
    
    ds_list_destroy(enemy_list);
}

// Clean up expired cooldowns from map
var key = ds_map_find_first(hit_cooldown_map);
while (!is_undefined(key)) {
    var next_key = ds_map_find_next(hit_cooldown_map, key);
    
    // If enemy no longer exists, remove from map
    if (!instance_exists(key)) {
        ds_map_delete(hit_cooldown_map, key);
    }
    
    key = next_key;
}