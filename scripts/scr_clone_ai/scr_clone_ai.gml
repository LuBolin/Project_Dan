/// @description Clone AI Functions (No Status Effects)
/// AI behavior functions for player clones - simplified without status effects

/// @function clone_ai_find_target(clone_instance)
/// @description Find the closest enemy within detection range
function clone_ai_find_target(clone_instance) {
    var closest_enemy = noone;
    var closest_distance = clone_instance.detection_radius;
    
    // Count total enemies in room
    var total_enemies = instance_number(obj_enemy_abstract);
    
    // Find closest enemy
    for (var i = 0; i < total_enemies; i++) {
        var enemy = instance_find(obj_enemy_abstract, i);
        if (instance_exists(enemy)) {
            var dist = point_distance(enemy.x, enemy.y, clone_instance.x, clone_instance.y);
            
            if (dist <= closest_distance) {
                // Check line of sight
                var sight_line = collision_line(clone_instance.x, clone_instance.y, enemy.x, enemy.y, clone_instance.colliders, false, true);
                
                if (sight_line == noone) {
                    closest_distance = dist;
                    closest_enemy = enemy;
                }
            }
        }
    }
    
    if (instance_exists(closest_enemy)) {
        clone_instance.target_enemy = closest_enemy;
        clone_instance.state = "moving";
        show_debug_message("Clone AI: Set target to enemy " + string(closest_enemy));
    } else {
        show_debug_message("Clone AI: No enemies found within detection radius " + string(clone_instance.detection_radius));
    }
}

