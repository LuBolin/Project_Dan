/// Mud Pool - Step Event

// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > game_get_speed(gamespeed_fps) * 5 - fade_in_duration) {
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

// Destroy when lifetime expires
if (life_timer <= 0) {
    // Remove slow effect from all affected enemies
    for (var i = 0; i < ds_list_size(slowed_enemies); i++) {
        var enemy = slowed_enemies[| i];
        if (instance_exists(enemy) && variable_instance_exists(enemy, "mud_pool_slow")) {
            // Restore speed
            enemy.move_speed_ups /= (1 - slow_amount);
            delete enemy.mud_pool_slow;

            // Remove "Slowed" status text
            var slowed_index = array_get_index(enemy.status_texts, "Slowed");
            if (slowed_index != -1) {
                array_delete(enemy.status_texts, slowed_index, 1);
            }
        }
    }
    ds_list_destroy(slowed_enemies);
    instance_destroy();
    exit;
}

// Check for enemies colliding with the mud pool
var enemy_list = ds_list_create();
var num_enemies = 0;

// Use collision_rectangle to find all enemies overlapping with the mud pool's bounding box
with (obj_enemy_abstract) {
    // Check if enemy's collision box overlaps with mud pool's collision box
    if (place_meeting(x, y, other)) {
        ds_list_add(enemy_list, id);
        num_enemies++;
    }
}

if (num_enemies > 0) {
    show_debug_message("Mud pool detecting " + string(num_enemies) + " enemies");
}

// Track which enemies are currently in the pool this frame
var enemies_in_pool = ds_list_create();

for (var i = 0; i < num_enemies; i++) {
    var enemy = enemy_list[| i];
    ds_list_add(enemies_in_pool, enemy);

    // If this enemy isn't already slowed, slow them
    if (!variable_instance_exists(enemy, "mud_pool_slow")) {
        var old_speed = enemy.move_speed_ups;
        enemy.move_speed_ups *= (1 - slow_amount);
        show_debug_message("Slowing enemy " + string(enemy.id) + " from " + string(old_speed) + " to " + string(enemy.move_speed_ups));
        enemy.mud_pool_slow = true;

        // Add "Slowed" status text
        array_push(enemy.status_texts, "Slowed");

        ds_list_add(slowed_enemies, enemy);
    }
}

// Remove slow from enemies that left the pool
for (var i = ds_list_size(slowed_enemies) - 1; i >= 0; i--) {
    var enemy = slowed_enemies[| i];

    // If enemy left the pool or was destroyed
    if (!instance_exists(enemy) || ds_list_find_index(enemies_in_pool, enemy) == -1) {
        if (instance_exists(enemy) && variable_instance_exists(enemy, "mud_pool_slow")) {
            // Restore speed
            enemy.move_speed_ups /= (1 - slow_amount);
            delete enemy.mud_pool_slow;

            // Remove "Slowed" status text
            var slowed_index = array_get_index(enemy.status_texts, "Slowed");
            if (slowed_index != -1) {
                array_delete(enemy.status_texts, slowed_index, 1);
            }
        }
        ds_list_delete(slowed_enemies, i);
    }
}

ds_list_destroy(enemy_list);
ds_list_destroy(enemies_in_pool);
