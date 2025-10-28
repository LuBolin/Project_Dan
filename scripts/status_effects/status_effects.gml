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
        if (variable_instance_exists(target, "move_speed")) {
            original_speed = target.move_speed;
            target.move_speed = original_speed * (1 - slow_percent);
        }
    }

    on_remove = function() {
        if (variable_instance_exists(target, "move_speed")) {
            target.move_speed = original_speed;
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
    
    on_apply = function() {
        target.effect_sprite = effect_sprite;
    }
    
    on_step = function() {
        tick_counter++;
        if (tick_counter >= tick_rate) {
            tick_counter = 0;
            if (variable_instance_exists(target, "hp")) {
                target.hp -= damage_per_tick;
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
        }
    }

    get_type = function() {
        return "Burn";
    }
}

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

    on_remove = function() {
        // Remove invulnerability flag
        if (instance_exists(target) && variable_instance_exists(target, "invuln")) {
            target.invuln = false;
        }

        // Restore full opacity
        if (instance_exists(target) && variable_instance_exists(target, "image_alpha")) {
            target.image_alpha = 1.0;
        }
    }

    get_type = function() {
        return "Invincible";
    }
}

/// @function add_status_effect(_target, _effect)
/// @description Add a status effect to an entity
function add_status_effect(_target, _effect) {
    // Initialize status effects array if it doesn't exist
    if (!variable_instance_exists(_target, "status_effects")) {
        _target.status_effects = [];
    }

    // Check for existing effect of same type
    var effect_type = _effect.get_type();
    var existing_index = -1;

    for (var i = 0; i < array_length(_target.status_effects); i++) {
        if (_target.status_effects[i].get_type() == effect_type) {
            existing_index = i;
            break;
        }
    }

    // Handle based on stack behavior
    if (existing_index >= 0) {
        var existing = _target.status_effects[existing_index];

        switch (_effect.stack_behavior) {
            case "replace":
                // Remove old, add new
                existing.remove();
                array_delete(_target.status_effects, existing_index, 1);
                _effect.apply(_target);
                array_push(_target.status_effects, _effect);
                break;

            case "refresh":
                // Reset duration of existing effect
                existing.remaining_time = _effect.duration;
                break;

            case "stack":
                // Add as new effect (allows multiple of same type)
                _effect.apply(_target);
                array_push(_target.status_effects, _effect);
                break;
        }
    } else {
        // No existing effect of this type, just add
        _effect.apply(_target);
        array_push(_target.status_effects, _effect);
    }
}

/// @function update_status_effects(_target)
/// @description Update all status effects on an entity (call in Step event)
function update_status_effects(_target) {
    if (!variable_instance_exists(_target, "status_effects")) {
        return;
    }

    var has_stun_or_knockback = false
    // Update all effects and remove expired ones
    for (var i = array_length(_target.status_effects) - 1; i >= 0; i--) {
        var effect = _target.status_effects[i];
        var still_active = effect.step();

        if (!still_active) {
            effect.remove();
            array_delete(_target.status_effects, i, 1);
        } else if (instanceof(effect) == "StunEffect" or instanceof(effect) == "KnockbackEffect") {
            has_stun_or_knockback = true;
        }
    }
    
    if (has_stun_or_knockback) {
        _target.pause = true;
    } else {
        _target.pause = false;
    }
}

/// @function clear_status_effects(_target)
/// @description Remove all status effects from an entity
function clear_status_effects(_target) {
    if (!variable_instance_exists(_target, "status_effects")) {
        return;
    }

    for (var i = 0; i < array_length(_target.status_effects); i++) {
        _target.status_effects[i].remove();
    }

    _target.status_effects = [];
}
