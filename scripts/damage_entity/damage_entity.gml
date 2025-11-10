/// @function damage_entity(_target, _dmg)
/// @param {Id.Instance} _target The target being attacked
/// @param {Real} _dmg The amount of damage dealt
function damage_entity(_target, _dmg) {
    // CHANGED: Check invuln flag - if true, completely skip damage
    if (variable_instance_exists(_target, "invuln") && _target.invuln) {
        return; // Target is invulnerable, skip all damage logic
    }
    

    // Apply damage
    _target.hp -= _dmg;
    _target.alarm[11] = 30; // Brief 0.5s invuln between hits
    
    if (variable_instance_exists(_target, "is_hurt_this_level")) 
        _target.is_hurt_this_level = true;
    
    // Visual feedback - red flash
    _target.image_blend = c_red;

    // CHANGED: Only apply brief invuln if player doesn't already have status-effect-based invuln
    if (_target.object_index == obj_player) {
        // Check if player has InvincibilityEffect active (managed by status system)
        var has_invuln_effect = false;
        if (variable_instance_exists(_target, "status_effects_list")) {
            for (var i = 0; i < array_length(_target.status_effects_list); i++) {
                var eff = _target.status_effects_list[i];
                if (is_struct(eff) && variable_struct_exists(eff, "get_type") && (eff.get_type() == "Invincible" || eff.get_type() == "ElixirInvincibility")) {
                    has_invuln_effect = true;
                    break;
                }
            }
        }

        // Only set brief invuln if no InvincibilityEffect is active
        if (!has_invuln_effect) {
            add_status_effect(other, new InvincibilityEffect(10))
        }
    }
}

/// @function apply_knockback(_source, _target, _kb_speed, _kb_distance, _kb_direction, _apply_stun)
/// @param {Id.Instance} _source The source of the knockback
/// @param {Id.Instance} _target The target being knocked back
/// @param {Real} _kb_speed Speed of knockback (pixels per frame)
/// @param {Real} _kb_distance Total distance to push (in pixels)
/// @param {Real} _kb_direction Direction of knockback in degrees (if undefined, calculated from source to target)
/// @param {Real} _kb_duration Duration of knockback/stun (if undefined, calculated based off distance and speed)
/// @param {Bool} _apply_stun Whether to also stun the target (default: true)
function apply_knockback(_source, _target, _kb_speed, _kb_distance, _kb_direction = undefined, _kb_duration = undefined, _apply_stun = true) {
    if (_kb_distance <= 0 || _kb_speed <= 0) return;

    // Prevent player in invuln state from being "ping-ponged" between different enemies
    if (_target.object_index == obj_player and obj_player.invuln) {
        return;
    }
    
    // Calculate knockback direction (from source to target if not provided)
    var kb_direction = _kb_direction;
    if (is_undefined(_kb_direction)) {
        kb_direction = point_direction(_source.x, _source.y, _target.x, _target.y);
    }
    
    var kb_duration = _kb_duration
    if (is_undefined(_kb_duration)) {
        // Calculate duration from distance and speed
        kb_duration = _kb_distance / _kb_speed;
    }
    
    // Apply knockback as a status effect
    add_status_effect(_target, new KnockbackEffect(kb_direction, _kb_speed, kb_duration, _apply_stun));        
}