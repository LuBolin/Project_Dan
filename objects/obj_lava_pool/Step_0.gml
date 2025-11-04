// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > game_get_speed(gamespeed_fps) * 8 - fade_in_duration) {
    alpha = min(1, alpha + (1 / fade_in_duration));
}
// Fade out near end
else if (!is_forever and life_timer <= fade_out_duration) {
    alpha = max(0, alpha - (1 / fade_out_duration));
}
// Fully visible in between
else {
    alpha = 1;
}

// Glow animation
glow_timer += 0.1;

// Destroy when lifetime expires
if (!is_forever and life_timer <= 0) {
    ds_map_destroy(hit_cooldown_map);
    instance_destroy();
    exit;
}

// Damage tick logic
tick_counter++;
if (tick_counter >= tick_rate) {
    tick_counter = 0;
    
    var curr_time = current_time;
    var entities_to_check = [];
    
    // Determine which entities to damage based on configuration
    if (damage_enemies) {
        // Find all enemies overlapping with lava pool
        with (obj_enemy_abstract) {
            if (place_meeting(x, y, other)) {
                array_push(entities_to_check, id);
            }
        }
    }
    
    if (damage_player) {
        image_blend = make_color_rgb(255, 150, 150);
        // Check if player is overlapping with lava pool
        if (instance_exists(obj_player) && place_meeting(x, y, obj_player)) {
            array_push(entities_to_check, obj_player.id);
        }
    }

    // Process damage for all overlapping entities
    for (var i = 0; i < array_length(entities_to_check); i++) {
        var entity = entities_to_check[i];
        if (!instance_exists(entity)) continue;
        
        var entity_id = entity.id;
        var last_hit_time = ds_map_find_value(hit_cooldown_map, entity_id);
        
        // If never hit or cooldown expired (match tick_rate)
        if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= (tick_rate / game_get_speed(gamespeed_fps) * 1000))) {
            // Apply damage
            damage_entity(entity, damage_per_tick);
            
            // Record hit time
            ds_map_set(hit_cooldown_map, entity_id, curr_time);
            
            // Apply burn effect
            add_status_effect(entity, new BurnEffect(burn_duration, burn_damage));
            
            // Add "Burning" status text if entity supports it
            if (variable_instance_exists(entity, "status_texts") && is_array(entity.status_texts)) {
                if (array_get_index(entity.status_texts, "Burning") == -1) {
                    array_push(entity.status_texts, "Burning");
                }
            }
            
            show_debug_message("Lava pool damaged " + object_get_name(entity.object_index) + " " + string(entity_id));
        }
    }
}

// Clean up expired cooldowns from map
var key = ds_map_find_first(hit_cooldown_map);
while (!is_undefined(key)) {
    var next_key = ds_map_find_next(hit_cooldown_map, key);
    
    // If entity no longer exists, remove from map
    if (!instance_exists(key)) {
        ds_map_delete(hit_cooldown_map, key);
    }
    
    key = next_key;
}