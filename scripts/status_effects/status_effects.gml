/// @description Status Effect System
/// Base class for all status effects

/// @function StatusEffect()
/// @description Base status effect constructor
function StatusEffect() constructor {
    duration = 0;           // Duration in frames
    remaining_time = 0;     // Remaining time
    target = noone;         // The entity affected by this status
    stack_behavior = "replace"; // "replace", "stack", "refresh"

    /// @function apply(_target)
    /// @description Called when the status effect is first applied
    apply = function(_target) {
        target = _target;
        remaining_time = duration;

        // Add status text to target if they have the status_texts array
        if (variable_instance_exists(target, "status_texts")) {
            var type_name = get_type();
            if (array_get_index(target.status_texts, type_name) == -1) {
                array_push(target.status_texts, type_name);
            }
        }

        on_apply();
    }

    /// @function on_apply()
    /// @description Override this - called when effect is applied
    on_apply = function() {
        // Override in child classes
    }

    /// @function step()
    /// @description Called every frame while active
    step = function() {
        remaining_time--;
        on_step();
        return remaining_time > 0; // Return false when expired
    }

    /// @function on_step()
    /// @description Override this - called every frame
    on_step = function() {
        // Override in child classes
    }

    /// @function remove()
    /// @description Called when the effect expires or is removed
    remove = function() {
        // Remove status text from target if they have the status_texts array
        if (instance_exists(target) && variable_instance_exists(target, "status_texts")) {
            var type_name = get_type();
            var text_index = array_get_index(target.status_texts, type_name);
            if (text_index != -1) {
                array_delete(target.status_texts, text_index, 1);
            }
        }

        on_remove();
    }

    /// @function on_remove()
    /// @description Override this - called when effect is removed
    on_remove = function() {
        // Override in child classes
    }

    /// @function get_type()
    /// @description Return the type name of this effect (for stacking logic)
    get_type = function() {
        return "StatusEffect";
    }
}

/// @function StunEffect(_duration)
/// @description Stuns the target, preventing movement and actions
function StunEffect(_duration) : StatusEffect() constructor {
    duration = _duration;
    stack_behavior = "refresh"; // Refresh duration if already stunned
    original_pause_state = false;
    original_move_speed = 0;

    on_apply = function() {
        // For enemies: set pause = true
        if (variable_instance_exists(target, "pause")) {
            original_pause_state = target.pause;
            target.pause = true;
        }

        // For all entities: set move_speed to 0 as backup
        if (variable_instance_exists(target, "move_speed")) {
            original_move_speed = target.move_speed;
            target.move_speed = 0;
        }

        // Mark as stunned for gameplay logic
        target.is_stunned = true;
    }

    on_remove = function() {
        // Restore pause state
        if (variable_instance_exists(target, "pause")) {
            target.pause = original_pause_state;
        }

        // Restore move_speed
        if (variable_instance_exists(target, "move_speed")) {
            target.move_speed = original_move_speed;
        }

        // Remove stunned flag
        target.is_stunned = false;
    }

    get_type = function() {
        return "Stun";
    }
}

/// @function KnockbackEffect(_direction, _speed, _duration, _apply_stun)
/// @description Applies knockback force with optional stun
function KnockbackEffect(_direction, _speed, _duration, _apply_stun = true) : StatusEffect() constructor {
    duration = _duration;
    kb_direction = _direction;  // Angle in degrees
    kb_speed = _speed;          // Constant speed
    apply_stun = _apply_stun;   // Should this knockback also stun?
    stack_behavior = "stack";   // Multiple knockbacks stack

    on_apply = function() {
        // Apply stun if requested
        if (apply_stun) {
            var stun_duration = duration; // Match knockback duration
            add_status_effect(target, new StunEffect(stun_duration));
        }
    }

    on_step = function() {
        // Mark this frame as forced motion (don’t flip on End Step)
        target.moved_by_knockback = true;

        // Apply knockback movement at constant speed
        var kb_x = lengthdir_x(kb_speed, kb_direction);
        var kb_y = lengthdir_y(kb_speed, kb_direction);

        // Move the target with collision if it has the necessary properties
        if (variable_instance_exists(target, "colliders")) {
            with (target) {
                move_and_collide(kb_x, kb_y, colliders);
            }
        } else if (variable_instance_exists(target, "x") && variable_instance_exists(target, "y")) {
            // Fallback: move without collision if no colliders defined
            target.x += kb_x;
            target.y += kb_y;
        }
    }
    
    get_type = function() {
        return "Knockback";
    }
}

