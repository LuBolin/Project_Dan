/// @description Chase State 
/// Chase State used Enemy's FSM

enum STATES {
    IDLE,
    ROAM,
    ALERT,
    CHASE,
    ATTACK
}

function changeState(next_state) {
    curr_state = states_array[next_state]
}

/// @function ChaseState()
/// @description Base Chase State constructor
function State(_entity, _duration = undefined, _is_timed = false) constructor {
    entity = _entity
    id = STATES.IDLE;
    duration = _duration
    remaining_time = _duration
    is_timed = _is_timed

    enter = function() {
        on_enter()
    }
    
    on_enter = function() {
        // Override in child classes
    }
    
    /// @function step()
    /// @description Called every frame while active
    step = function() {
        remaining_time--;
        if (is_timed or remaining_time) {
            on_timeout()
        }
        on_step();
    }

    /// @function on_step()
    /// @description Override this - called every frame
    on_step = function() {
        // Override in child classes
    }
    
    /// @function leave()
    /// @description Called when the effect expires or is removed
    leave = function() {
        on_leave();
    }

    /// @function on_leave()
    /// @description Override this - called when effect is removed
    on_leave = function() {
        // Override in child classes
    }
    
    // This is mostly for the Chase, basically any interaction from the player
    player_interact = function() {
        on_player_interact()
    }
    
    on_player_interact = function() {
        // Override in child classes
    }
    
    on_timeout = function() {
        
    }
    
}

function RoamState(_entity, _duration = 300, _is_timed = true) : State(_entity, _duration = undefined, _is_timed = false) constructor {
    id = STATES.ROAM;
    _target_x = random_range(entity.xstart - 100, entity.xstart + 100)
    _target_y = random_range(entity.ystart - 100, entity.ystart + 100)
    
    on_step = function() {
        with entity {
            var _hor = clamp(other._target_x - x, -1, 1)
            var _vert = clamp(other._target_y - y, -1, 1)
            
            var magnitude = sqrt(_hor * _hor + _vert * _vert)
            
            if (magnitude != 0) {
                // Convert units per second to pixels per frame
                // units/sec * pixels/unit / frames/sec = pixels/frame
                var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
            
                var _norm_hor = (_hor / magnitude) * move_speed_this_frame;
                var _norm_vert = (_vert / magnitude) * move_speed_this_frame;
                show_debug_message(_norm_hor)
                show_debug_message(_norm_vert)
                show_debug_message(move_speed_this_frame)
                show_debug_message(move_speed_ups)
                move_and_collide(_norm_hor, _norm_vert, colliders)
            }
        }
    }
    
    on_timeout = function() {
        // Absolutely Basic Roam Behaviour
        show_debug_message("AAAAA")
        _target_x = random_range(entity.xstart - 100, entity.xstart + 100)
        _target_y = random_range(entity.ystart - 100, entity.ystart + 100)
        remaining_time = duration
    }
    
    on_player_interact = function() {
        entity.state = STATES.CHASE;
    }
}

function AlertState(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration = undefined, _is_timed = false) constructor {
    id = STATES.ALERT;
    
    on_step = function() {
        // Was plannning on inserting a '!' pop up here to indicate the enemy has detected the player   
    }
    
    on_player_interact = function() {
        entity.state = STATES.CHASE;
    }
    
}


function ChaseState(_entity, _duration = 15, _is_timed = true) : State(_entity, _duration = undefined, _is_timed = false) constructor {    
    id = STATES.CHASE;
    
    on_step = function() {
        with entity {
            var _hor = clamp(player_last_known_x - x, -1, 1)
            var _vert = clamp(player_last_known_y - y, -1, 1)
            
            var magnitude = sqrt(_hor * _hor + _vert * _vert);
            
            if (magnitude != 0) {
                // Convert units per second to pixels per frame
                // units/sec * pixels/unit / frames/sec = pixels/frame
                var move_speed_this_frame = (entity.move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
            
                var _norm_hor = (_hor / magnitude) * move_speed_this_frame;
                var _norm_vert = (_vert / magnitude) * move_speed_this_frame;
            
                
                move_and_collide(_norm_hor, _norm_vert, ecolliders); 
            }
        }
        
    }
    
    on_timeout = function() {
        entity.state = STATES.ROAM;
    }
    
    on_player_interact = function() {
        remaining_time = duration;
    }
}


function AttackState(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration = undefined, _is_timed = false) constructor {
    id = STATES.ATTACK;
    
    
}