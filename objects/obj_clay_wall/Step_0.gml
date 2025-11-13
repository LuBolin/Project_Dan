// Animation: play once then hold last frame
if (image_index < sprite_get_number(sprite_index) - 1) {
    // Still animating
    image_speed = 0.5;
} else {
    // Reached last frame, stop
    image_index = sprite_get_number(sprite_index) - 1;
    image_speed = 0;
}

// Initial placement damage (only on first frame)
if (is_first_frame) {
    is_first_frame = false;
    
    // Find all enemies overlapping when wall is first created
    with (obj_enemy_abstract) {
        if (place_meeting(x, y, other)) {
            // Apply placement damage
            curr_state.player_interact()
            damage_entity(id, other.placement_damage);
            apply_knockback(other, id, other.placement_knockback_speed, other.placement_knockback_distance);
            
            // Apply brief stun to prevent enemies from walking through immediately
            add_status_effect(id, new StunEffect(game_get_speed(gamespeed_fps) * 0.5)); // 0.5 second stun
            
            // Track that this enemy was damaged by initial placement
            ds_list_add(other.initially_damaged_enemies, id);
            
            // PUSH ENEMY OUT OF WALL - Find nearest non-colliding position
            var push_distance = 32; // Start with 32 pixels
            var push_attempts = 8; // Try 8 directions
            var pushed = false;
            
            for (var attempt = 0; attempt < push_attempts && !pushed; attempt++) {
                var push_angle = (360 / push_attempts) * attempt;
                var new_x = x + lengthdir_x(push_distance, push_angle);
                var new_y = y + lengthdir_y(push_distance, push_angle);
                
                // Check if this position is free of walls (both terrain and clay walls)
                var tilemap = layer_tilemap_get_id("Tile_Collision");
                var tile = tilemap_get_at_pixel(tilemap, new_x, new_y);
                //if (!place_meeting(new_x, new_y, layer_tilemap_get_id("Tile_Collision"))) {
                if (tile == 0 && !place_meeting(new_x, new_y, obj_clay_wall)) {
                    // Move enemy to this position
                    x = new_x;
                    y = new_y;
                    pushed = true;
                    show_debug_message("Pushed enemy " + string(id) + " out of clay wall");
                }
            }
            
            show_debug_message("Clay wall placement damaged enemy " + string(id));
        }
    }

    // Find player overlapping when wall is first created
    if (instance_exists(obj_player) && place_meeting(obj_player.x, obj_player.y, id)) {
        with (obj_player) {
            // PUSH PLAYER OUT OF WALL - Find nearest non-colliding position
            // Calculate push distance based on half of player's size
            var player_width = sprite_get_width(sprite_index);
            var player_height = sprite_get_height(sprite_index);
            var player_size = max(player_width, player_height);
            var push_distance = player_size * 0.5; // Half of player's size
            var push_attempts = 8; // Try 8 directions
            var pushed = false;

            for (var attempt = 0; attempt < push_attempts && !pushed; attempt++) {
                var push_angle = (360 / push_attempts) * attempt;
                var new_x = x + lengthdir_x(push_distance, push_angle);
                var new_y = y + lengthdir_y(push_distance, push_angle);

                // Check if this position is free of walls (both terrain and clay walls)
                var tilemap = layer_tilemap_get_id("Tile_Collision");
                var tile = tilemap_get_at_pixel(tilemap, new_x, new_y);
                if (tile == 0 && !place_meeting(new_x, new_y, obj_clay_wall)) {
                    // Move player to this position
                    x = new_x;
                    y = new_y;
                    pushed = true;
                    show_debug_message("Pushed player out of clay wall");
                }
            }
        }
    }
}

// AGGRESSIVE COLLISION ENFORCEMENT - Check every frame
with (obj_enemy_abstract) {
    if (place_meeting(x, y, other)) {
        
        // Enemy is overlapping with this clay wall
        curr_state.player_interact()
        
        // Method 1: Force stop all movement
        if (variable_instance_exists(id, "speed")) {
            speed = 0;
        }
        
        // Method 2: End any active paths
        if (variable_instance_exists(id, "path_index") && path_index != -1) {
            path_end();
        }
        
        // Method 3: Set pause to true to stop FSM movement
        if (variable_instance_exists(id, "pause")) {
            pause = true;
        }
        
        // Method 4: Apply continuous stun while touching wall
        if (variable_instance_exists(id, "add_status_effect")) {
            add_status_effect(id, new StunEffect(2)); // Very short stun, refreshed every frame
        }
        
        // Method 5: Try to push enemy out of wall
        var push_attempts = 4;
        var push_distance = 8; // Small pushes
        
        for (var attempt = 0; attempt < push_attempts; attempt++) {
            var push_angle = 90 * attempt; // Try cardinal directions
            var new_x = x + lengthdir_x(push_distance, push_angle);
            var new_y = y + lengthdir_y(push_distance, push_angle);
            
            // Check if this position is free
            var tilemap = layer_tilemap_get_id("Tile_Collision");
            var tile = tilemap_get_at_pixel(tilemap, new_x, new_y);
            if (tile == 0 && !place_meeting(new_x, new_y, obj_clay_wall)) {
                // Move enemy to this position
                x = new_x;
                y = new_y;
                break;
            }
        }
        
        show_debug_message("Enemy " + string(id) + " blocked by clay wall");
    } else {
        // Enemy is not touching wall - restore normal behavior
        if (variable_instance_exists(id, "pause") && pause == true) {
            // Only unpause if they were paused by clay wall (not by other systems)
            pause = false;
        }
    }
}

// AGGRESSIVE COLLISION ENFORCEMENT FOR PLAYER - Check every frame
if (instance_exists(obj_player) && place_meeting(obj_player.x, obj_player.y, id)) {
    with (obj_player) {
        // Try to push player out of wall
        var push_attempts = 4;
        // Calculate push distance based on a quarter of player's size (smaller incremental pushes)
        var player_width = sprite_get_width(sprite_index);
        var player_height = sprite_get_height(sprite_index);
        var player_size = max(player_width, player_height);
        var push_distance = player_size * 0.25; // Quarter of player's size for gentle pushes

        for (var attempt = 0; attempt < push_attempts; attempt++) {
            var push_angle = 90 * attempt; // Try cardinal directions
            var new_x = x + lengthdir_x(push_distance, push_angle);
            var new_y = y + lengthdir_y(push_distance, push_angle);

            // Check if this position is free
            var tilemap = layer_tilemap_get_id("Tile_Collision");
            var tile = tilemap_get_at_pixel(tilemap, new_x, new_y);
            if (tile == 0 && !place_meeting(new_x, new_y, obj_clay_wall)) {
                // Move player to this position
                x = new_x;
                y = new_y;
                break;
            }
        }

        show_debug_message("Player blocked by clay wall");
    }
}

// Decrease lifetime
life_timer--;

// Fade out near end of life
if (life_timer <= fade_out_duration) {
    alpha = max(0, life_timer / fade_out_duration);
    image_alpha = alpha;
}

// Destroy when lifetime expires
if (life_timer <= 0) {
    ds_list_destroy(initially_damaged_enemies);
    instance_destroy();
    exit;
}

// Clean up the damaged enemies list (remove destroyed enemies)
for (var i = ds_list_size(initially_damaged_enemies) - 1; i >= 0; i--) {
    var enemy_id = initially_damaged_enemies[| i];
    if (!instance_exists(enemy_id)) {
        ds_list_delete(initially_damaged_enemies, i);
    }
}