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
            // Check if player_last_known position is defined before using
            if (variable_instance_exists(self, "player_last_known_x") &&
                variable_instance_exists(self, "player_last_known_y")) {
                var _player_x = player_last_known_x ?? x;
                var _player_y = player_last_known_y ?? y;
                var dist = point_distance(x, y, _player_x, _player_y);
                var _sight_line = collision_line(x, y, _player_x, _player_y, colliders, false, true);
                if (attack_cd_timer <= 0 && _sight_line == noone) { 
                    changeState(STATES.ATTACK);
                }
            }
        }
    }
    
}

/// Stands still (no movement here), after a brief wind-up (duration frames), 
/// fires once at player_last_known_ then returns to CHASE
function EvilTreeAttackState(_entity, _duration = 800, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {

    on_enter = function() {
        remaining_time = duration; // wind-up
    }

    on_step = function() {
        // stand still / play charge anim if have
    }

    on_timeout = function() {
        // SAFETY CHECK: Make sure player still exists before shooting
        if (instance_exists(obj_player)) {
            spawn_and_set_projectile(entity, new ProjectileGhost(), obj_player.x, obj_player.y, obj_enemy_projectile);
        } else {
            // Player is dead, use last known position or don't shoot
            if (variable_instance_exists(entity, "player_last_known_x") && 
                variable_instance_exists(entity, "player_last_known_y") &&
                is_real(entity.player_last_known_x) && 
                is_real(entity.player_last_known_y)) {
                spawn_and_set_projectile(entity, new ProjectileGhost(), entity.player_last_known_x, entity.player_last_known_y, obj_enemy_projectile);
            } else {
                show_debug_message("Evil Tree: Player dead, skipping projectile shot");
            }
        }
        
        entity.attack_cd_timer = entity.attack_cooldown_sec * game_get_speed(gamespeed_fps);
        entity.changeState(STATES.CHASE);
    }
}