/// @function KnockbackEffect(_direction, _speed, _duration, _apply_stun)
/// @description Applies knockback force with optional stun
function EnemyChargeEffect(_direction, _speed, _duration, _apply_stun = true) : KnockbackEffect(_direction, _speed, _duration, _apply_stun = true) constructor {
    
    on_apply = function() {
        // Apply stun if requested
        if (apply_stun) {
            var stun_duration = duration; // Match knockback duration
            add_status_effect(target, new StunEffect(stun_duration));
        }
        if (variable_instance_exists(target, "is_charging")) target.is_charging = true;
    }

    
    charge = function(_kb_x, _kb_y) {
        with (target) {
            
            vel_hori = lengthdir_x(other.kb_speed, other.kb_direction);
            vel_vert = lengthdir_y(other.kb_speed, other.kb_direction);
            // Horizontal movement
            if (place_meeting(x + vel_hori, y, colliders)) {
                
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + vel_hori, y + vel_vert, colliders)) {
                    y += vel_vert
                } else if (!place_meeting(x + vel_hori, y - vel_vert, colliders)) {
                    y -= vel_vert
                } else {
                    vel_hori = 0;   
                }
                
            }
            
            x += vel_hori;
            
            // Vertical movement
            if (place_meeting(x, y + vel_vert, colliders)) {
                
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + vel_hori, y + vel_vert , colliders)) {
                    x += vel_hori
                } else if (!place_meeting(x - vel_hori, y + vel_vert, colliders)) {
                    x -= vel_hori;
                } else {
                    vel_vert = 0;   
                }
            }
            
            y += vel_vert;
        }
    }
    
    on_step = function() {
        // Mark this frame as forced motion (don’t flip on End Step)
        target.moved_by_knockback = true;
        
        if (variable_instance_exists(target, "is_charging") && target.is_charging) {
            // Apply knockback movement at constant speed
            var kb_x = lengthdir_x(kb_speed, kb_direction);
            var kb_y = lengthdir_y(kb_speed, kb_direction);

            // Move the target with collision if it has the necessary properties
            if (variable_instance_exists(target, "colliders")) {
                charge(kb_x, kb_y);
    
            } else if (variable_instance_exists(target, "x") && variable_instance_exists(target, "y")) {
                // Fallback: move without collision if no colliders defined
                target.x += kb_x;
                target.y += kb_y;
            }            
        } else {
            return false;
        }

    }
    
    on_remove = function() {
         if (variable_instance_exists(target, "is_charging")) target.is_charging = false;
    }
    
    get_type = function() {
        return "Charge";
    }
    

}


/// @function DamageOverTimeEffect(_duration, _damage_per_tick, _tick_rate)
/// @description Deals damage over time
function DamageOverTimeEffect(_duration, _damage_per_tick, _tick_rate = 30) : StatusEffect() constructor {
    tick_rate = _tick_rate;
    damage_color_duration = 5; // How long the damage flash lasts (must be < tick_rate)
    duration = _duration + damage_color_duration; // Extend duration to show final damage flash
    damage_per_tick = _damage_per_tick;
    tick_counter = 0;
    stack_behavior = "stack"; // Multiple DoTs can stack

    on_step = function() {
        tick_counter++;
        if (tick_counter >= tick_rate) {
            tick_counter = 0;
            if (variable_instance_exists(target, "hp")) {
                target.hp -= damage_per_tick;
                // Visual feedback
                if (variable_instance_exists(target, "image_blend")) {
                    target.image_blend = c_red;
                }
            }
        }

        // Fade back to white after damage_color_duration frames
        if (tick_counter > damage_color_duration && variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
        }
    }

    on_remove = function() {
        // Ensure color is reset when effect ends
        if (variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
        }
    }

    get_type = function() {
        return "DamageOverTime";
    }
}

