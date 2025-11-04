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

// Check for enemies colliding with the mud pool
var enemy_list = ds_list_create();
var num_enemies = 0;

if (damage_enemies) {
    // Use collision_rectangle to find all enemies overlapping with the mud pool's bounding box
    with (obj_enemy_abstract) {
        // Check if enemy's collision box overlaps with mud pool's collision box
        if (place_meeting(x, y, other)) {
            ds_list_add(enemy_list, id);
            num_enemies++;
        }
    }
}

if (damage_player && instance_exists(obj_player)) {
    with (obj_player) {
        if (place_meeting(x, y, other)) {
            ds_list_add(enemy_list, id);
            num_enemies++;
        }
    }
}

// Track which enemies are currently in the pool this frame
var enemies_in_pool = ds_list_create();

for (var i = 0; i < num_enemies; i++) {
    var enemy = enemy_list[| i];
    ds_list_add(enemies_in_pool, enemy);

    // Apply slow effect using status effect system
    if (!variable_instance_exists(enemy, "mud_pool_slow") || !enemy.mud_pool_slow) {
        // Apply slow effect for 0.2 seconds (will be refreshed while in pool)
        var slow_duration = game_get_speed(gamespeed_fps) * 0.2; // 0.2 seconds
        add_status_effect(enemy, new SlowEffect(slow_duration, slow_amount));
        
        enemy.mud_pool_slow = true;
        show_debug_message("Applied slow effect to enemy " + string(enemy.id));

        // Add "Slowed" status text
        if (variable_instance_exists(enemy, "status_texts")) {
            if (array_get_index(enemy.status_texts, "Slowed") == -1) {
                array_push(enemy.status_texts, "Slowed");
            }
        }
        
        ds_list_add(slowed_enemies, enemy);
    } else {
        // Refresh slow effect for enemies still in pool
        var slow_duration = game_get_speed(gamespeed_fps) * 0.2;
        add_status_effect(enemy, new SlowEffect(slow_duration, slow_amount));
    }
}

// Remove slow flag from enemies that left the pool
for (var i = ds_list_size(slowed_enemies) - 1; i >= 0; i--) {
    var enemy = slowed_enemies[| i];

    // If enemy left the pool or was destroyed
    if (!instance_exists(enemy) || ds_list_find_index(enemies_in_pool, enemy) == -1) {
        if (instance_exists(enemy) && variable_instance_exists(enemy, "mud_pool_slow")) {
            enemy.mud_pool_slow = false;

            // Remove "Slowed" status text
            if (variable_instance_exists(enemy, "status_texts")) {
                var slowed_index = array_get_index(enemy.status_texts, "Slowed");
                if (slowed_index != -1) { 
                    array_delete(enemy.status_texts, slowed_index, 1);
                }
            }
        }
        ds_list_delete(slowed_enemies, i);
    }
}

ds_list_destroy(enemy_list);
ds_list_destroy(enemies_in_pool);
