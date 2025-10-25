
function EvilTreeRoamState(_entity, _duration = undefined, _is_timed = false) : RoamState(_entity, _duration, _is_timed) constructor {
    on_step = function() {

    }
    
    on_timeout = function() {
        
    }
    
}

function EvilTreeChaseState(_entity, _duration = 3000, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {
    // Range in pixels (units → pixels), can add attack_range_units to tree
    _range_units = (variable_instance_exists(entity, "attack_range_units") && is_real(entity.attack_range_units))
        ? entity.attack_range_units : 4; // default 4 units
    _shoot_range_px = _range_units * global.UNIT_LENGTH;
    
    on_step = function() {
        with (entity) {
            // player_last_known_x and player_last_known_y should be defined before this, ignore gamemaker
            var dist = point_distance(x, y, player_last_known_x, player_last_known_y);
            if (dist <= other._shoot_range_px && attack_cd_timer <= 0) {    
                changeState(STATES.ATTACK); 
            }            
        }
    }
    
}

