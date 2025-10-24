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

function BoarChaseState(_entity, _duration = 120, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {
    
    on_step = function() {
        with (entity) {
            var _hor = clamp(player_last_known_x - x, -1, 1)
            var _vert = clamp(player_last_known_y - y, -1, 1)
            move(self, _hor, _vert)
               
            if (distance_to_object(obj_player) < global.UNIT_LENGTH * 2 and !has_charged) {
                changeState(STATES.ATTACK)
            } 
        }
        
    }
    
    on_timeout = function() {
        remaining_time = duration;
        entity.has_charged = false;
        entity.changeState(STATES.ROAM);
    }
}

function BoarAttackState(_entity, _duration = 38, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        obj_sfx_manager.play_sound(snd_boar, true);
    }

    on_timeout = function() {
        spawn_and_set_projectile(entity, new ProjectileAir(false, 102, 10), entity.player_last_known_x, entity.player_last_known_y)
        remaining_time = duration;
        entity.has_charged = true;
        entity.changeState(STATES.CHASE)
    }

}

