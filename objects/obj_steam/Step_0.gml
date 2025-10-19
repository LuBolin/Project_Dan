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
    
    // Find all enemies overlapping with steam cloud
    var enemy_list = ds_list_create();
    var num_enemies = instance_place_list(x, y, obj_enemy_abstract, enemy_list, false);
    
    var curr_time = current_time;
    
    for (var i = 0; i < num_enemies; i++) {
        var enemy = enemy_list[| i];
        var enemy_id = enemy.id;
        var last_hit_time = ds_map_find_value(hit_cooldown_map, enemy_id);
        
        // If never hit or cooldown expired (0.5 seconds)
        if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= 500)) {
            // Apply damage
            damage_entity(enemy, damage_per_tick);
            
            // Record hit time
            ds_map_set(hit_cooldown_map, enemy_id, curr_time);
            
            // Optional: Apply burn effect for 1 second
            add_status_effect(enemy, new BurnEffect(game_get_speed(gamespeed_fps) * 1, damage_per_tick));
        }
    }
    
    ds_list_destroy(enemy_list);
}

// Clean up expired cooldowns from map (enemies that died or left)
var key = ds_map_find_first(hit_cooldown_map);
while (!is_undefined(key)) {
    var next_key = ds_map_find_next(hit_cooldown_map, key);
    
    // If enemy no longer exists, remove from map
    if (!instance_exists(key)) {
        ds_map_delete(hit_cooldown_map, key);
    }
    
    key = next_key;
}

// Destroy when lifetime expires
if (life_timer <= 0) {
    instance_destroy();
}