/// @description Clone AI Functions (No Status Effects)
/// AI behavior functions for player clones - simplified without status effects

/// @function clone_ai_find_target(clone_instance)
/// @description Find the closest enemy within detection range
function clone_ai_find_target(clone_instance) {
    var closest_enemy = noone;
    var closest_distance = clone_instance.detection_radius;
    
    // Find closest enemy
    with (obj_enemy_abstract) {
        var dist = point_distance(x, y, clone_instance.x, clone_instance.y);
        if (dist <= closest_distance) {
            // Check line of sight
            var sight_line = collision_line(clone_instance.x, clone_instance.y, x, y, clone_instance.colliders, false, true);
            if (sight_line == noone) {
                closest_distance = dist;
                closest_enemy = id;
            }
        }
    }
    
    if (instance_exists(closest_enemy)) {
        clone_instance.target_enemy = closest_enemy;
        clone_instance.state = "moving";
        show_debug_message("Clone found target enemy: " + string(closest_enemy));
    }
}

/// @function clone_ai_move_to_target(clone_instance)
/// @description Move towards target enemy
function clone_ai_move_to_target(clone_instance) {
    if (!instance_exists(clone_instance.target_enemy)) {
        clone_instance.target_enemy = noone;
        clone_instance.state = "idle";
        exit;
    }
    
    var dist_to_target = point_distance(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
    
    // If close enough to attack, switch to attacking
    if (dist_to_target <= global.UNIT_LENGTH * 2) { // 2 units attack range
        clone_instance.state = "attacking";
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
        exit;
    }
    
    var dist_to_target = point_distance(clone_instance.x, clone_instance.y, clone_instance.target_enemy.x, clone_instance.target_enemy.y);
    
    // If target moved away, chase it
    if (dist_to_target > global.UNIT_LENGTH * 2.5) { // 2.5 units chase range
        clone_instance.state = "moving";
        exit;
    }
    
    // Attack if cooldown is ready
    if (clone_instance.attack_timer <= 0 && array_length(clone_instance.clone_elements) > 0) {
        // Use clone's current element
        var current_element = clone_instance.clone_elements[clone_instance.clone_element_index];
        if (current_element.can_use()) {
            // Clone attacks toward target enemy position
            var target_x = clone_instance.target_enemy.x;
            var target_y = clone_instance.target_enemy.y;
            
            // Use the element (simplified version - no status effects on projectiles)
            if (variable_struct_exists(current_element, "projectile") && current_element.projectile != undefined) {
                spawn_and_set_projectile(clone_instance, new current_element.projectile(), target_x, target_y);
                current_element.trigger_cd();
                clone_instance.attack_timer = clone_instance.attack_cooldown;
                
                show_debug_message("Clone attacked with " + current_element.name);
            }
        }
        
        // Cycle to next element
        clone_instance.clone_element_index = (clone_instance.clone_element_index + 1) % array_length(clone_instance.clone_elements);
    }
}