/// @function clone_ai_move_to_target(clone_instance)
/// @description Move towards target enemy
function clone_ai_move_to_target(clone_instance) {
    
    if (!instance_exists(clone_instance.target_enemy)) {
        clone_instance.target_enemy = noone;
        clone_instance.state = "idle";
        show_debug_message("Clone AI: Target destroyed, returning to idle");
        exit;
    }
    
    var dist_to_target = point_distance(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
    
    // If close enough to attack, switch to attacking
    if (dist_to_target <= global.UNIT_LENGTH * 2) { // 2 units attack range
        clone_instance.state = "attacking";
        show_debug_message("Clone AI: Close enough to attack, switching to attacking");
        exit;
    }
    
    // Move towards target
    var move_dir = point_direction(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
    var move_speed_this_frame = (clone_instance.move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
    
    var move_x = lengthdir_x(move_speed_this_frame, move_dir);
    var move_y = lengthdir_y(move_speed_this_frame, move_dir);
    
    // Collision checking (simplified)
    if (!place_meeting(clone_instance.x + move_x, clone_instance.y, clone_instance.colliders)) {
        clone_instance.x += move_x;
    }
    if (!place_meeting(clone_instance.x, clone_instance.y + move_y, clone_instance.colliders)) {
        clone_instance.y += move_y;
    }
    
    // Update sprite direction
    if (move_x != 0) {
        var scale = abs(clone_instance.image_xscale);
        clone_instance.image_xscale = (move_x > 0) ? scale : -scale;
    }
}

/// @function clone_ai_attack_target(clone_instance)
/// @description Attack the target enemy
function clone_ai_attack_target(clone_instance) {
    if (!instance_exists(clone_instance.target_enemy)) {
        clone_instance.target_enemy = noone;
        clone_instance.state = "idle";
        show_debug_message("Clone AI: Target destroyed during attack, returning to idle");
        exit;
    }
    
    var dist_to_target = point_distance(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
    
    // If target moved away, chase it
    if (dist_to_target > global.UNIT_LENGTH * 2.5) { // 2.5 units chase range
        clone_instance.state = "moving";
        show_debug_message("Clone AI: Target moved away, chasing");
        exit;
    }
    
    // Attack if cooldown is ready
    if (clone_instance.attack_timer <= 0 && array_length(clone_instance.clone_elements) > 0) {
        // Find usable element (skip Creation)
        var usable_element = noone;
        var attempts = 0;
        var max_attempts = array_length(clone_instance.clone_elements);
        
        while (usable_element == noone && attempts < max_attempts) {
            var current_element = clone_instance.clone_elements[clone_instance.clone_element_index];
            
            if (current_element.name != "Creation" && current_element.can_use()) {
                usable_element = current_element;
                break;
            }
            
            clone_instance.clone_element_index = (clone_instance.clone_element_index + 1) % array_length(clone_instance.clone_elements);
            attempts++;
        }
        
        if (usable_element != noone) {
            // Handle different element types
            switch (usable_element.name) {
                case "Steam":
                    // Steam: Create steam cloud at clone position (like player)
                    if (!instance_exists(obj_steam) || obj_steam.owner != clone_instance) {
                        var steam = instance_create_layer(clone_instance.x, clone_instance.y, "Instances", obj_steam);
                        if (instance_exists(steam)) {
                            steam.owner = clone_instance;
                            steam.damage_enemies = false; // Steam from clone should damage player/allies
                            steam.damage_player = true;
                        }
                    } else {
                        // Refresh existing steam duration
                        with (obj_steam) {
                            if (owner == clone_instance) {
                                life_timer = life_duration;
                            }
                        }
                    }
                    usable_element.trigger_cd();
                    clone_instance.attack_timer = clone_instance.attack_cooldown;
                    show_debug_message("Clone used Steam");
                    break;
                    
                case "Clay":
                    // Clay: Spawn wall toward target enemy
                    var wall_direction = point_direction(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
                    clone_spawn_clay_wall(clone_instance, wall_direction);
                    usable_element.trigger_cd();
                    clone_instance.attack_timer = clone_instance.attack_cooldown;
                    show_debug_message("Clone used Clay Wall");
                    break;
                    
                case "Destruction":
                    // Destruction: Create destruction effect at clone position
                    var destruction_effect = instance_create_layer(clone_instance.x, clone_instance.y, "Instances", obj_destruction_effect);
                    if (instance_exists(destruction_effect)) {
                        destruction_effect.creator = clone_instance;
                    }
                    usable_element.trigger_cd();
                    clone_instance.attack_timer = clone_instance.attack_cooldown;
                    show_debug_message("Clone used Destruction");
                    break;
                    
                default:
                    // Regular projectile elements
                    if (variable_struct_exists(usable_element, "projectile") && usable_element.projectile != undefined) {
                        var target_x = clone_instance.target_enemy.x;
                        var target_y = clone_instance.target_enemy.y;
                        spawn_and_set_projectile(clone_instance, new usable_element.projectile(), target_x, target_y);
                        usable_element.trigger_cd();
                        clone_instance.attack_timer = clone_instance.attack_cooldown;
                        show_debug_message("Clone attacked with " + usable_element.name);
                    } else {
                        show_debug_message("Clone element " + usable_element.name + " has no projectile");
                    }
                    break;
            }
        }
        
        // Always move to next element regardless
        clone_instance.clone_element_index = (clone_instance.clone_element_index + 1) % array_length(clone_instance.clone_elements);
    }
}

/// @function clone_spawn_clay_wall(clone_instance, direction)
/// @description Spawn clay wall for clone (identical to player)
function clone_spawn_clay_wall(clone_instance, direction) {
    // Wall properties (same as player)
    var wall_segments = 6; // Same as player
    var segment_spacing = 45; // Same as player spacing
    var wall_scale = 2.0; // Same as player scale
    
    // Update collision arrays for new walls
    with (obj_player) {
        if (array_get_index(colliders, obj_clay_wall) == -1) {
            array_push(colliders, obj_clay_wall);
        }
    }
    
    with (obj_enemy_abstract) {
        if (array_get_index(colliders, obj_clay_wall) == -1) {
            array_push(colliders, obj_clay_wall);
        }
    }
    
    // Spawn wall segments (same as player)
    for (var i = 1; i <= wall_segments; i++) {
        var segment_x = clone_instance.x + lengthdir_x(i * segment_spacing, direction);
        var segment_y = clone_instance.y + lengthdir_y(i * segment_spacing, direction);
        
        // Check if position is valid (same logic as player)
        var can_place = true;
        
        // Check collision with terrain
        if (place_meeting(segment_x, segment_y, layer_tilemap_get_id("Tile_Collision"))) {
            can_place = false;
        }
        
        // Check collision with existing clay walls (same minimum distance as player)
        with (obj_clay_wall) {
            if (point_distance(x, y, segment_x, segment_y) < 20) {
                can_place = false;
                break;
            }
        }
        
        if (can_place) {
            var wall_segment = instance_create_layer(segment_x, segment_y, "Instances", obj_clay_wall);
            if (instance_exists(wall_segment)) {
                wall_segment.image_angle = direction;
                wall_segment.image_xscale = wall_scale;
                wall_segment.image_yscale = wall_scale;
                wall_segment.life_timer = game_get_speed(gamespeed_fps) * 5; // Slightly shorter for clone
            }
        } else {
            // Stop creating segments if we hit an obstacle
            break;
        }
    }
    
    show_debug_message("Clone clay wall spawned matching player style");
}