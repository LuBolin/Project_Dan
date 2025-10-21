/// @description FSM States
/// States to be used in Enemy's FSM

enum STATES {
    IDLE,
    ROAM,
    ALERT,
    CHASE,
    ATTACK
}

/// @function State()
/// @description Base State constructor
function State(_entity, _duration, _is_timed) constructor {
    entity = _entity
    id = STATES.IDLE;
    duration = _duration
    remaining_time = _duration
    is_timed = _is_timed

    /// @function enter()
    /// @description Called when the state is activated
    enter = function() {
        on_enter()
    }
    
    /// @function on_step()
    /// @description Override this - called at the start
    on_enter = function() {
        // Override in child classes
    }
    
    /// @function step()
    /// @description Called every frame while active
    step = function() {
        if (is_timed) {
            remaining_time--;
            if (remaining_time <= 0) {
                on_timeout()
            }
        }
        on_step();
    }

    /// @function on_step()
    /// @description Override this - called every frame
    on_step = function() {
        // Override in child classes
    }
    
    /// @function leave()
    /// @description Called when the state expires or is removed
    leave = function() {
        on_leave();
    }

    /// @function on_leave()
    /// @description Override this - called when state is removed
    on_leave = function() {
        // Override in child classes
    }
    
    /// @function on_leave()
    /// @description When the enemy interacts in any way with the player
    player_interact = function() {
        on_player_interact()
    }
    
    /// @function on_player_interact()
    /// @description Override this - called when there's player interaction
    on_player_interact = function() {
        // Override in child classes
    }
    
    /// @function on_player_interact()
    /// @description Override this - called when there's player interaction
    on_timeout = function() {
        
    }
    
}

function RoamState(_entity, _duration = 20, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ROAM;
    _target_x = _entity.x
    _target_y = _entity.y
    remaining_time = 1;
    
    on_step = function() {
        with entity {
            var _hor = clamp(other._target_x - x, -1, 1)
            var _vert = clamp(other._target_y - y, -1, 1)
            move(other.entity, _hor, _vert)
        }
    }
    
    on_timeout = function() {
        // Absolutely Basic Roam Behaviour
        _target_x = random_range(entity.xstart - global.UNIT_LENGTH , entity.xstart + global.UNIT_LENGTH)
        _target_y = random_range(entity.ystart - global.UNIT_LENGTH, entity.ystart + global.UNIT_LENGTH)
        remaining_time = duration
    }
    
    on_player_interact = function() {
        with (entity) {
            player_last_known_x = obj_player.x;
            player_last_known_y = obj_player.y;
            changeState(STATES.ALERT);
        }
    }
    
}

function AlertState(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ALERT;
    
    on_enter = function() {
        // Creates the '!' pop up to indicate the enemy has detected the player
        with entity {
            instance_create_layer(x, y - sprite_height / 2 - 10, "Effects", obj_enemy_alert_popup);
            changeState(STATES.CHASE);
        }
        
    }
    
}

function ChaseState(_entity, _duration = 120, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {    
    id = STATES.CHASE;
    
    on_step = function() {
        with entity {
            var _hor = clamp(player_last_known_x - x, -1, 1)
            var _vert = clamp(player_last_known_y - y, -1, 1)
            move(self, _hor, _vert)   
        }
        
    }
    
    on_timeout = function() {
        remaining_time = duration
        entity.changeState(STATES.ROAM);
    }
    
    on_player_interact = function() {
        remaining_time = duration;
    }
}

// Dummy Attack State for zombie
function AttackState(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ATTACK;
    
    on_enter = function() {
        entity.changeState(STATES.ROAM);
    }

}

function move(entity, _hor, _vert) {
    
    with entity {
        var magnitude = sqrt(_hor * _hor + _vert * _vert)
        
        if (magnitude != 0) {
            // Convert units per second to pixels per frame
            // units/sec * pixels/unit / frames/sec = pixels/frame
            var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
        
            var _norm_hor = (_hor / magnitude) * move_speed_this_frame;
            var _norm_vert = (_vert / magnitude) * move_speed_this_frame;
    
            if (place_meeting(x + _norm_hor, y, colliders)) {
        
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + _norm_hor, y + move_speed_this_frame, colliders)) {
                    y += move_speed_this_frame
                } else if (!place_meeting(x + _norm_hor, y - move_speed_this_frame, colliders)) {
                    y -= move_speed_this_frame
                } else {
                    _norm_hor = 0;   
                }
                
            }
            
            x += _norm_hor;
            
            if (place_meeting(x, y + _norm_vert, colliders)) {
                
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + move_speed_this_frame, y + _norm_vert , colliders)) {
                    x += move_speed_this_frame
                } else if (!place_meeting(x - move_speed_this_frame, y + _norm_vert, colliders)) {
                    x -= move_speed_this_frame
                } else {
                    _norm_vert = 0;   
                }
            }
            
            y += _norm_vert;
        }        
    }

}