/// @function HurricaneDotEffect(_duration, _damage_per_tick, _tick_rate)
/// @description Hurricane-specific DoT that refreshes instead of stacking
function HurricaneDotEffect(_duration, _damage_per_tick, _tick_rate = 60) : StatusEffect() constructor {
    tick_rate = _tick_rate;
    damage_color_duration = 10; // How long the damage flash lasts (must be < tick_rate)
    duration = _duration + damage_color_duration; // Extend duration to show final damage flash
    damage_per_tick = _damage_per_tick;
    tick_counter = 0;
    stack_behavior = "refresh"; // Refresh duration instead of stacking

    on_step = function() {
        tick_counter++;
        if (tick_counter >= tick_rate) {
            tick_counter = 0;
            if (variable_instance_exists(target, "hp")) {
                target.hp -= damage_per_tick;
                // Visual feedback
                if (variable_instance_exists(target, "image_blend")) {
                    target.image_blend = c_red;
                }
            }
        }

        // Fade back to white after damage_color_duration frames
        if (tick_counter > damage_color_duration && variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
        }
    }

    on_remove = function() {
        // Ensure color is reset when effect ends
        if (variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
        }
    }

    get_type = function() {
        return "HurricaneDot";
    }
}

/// @function SlowEffect(_duration, _slow_percent)
/// @description Reduces movement speed by a percentage
function SlowEffect(_duration, _slow_percent) : StatusEffect() constructor {
    duration = _duration;
    slow_percent = clamp(_slow_percent, 0, 1); // 0.0 to 1.0
    original_speed = 0;
    stack_behavior = "replace"; // Only one slow at a time

    on_apply = function() {
        if (variable_instance_exists(target, "move_speed_ups")) {
            original_speed = target.move_speed_ups;
            target.move_speed_ups = original_speed * (1 - slow_percent);
            show_debug_message("SlowEffect applied: " + string(original_speed) + " -> " + string(target.move_speed_ups));
        }
    }

    on_remove = function() {
        if (variable_instance_exists(target, "move_speed_ups")) {
            target.move_speed_ups = original_speed;
            show_debug_message("SlowEffect removed: restored to " + string(original_speed));
        }
    }

    get_type = function() {
        return "Slow";
    }
}

/// @function BurnEffect(_duration, _damage_per_tick)
/// @description Fire-based DoT that deals damage once per second
function BurnEffect(_duration, _damage_per_tick) : StatusEffect() constructor {
    tick_rate = game_get_speed(gamespeed_fps); // Tick every second (60 frames)
    damage_color_duration = 10; // How long the damage flash lasts (must be < tick_rate)
    duration = _duration + damage_color_duration; // Extend duration to show final damage flash
    damage_per_tick = _damage_per_tick;
    tick_counter = 0;
    stack_behavior = "refresh"; // Refreshes duration instead of stacking
    effect_sprite = spr_effect_fire;
    effect_anim_speed = 0.4; // frames per step
    
    on_apply = function() {
        target.effect_sprite = effect_sprite;
        target.effect_sprite_frame = 0;
    }
    
    on_step = function() {
        // Advance animation
        if (sprite_exists(effect_sprite)) {
            var frame_count = max(1, sprite_get_number(effect_sprite));
            target.effect_sprite_frame = (target.effect_sprite_frame + effect_anim_speed) mod frame_count;
        }

        tick_counter++;
        if (tick_counter >= tick_rate) {
            tick_counter = 0;
            if (variable_instance_exists(target, "hp")) {
                target.hp -= damage_per_tick;
                if (instance_exists(obj_player) && target.object_index == obj_player){
                    sfx_play(snd_burn, true);
                } else {
                    sfx_play(snd_burn, true);
                }
                // Visual feedback - orange/red flash for burn
                if (variable_instance_exists(target, "image_blend")) {
                    target.image_blend = make_color_rgb(255, 100, 0); // Orange
                } 
            }
        }

        // Fade back to white after damage_color_duration frames
        if (tick_counter > damage_color_duration && variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
        }
    }

    on_remove = function() {
        // Ensure color is reset when burn effect ends
        if (variable_instance_exists(target, "image_blend")) {
            target.image_blend = c_white;
            target.effect_sprite = undefined;
            target.effect_sprite_frame = undefined;
        }
    }

    get_type = function() {
        return "Burn";
    }
}


