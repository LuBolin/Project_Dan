/// @description FSM States
/// States to be used in Enemy's FSM

function BoarAlertState(_entity, _duration = undefined, _is_timed = false) : AlertState(_entity, _duration, _is_timed) constructor {
    id = STATES.ALERT;
    
    on_timeout = function() {
        changeState(STATES.ATTACK)
    }
}

function BoarAttackState(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ATTACK;
    
    on_timeout = function() {
        spawn_and_set_projectile(entity, new ProjectileAir(), entity.player_last_known_x, entity.player_last_known_y) 
        remaining_time = duration
        changeState(STATES.CHASE)
    }

}

