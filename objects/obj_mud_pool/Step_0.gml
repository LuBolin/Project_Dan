// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > game_get_speed(gamespeed_fps) * 5 - fade_in_duration) {
    alpha = min(1, alpha + (1 / fade_in_duration));
}
// Fade out near end
else if (!is_forever && life_timer <= fade_out_duration) {
    alpha = max(0, alpha - (1 / fade_out_duration));
}
// Fully visible in between
else {
    alpha = 1;
}

// Destroy when lifetime expires
if (!is_forever && life_timer <= 0) {
    // Clean up slowed enemies list
    ds_list_destroy(slowed_enemies);
    instance_destroy();
    exit;
}

// NEW: Keep radius in sync with scale (if scale changes externally)
aoe_radius = (aoe_base_diam * max(image_xscale, image_yscale)) * 0.5;

// Track which enemies are currently in the pool this frame
var enemies_in_pool = ds_list_create();

// Collect enemies using circular AoE
if (damage_enemies) {
    var enemy_list = ds_list_create();
    var n = collision_circle_list(x, y, aoe_radius, obj_enemy_abstract, false, true, enemy_list, false);
    for (var i = 0; i < n; i++) {
        var e = enemy_list[| i];
        if (instance_exists(e)) {
            ds_list_add(enemies_in_pool, e);
        }
    }
    ds_list_destroy(enemy_list);
}

// Check player using circular distance
if (damage_player && instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) <= aoe_radius) {
        ds_list_add(enemies_in_pool, obj_player);
    }
}

// Apply slow effect to entities in pool
for (var i = 0; i < ds_list_size(enemies_in_pool); i++) {
    var entity = enemies_in_pool[| i];
    
    // Apply slow effect using status effect system
    if (!variable_instance_exists(entity, "mud_pool_slow") || !entity.mud_pool_slow) {
        // Apply slow effect for 0.2 seconds (will be refreshed while in pool)
        var slow_duration = game_get_speed(gamespeed_fps) * 0.2; // 0.2 seconds
        add_status_effect(entity, new SlowEffect(slow_duration, slow_amount));
        entity.mud_pool_slow = true;
        
        // Add to tracked list
        if (ds_list_find_index(slowed_enemies, entity) == -1) {
            ds_list_add(slowed_enemies, entity);
        }
    } else {
        // Refresh slow effect while in pool
        var slow_duration = game_get_speed(gamespeed_fps) * 0.2;
        add_status_effect(entity, new SlowEffect(slow_duration, slow_amount));
    }
}

// Remove slow flag from enemies that left the pool
for (var i = ds_list_size(slowed_enemies) - 1; i >= 0; i--) {
    var entity = slowed_enemies[| i];
    
    // If entity no longer exists or is not in pool
    if (!instance_exists(entity) || ds_list_find_index(enemies_in_pool, entity) == -1) {
        if (instance_exists(entity) && variable_instance_exists(entity, "mud_pool_slow")) {
            entity.mud_pool_slow = false;
        }
        ds_list_delete(slowed_enemies, i);
    }
}

// Clean up temporary list
ds_list_destroy(enemies_in_pool);
