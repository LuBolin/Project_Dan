/// @description Fire Boar FSM States
/// Custom states for the Fire Boar miniboss


function FireBoarRoamState(_entity, _duration = 2000, _is_timed = true) : RoamState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        create_env_hazard(obj_lava_pool, 6, true, false);
    }
}

function FireBoarAlertState(_entity, _duration = undefined, _is_timed = false) : AlertState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        with (entity) {
            // Creates the '!' pop up to indicate the enemy has detected the player
            instance_create_layer(x, y - sprite_height / 2 - 10, "Effects", obj_enemy_alert_popup);

            changeState(STATES.ATTACK)

        }
    }
}

function FireBoarChaseState(_entity, _duration = 5000, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {
    // FIREBALL
    rock_attack_freq = 3 * game_get_speed(gamespeed_fps); // 1.5 seconds 
    rock_attack_cd = 0;
    
    on_enter = function() {
        rock_attack_cd = rock_attack_freq; 
    }
    
    on_step = function() {
        // Safety check: ensure entity still exists
        if (!instance_exists(entity)) {
            return;
        }

        path_remaining_time -= 1;

        if (path_remaining_time <= 0) {
            path_remaining_time = path_reset_timer;
            set_path(entity);
        }
        rock_attack_cd -= 1;    
        with (entity) {
            
            // Safety check: make sure player exists BEFORE accessing coordinates
            if (!instance_exists(obj_player)) {
                // Player doesn't exist, return to roam state
                changeState(STATES.ROAM);
                exit;
            } 
            
            
            // Check if player_last_known position is defined before using
            var _sight_line = collision_line(x, y, player_last_known_x, player_last_known_y, obj_player.colliders, false, true);
            
            // Shoot fireballs while chasing
            if (other.rock_attack_cd <= 0 and _sight_line == noone) {
                // Calculate direction to player
                var boss_rock = new ProjectileRock();
        		boss_rock.speed = 6.0; // half speed
        		boss_rock.scale = 2; // 1.5 size
                boss_rock.life_steps = infinity
                
                var rock_proj = spawn_and_set_projectile(self, boss_rock, player_last_known_x, player_last_known_y, obj_enemy_projectile);
                rock_proj.image_blend = c_red;
                // Reset cooldown
                other.rock_attack_cd = other.rock_attack_freq;

                // Play projectile sound (using air projectile sound as placeholder for fireball)
                // TODO: Replace with snd_fireball when available
                obj_sfx_manager.play_sound(snd_air_projectile, true);
            }
        }
        show_debug_message(remaining_time)
    }

    on_timeout = function() {
        // Check for charge attack opportunity
        var _sight_line = collision_line(entity.x, entity.y, entity.player_last_known_x, entity.player_last_known_x, obj_player.colliders, false, true);
        if (_sight_line == noone) {
            remaining_time = duration
            entity.changeState(STATES.ATTACK)
        }
    }
    
    on_player_interact = function() {
        
    }
}

function FireBoarAttackState(_entity, _duration = 700, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
    player_previous_x = 0 ;
    plater_previous_y = 0;
    on_enter = function() {
        obj_sfx_manager.play_sound(snd_boar, true);
        
        // Safety check: make sure player exists BEFORE accessing coordinates
        if (!instance_exists(obj_player)) {
            // Player doesn't exist, return to roam state
            changeState(STATES.ROAM);
            exit;
        } 
        
        player_previous_x = obj_player.x;
        player_previous_y = obj_player.y;

        // Shoot a burst of fireballs when starting charge
        with (entity) {
            if (instance_exists(obj_player)) {
                // Shoot 3 fireballs in a spread pattern
                var base_dir = point_direction(x, y, obj_player.x, obj_player.y);
                var spread_angle = 30; // Degrees between fireballs
                for (var i = -1; i <= 1; i++) {
                    
                    var boss_fire_ball = new ProjectileFire();
                    boss_fire_ball.speed = 6.0; // half speed 
                    boss_fire_ball.scale = 1.0; // 1.5 size                   
                    spawn_and_set_projectile_angled(self, boss_fire_ball, base_dir + (i * spread_angle), obj_enemy_projectile); 
                }
            }
        }
    }

    on_timeout = function() {
        // Regular charge attack (wind gust)
        spawn_and_set_projectile(entity, new ProjectilEnemyAir(false, 102, 30), player_previous_x, player_previous_y)
        remaining_time = duration;
        entity.changeState(STATES.CHASE)
    }
}