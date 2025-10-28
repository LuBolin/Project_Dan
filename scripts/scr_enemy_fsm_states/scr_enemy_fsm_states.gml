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

            remaining_time -= (delta_time / 1000);
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
    
    /// @function player_interact()
    /// @description When the enemy interacts in any way with the player
    player_interact = function() {
        on_player_interact()
    }

    /// @function on_player_interact()
    /// @description Override this - called when there's player interaction
    on_player_interact = function() {
        // Override in child classes
    }
    
    /// @function draw()
    /// @description Override this, called on draww step
    draw = function() {
        // Override in child classes     
    }
    
    /// @function on_player_interact()
    /// @description Override this - called when there's player interaction
    on_timeout = function() {
        
    }
    
}

function RoamState(_entity, _duration = 2000, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ROAM;
    _target_x = _entity.x
    _target_y = _entity.y
    remaining_time = 1;
    path = path_add();
    
    on_timeout = function() {
        // Absolutely Basic Roam Behaviour
        _target_x = random_range(entity.xstart - global.UNIT_LENGTH / 2, entity.xstart + global.UNIT_LENGTH /2)
        _target_y = random_range(entity.ystart - global.UNIT_LENGTH / 2, entity.ystart + global.UNIT_LENGTH / 2) 
        set_path(entity, _target_x, _target_y);
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

function ChaseState(_entity, _duration = 3000, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {    
    id = STATES.CHASE;
    path_reset_timer = 30; // This is a separate timer for pathfinding
    path_remaining_time = path_reset_timer;
    
    on_step = function() {
        path_remaining_time -= 1;
   
        if (path_remaining_time <= 0) {
            path_remaining_time = path_reset_timer;
            set_path(entity);
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

function set_path(entity, _target_x = entity.player_last_known_x, _target_y = entity.player_last_known_y) {
    with (entity) { 
        pause = false; 
        path_delete(path);
        path = path_add();
        var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
        mp_grid_path(obj_level_manager.pathfinding_grid, path, x, y, _target_x, _target_y, 1);
            
        path_start(path, move_speed_this_frame, path_action_stop, true);
    }
}