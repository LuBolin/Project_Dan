/// @function damage_entity(_target, _dmg)
/// @param {Id.Instance} _target The target being attacked
/// @param {Real} _dmg The amount of damage dealt
function damage_entity(_target, _dmg) {
    if (!variable_instance_exists(_target, "invuln") || !_target.invuln) {
        _target.hp -= _dmg;
        _target.image_blend = c_red;


        if (variable_instance_exists(_target, "invuln")) {
            _target.invuln = true
        }

        _target.alarm[11] = 20
    }
}

/// @function apply_knockback(_source, _target, _knockback_speed, _apply_stun)
/// @param {Id.Instance} _source The source of the knockback
/// @param {Id.Instance} _target The target being knocked back
/// @param {Real} _knockback_speed The knockback speed/strength
/// @param {Bool} _apply_stun Whether to also stun the target (default: true)
function apply_knockback(_source, _target, _knockback_speed, _apply_stun = true) {
    if (_knockback_speed <= 0) return;

    // Calculate knockback direction (from source to target)
    var kb_direction = point_direction(_source.x, _source.y, _target.x, _target.y);

    // Apply knockback as a status effect
    var kb_duration = max(10, _knockback_speed * 2); // Duration scales with speed
    add_status_effect(_target, new KnockbackEffect(kb_direction, _knockback_speed, kb_duration, _apply_stun));
}