// NOTE: PLEASE CHECK THE add_status function, I needed to make changes for elixir invincibility
/// @function InvincibilityEffect(_duration)
/// @description Makes the target invincible (immune to damage)
function InvincibilityEffect(_duration) : StatusEffect() constructor {
    duration = _duration;
    stack_behavior = "refresh"; // Refresh duration if invincibility is reapplied

    on_apply = function() {
        // Set invulnerability flag
        if (variable_instance_exists(target, "invuln")) {
            target.invuln = true;
        }

        // Visual feedback - make player slightly transparent
        if (variable_instance_exists(target, "image_alpha")) {
            target.image_alpha = 0.5;
        }
    }

    //on_remove = function() {
        //// Remove invulnerability flag
        //if (instance_exists(target) && variable_instance_exists(target, "invuln")) {
            //target.invuln = false;
        //}
//
        //// Restore full opacity
        //if (instance_exists(target) && variable_instance_exists(target, "image_alpha")) {
            //target.image_alpha = 1.0;
        //}
    //}

    get_type = function() {
        return "Invincible";
    }
}

/// @function InvincibilityEffect(_duration)
/// @description Makes the target invincible (immune to damage)
function ElixirInvincibilityEffect(_duration) : InvincibilityEffect(_duration) constructor {
    duration = _duration;
    stack_behavior = "refresh"; // Refresh duration if invincibility is reapplied

    on_apply = function() {
        // Set invulnerability flag
        if (variable_instance_exists(target, "invuln")) {
            target.invuln = true;
        }
        
        // Set invulnerability flag
        if (variable_instance_exists(target, "elixir_invuln")) {
            target.elixir_invuln = true;
        }
        
        // Visual feedback - make player slightly transparent
        if (variable_instance_exists(target, "image_alpha")) {
            target.image_alpha = 0.5;
        }
    }
    
    on_remove = function() {
        
        // Set invulnerability flag
        if (variable_instance_exists(target, "elixir_invuln")) {
            target.elixir_invuln = false;
        }
                
    }

    get_type = function() {
        return "Invincible";
    }
}


/// Helper: ensure the target has a status effect storage array
function _ensure_effect_array(_target) {
    if (!instance_exists(_target)) return;
    // Migrate old name if it exists
    if (variable_instance_exists(_target, "status_effects") && !variable_instance_exists(_target, "status_effects_list")) {
        _target.status_effects_list = _target.status_effects;
    }
    if (!variable_instance_exists(_target, "status_effects_list")) {
        _target.status_effects_list = [];
    }
}

