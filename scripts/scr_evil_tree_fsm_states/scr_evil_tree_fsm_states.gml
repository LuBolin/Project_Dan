
function EvilTreeRoamState(_entity, _duration = undefined, _is_timed = false) : RoamState(_entity, _duration, _is_timed) constructor {
    on_step = function() {

    }
    
    on_timeout = function() {
        
    }
    
}

function EvilTreeChaseState(_entity, _duration = 120, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {
    // Range in pixels (units → pixels), can add attack_range_units to tree
    _range_units = (variable_instance_exists(entity, "attack_range_units") && is_real(entity.attack_range_units))
        ? entity.attack_range_units : 4; // default 4 units
    _shoot_range_px = _range_units * global.UNIT_LENGTH;
    
    on_step = function() {
        with (entity) {
            // Check if player_last_known position is defined before using
            if (variable_instance_exists(self, "player_last_known_x") &&
                variable_instance_exists(self, "player_last_known_y")) {
                var _player_x = player_last_known_x ?? x;
                var _player_y = player_last_known_y ?? y;
                var dist = point_distance(x, y, _player_x, _player_y);
                if (dist <= other._shoot_range_px && attack_cd_timer <= 0) {
                    changeState(STATES.ATTACK);
                }
            }
        }
    }
    
}

