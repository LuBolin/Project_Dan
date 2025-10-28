/// @description FSM States
/// States to be used in Enemy's FSM

function BoarAlertState(_entity, _duration = undefined, _is_timed = false) : AlertState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        charge = false;
        with (entity) {
            // Creates the '!' pop up to indicate the enemy has detected the player
            instance_create_layer(x, y - sprite_height / 2 - 10, "Effects", obj_enemy_alert_popup);
            
            if (distance_to_object(obj_player) < global.UNIT_LENGTH * 2 and !has_charged) {
                changeState(STATES.ATTACK)
            } else {
                changeState(STATES.CHASE)
            }
            
        }
    }

}

function BoarChaseState(_entity, _duration = 3000, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {
    
    on_step = function() {
        path_remaining_time -= 1;

        if (path_remaining_time <= 0) {
            path_remaining_time = path_reset_timer;
            set_path(entity);
        }
        
        with (entity) {
            // Properly get player coordinates, with safety checks
            var _player_x = obj_player.x;
            var _player_y = obj_player.y;
            
            // Safety check: make sure player exists and coordinates are valid
            if (!instance_exists(obj_player)) {
                // Player doesn't exist, return to roam state
                changeState(STATES.ROAM);
                exit;
            }
            
            // Check if player_last_known position is defined, use as fallback
            if (variable_instance_exists(self, "player_last_known_x") && 
                variable_instance_exists(self, "player_last_known_y")) {
                
                // Use last known position if current position seems invalid
                if (!is_real(_player_x) || !is_real(_player_y)) {
                    _player_x = player_last_known_x;
                    _player_y = player_last_known_y;
                }
            }
            
            // Final safety check
            if (!is_real(_player_x) || !is_real(_player_y)) {
                show_debug_message("Boar: Invalid player coordinates, returning to roam");
                changeState(STATES.ROAM);
                exit;
            }
            
            var _sight_line = collision_line(x, y, _player_x, _player_y, colliders, false, true);
            if (distance_to_object(obj_player) < global.UNIT_LENGTH * 2 && !has_charged && _sight_line == noone) {
                changeState(STATES.ATTACK);
            } 
        }
    }
    
    on_timeout = function() {
        remaining_time = duration;
        entity.has_charged = false;
        entity.changeState(STATES.ROAM);
    }
}

function BoarAttackState(_entity, _duration = 700, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        obj_sfx_manager.play_sound(snd_boar, true);
    }

    on_timeout = function() {
        
        spawn_and_set_projectile(entity, new ProjectilEnemyAir(false, 102, 10), entity.player_last_known_x, entity.player_last_known_y)
        remaining_time = duration;
        entity.has_charged = true;
        entity.changeState(STATES.CHASE)
    }

}

