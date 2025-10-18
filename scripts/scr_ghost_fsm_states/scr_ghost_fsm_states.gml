/// @description FSM States
/// States to be used in Enemy's FSMfunction scr_ghost_fsm_states(){

function GhostAlertState(_entity, _duration = undefined, _is_timed = false) : AlertState(_entity, _duration, _is_timed) constructor {
    id = STATES.ALERT;

    on_timeout = function() {
        changeState(STATES.CHASE);
    }
}

/// - Chases until within shooting range, then switches to ATTACK
function GhostChaseState(_entity, _duration = 8, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.CHASE;

    // Range in pixels (units → pixels), can add attack_range_units to ghost
    _range_units = (variable_instance_exists(entity, "attack_range_units") && is_real(entity.attack_range_units))
        ? entity.attack_range_units : 4; // default 4 units
    _shoot_range_px = _range_units * global.UNIT_LENGTH;

    on_step = function() {
		var go_attack = false;
		
        with (entity) {
            // Distance to last known player position
            var dx = player_last_known_x - x;
            var dy = player_last_known_y - y;
            var dist = point_distance(x, y, player_last_known_x, player_last_known_y);

            // If close enough, attack
            if (dist <= other._shoot_range_px && attack_cd_timer <= 0) {
                go_attack = true;
            } else {
				// Otherwise, keep chasing
				var _hor = clamp(dx, -1, 1);
				var _vert = clamp(dy, -1, 1);
				var mag = sqrt(_hor * _hor + _vert * _vert);

				if (mag != 0) {
					var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
					var _nx = (_hor / mag) * move_speed_this_frame;
					var _ny = (_vert / mag) * move_speed_this_frame;
					move_and_collide(_nx, _ny, colliders);
				}
			}
        }
		
		if (go_attack) {
			changeState(STATES.ATTACK);
		}
    }
	
	on_timeout = function() {
        changeState(STATES.ROAM);
    }

    // If we “see”/interact with the player again, refresh the chase timer
    on_player_interact = function() {
        if (is_timed) remaining_time = duration;
    }
}

/// Stands still (no movement here), after a brief wind-up (duration frames), 
/// fires once at player_last_known_ then returns to CHASE
function GhostAttackState(_entity, _duration = 18, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.ATTACK;

    _tx = undefined;
    _ty = undefined;

    on_enter = function() {
        remaining_time = duration; // wind-up
        _tx = entity.player_last_known_x;
        _ty = entity.player_last_known_y;

        // Fallback: if last-known is undefined, don't crash
        if (!is_real(_tx) || !is_real(_ty)) {
            _tx = entity.x;
            _ty = entity.y; // or skip shooting entirely; your call
        }
    }

    on_step = function() {
        // stand still / play charge anim if have
    }

    on_timeout = function() {
		// pass the ghost instance and player coords so spawn_and_set_projectile computes angle correctly
		spawn_and_set_projectile(entity, new ProjectileGhost(), _tx, _ty);
		entity.attack_cd_timer = entity.attack_cooldown_sec * game_get_speed(gamespeed_fps);
        
        changeState(STATES.CHASE);
    }
}