/// @function add_status_effect(_target, _effect)
/// @description Add a status effect to an entity
function add_status_effect(_target, _effect) {
    if (!instance_exists(_target)) return;
    _ensure_effect_array(_target);

    var effects_arr = _target.status_effects_list;

    // Check for existing effect of same type
    var effect_type = _effect.get_type();
    
    if (variable_instance_exists(_target, "elixir_invuln") && _target.elixir_invuln &&
        (effect_type == "HurricaneDotEffect" || effect_type == "Burn" || effect_type == "Slow" || effect_type == "DamageOverTimeEffect")) {
        return;
    }
    
    var existing_index = -1;
    for (var i = array_length(effects_arr) - 1; i >= 0; i--) {
        var t = effects_arr[i].get_type();
        if (t == effect_type) {
            existing_index = i; break;
        }
        
        // Remove Burn or Slow
        if (effect_type == "Invincible" && (t == "HurricaneDotEffect" || t == "Burn" || t == "Slow" || t == "DamageOverTimeEffect")) {
            effects_arr[i].remove();
            array_delete(effects_arr, i, 1);
        }
    }

    // Handle based on stack behavior
    if (existing_index >= 0) {
        var existing = effects_arr[existing_index];
        switch (_effect.stack_behavior) {
            case "replace":
                // Remove old, add new
                existing.remove();
                array_delete(effects_arr, existing_index, 1);
                _effect.apply(_target);
                array_push(effects_arr, _effect);
                break;

            case "refresh":
                // Reset duration of existing effect
                existing.remaining_time = _effect.duration;
                break;

            case "stack":
                // Add as new effect (allows multiple of same type)
                _effect.apply(_target);
                array_push(effects_arr, _effect);
                break;
        }
    } else {
        // No existing effect of this type, just add
        _effect.apply(_target);
        array_push(effects_arr, _effect);
    }
}

/// @function update_status_effects(_target)
/// @description Update all status effects on an entity (call in Step event)
function update_status_effects(_target) {
    if (!instance_exists(_target)) return;
    _ensure_effect_array(_target);
    var effects_arr = _target.status_effects_list;

    var has_stun_or_knockback = false;
    var has_invuln = false;
    
    for (var i = array_length(effects_arr) - 1; i >= 0; i--) {
        var effect = effects_arr[i];
        var still_active = effect.step();
        var t = effect.get_type();        
        if (!still_active) {  
            effect.remove();
            array_delete(effects_arr, i, 1);
        } else {
            if (t == "Stun" || t == "Knockback" || t == "Charge") has_stun_or_knockback = true;
            if (t == "Invincible") has_invuln = true;
        }
    }
    if (variable_instance_exists(_target, "pause")) {
        _target.pause = has_stun_or_knockback;
    }
    
    if (variable_instance_exists(_target, "invuln")) {
        _target.invuln = has_invuln;
        _target.image_alpha = has_invuln ? 0.5 : 1.0;
    }
}

/// @function clear_certain_status_effects(_target, certain_effects)
/// @description Remove certain status effects from an entity
function clear_certain_status_effects(_target, certain_effects) {
    if (!instance_exists(_target)) return;
    if (!variable_instance_exists(_target, "status_effects_list")) return;
    var effects_arr = _target.status_effects_list;
    for (var i = 0; i < array_length(effects_arr); i++) {
        effects_arr[i].remove();
    }
    _target.status_effects_list = [];
}


/// @function clear_status_effects(_target)
/// @description Remove all status effects from an entity
function clear_status_effects(_target) {
    if (!instance_exists(_target)) return;
    if (!variable_instance_exists(_target, "status_effects_list")) return;
    var effects_arr = _target.status_effects_list;
    for (var i = 0; i < array_length(effects_arr); i++) {
        effects_arr[i].remove();
    }
    _target.status_effects_list = [];
}

/// @function check_status_effect(_target)
/// @description Check if entity has certain status effects
function check_status_effects(_target, status_name) {
    if (!instance_exists(_target)) return;
    if (!variable_instance_exists(_target, "status_effects_list")) return;
    var effects_arr = _target.status_effects_list;
    for (var i = 0; i < array_length(effects_arr); i++) {
        if (effects_arr[i].get_type() == status_name) {
            return true;
        }
    }
    return false;
}