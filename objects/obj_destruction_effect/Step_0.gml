// Decrease effect timer
effect_timer--;

// Handle visual phases
if (effect_timer > fade_duration) {
    // Flash phase - quick bright flash
    var flash_progress = (total_duration - effect_timer) / flash_duration;
    image_alpha = min(0.8, flash_progress * 2); // Quick ramp up to 80% alpha
} else {
    // Fade phase - slower fade out
    var fade_progress = effect_timer / fade_duration;
    image_alpha = fade_progress * 0.8; // Fade from 80% to 0%
}

// Damage all enemies on screen (only once during flash phase)
if (!has_damaged && effect_timer <= total_duration - (flash_duration * 0.3)) {
    has_damaged = true;
    damage_all_visible_enemies();
}

// Update camera position to follow camera movement
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

x = cam_x + cam_w / 2;
y = cam_y + cam_h / 2;

// Destroy when effect is complete
if (effect_timer <= 0) {
    instance_destroy();
}

/// @function damage_all_visible_enemies()
/// @description Damages all enemies currently visible on screen
damage_all_visible_enemies = function() {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    var enemies_damaged = 0;
    
    // Check all enemies in the room
    with (obj_enemy_abstract) {
        // Check if enemy is within camera bounds (visible on screen)
        if (x >= cam_x - 32 && x <= cam_x + cam_w + 32 &&
            y >= cam_y - 32 && y <= cam_y + cam_h + 32) {
            
            // Apply destruction damage
            damage_entity(id, other.destruction_damage);
            
            // Apply stun effect
            add_status_effect(id, new StunEffect(game_get_speed(gamespeed_fps) * 1)); // 1 second stun
            
            // Visual effect - red flash
            image_blend = c_red;
            alarm[11] = 20; // Flash duration
            
            enemies_damaged++;
            
            show_debug_message("Destruction damaged enemy " + string(id) + " (on screen)");
        } else {
            show_debug_message("Enemy " + string(id) + " not damaged (off screen)");
        }
    }
    
    show_debug_message("Destruction effect damaged " + string(enemies_damaged) + " visible enemies");
}