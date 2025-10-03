/// @function deal_damage(_target, _attackee, _dmg, _knockback)
/// @param {object} _target The target being attacked
/// @param {int} _dmg The amount of damage dealt
/// @param {int} _knockback The knockback
// This function assumes the target being attacked is something with a healthbar
function damage_entity(_target, _dmg, _knockback) {
    

    if (!variable_instance_exists(_target, "invuln") || !_target.invuln) {
        _target.health -= _dmg;
        _target.image_blend = c_red;
        
        
        if (variable_instance_exists(_target, "invuln")) {
            _target.invuln = true
        }
        
        _target.alarm[11] = 20
    }
    
    kb_x = sign(_target.x - self.x);
    kb_y = sign(_target.y - self.y);
        
    //show_debug_message(_taself.x)
    _target.knockback_x = kb_x * _knockback
    _target.knockback_y = kb_y * _knockback
}