function MiniBossTreeRoamState(_entity, _duration = undefined, _is_timed = false) : RoamState(_entity, _duration, _is_timed) constructor {

    on_enter = function() {
        create_env_hazard(obj_mud_pool, 5, true, false);
    }
}

function MiniBossTreeChaseState(_entity, _duration = 3000, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.CHASE;
    
 
}

/// Stands still (no movement here), after a brief wind-up (duration frames), 
/// fires once at player_last_known_ then returns to CHASE
function MiniBossTreeAttackState(_entity, _duration = 800, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
   // Normal Attack
    bullet_attack_freq = 1.5 * game_get_speed(gamespeed_fps); // 1.5 seconds
    bullet_attack_cd_timer = 0;
    
    // BOULDER
    boulder_attack_freq = 8 * game_get_speed(gamespeed_fps); // 8 seconds
    boulder_attack_cd_timer = boulder_attack_freq;
    
    // CONVERT TELEGRAPH TIMING TO SECONDS-BASED
    telegraph_boulder_attack_blink_duration_seconds = 0.167; // 0.167 seconds between blinks
    telegraph_boulder_attack_blink_freq = telegraph_lava_attack_blink_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames
    telegraph_boulder_attack_blink_cd = 0;
    telegraph_boulder_attack_blink_num = 0;
    do_telegraph_boulder_show = false;    
    telegraph_total_blinks = 6; // Total number of blinks before attack (was 3, now 6 for longer warning)
    telegraph_total_duration_seconds = 1.5; // Total telegraph duration: 3 seconds
    telegraph_total_duration = telegraph_total_duration_seconds * game_get_speed(gamespeed_fps);
    
    on_enter = function() {

        bullet_attack_cd_timer = 0;

        boulder_attack_cd_timer = boulder_attack_freq;
        
        telegraph_boulder_attack_blink_freq = telegraph_boulder_attack_blink_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames
        telegraph_boulder_attack_blink_cd = 0;
        telegraph_boulder_attack_blink_num = 0;
        do_telegraph_boulder_show = false;      
    }
    
    on_step = function() {

        if !instance_exists(obj_player) {
            exit;
        }
        
        // Check if player_last_known position is defined before using
        var _sight_line = collision_line(entity.x, entity.y, obj_player.x, obj_player.y, obj_player.colliders, false, true);
        
        if (!entity.pause) {
            bullet_attack_cd_timer--;
            boulder_attack_cd_timer--;
        }
        
		var boss_fire_ball = new ProjectileGhost();
        boss_fire_ball.life_steps = infinity;
		
        if (fireball_attack_cd_timer <= 0 and _sight_line == noone) {
            spawn_and_set_projectile(entity, boss_fire_ball, obj_player.x, obj_player.y, obj_enemy_projectile);
            fireball_attack_cd_timer = fireball_attack_freq;
        }
        
        if (lava_attack_cd_timer <= 0) {
            if (lava_spawn_x == -1 and lava_spawn_y == -1) {
                lava_spawn_x = obj_player.x;
                lava_spawn_y = obj_player.y;
                // Start telegraph timer when we first target the player
                telegraph_lava_attack_blink_cd = telegraph_lava_attack_blink_freq;
                telegraph_lava_attack_blink_num = 0;
                do_telegraph_lava_show = true; // Start showing immediately
            }
            
            // Check if enough blinks have occurred OR total time has elapsed
            if (telegraph_lava_attack_blink_num >= telegraph_total_blinks && (lava_spawn_x != -1 and lava_spawn_y != -1)) {
                // Create lava pool that damages the player
                var boss_lava_pool = instance_create_layer(lava_spawn_x, lava_spawn_y, "Instances", obj_lava_pool);
                
                if (instance_exists(boss_lava_pool)) {
                    // Configure this lava pool to damage the player instead of enemies
                    boss_lava_pool.damage_enemies = false;  // Don't damage enemies
                    boss_lava_pool.damage_player = true;    // Damage the player
                    boss_lava_pool.creator = entity;        // Set boss as creator
                    
                    // Make boss lava pools more threatening // Higher damage
                    // UPDATE NOTE: Made it lower damage cuz player dies way too quickly
                    boss_lava_pool.damage_per_tick = 1;     
                    boss_lava_pool.life_timer = game_get_speed(gamespeed_fps) * 12; // Last longer
                    
                    // Visual differentiation - make boss lava pools red-tinted
                    boss_lava_pool.image_blend = make_color_rgb(255, 150, 150);
                    
                    show_debug_message("Boss spawned player-damaging lava pool at " + string(lava_spawn_x) + ", " + string(lava_spawn_y));
                }

                // Reset variables
                lava_attack_cd_timer = lava_attack_freq;
                lava_spawn_x = -1;
                lava_spawn_y = -1;
                        
                // Reset telegraph timing
                telegraph_lava_attack_blink_freq = telegraph_lava_attack_blink_duration_seconds * game_get_speed(gamespeed_fps);
                telegraph_lava_attack_blink_cd = 0;
                telegraph_lava_attack_blink_num = 0;
                do_telegraph_lava_show = false;
                
            } else if (lava_spawn_x != -1 && lava_spawn_y != -1) {
                // Continue telegraphing
                telegraph_lava_attack_blink_cd--;
                if (telegraph_lava_attack_blink_cd <= 0) {
                    do_telegraph_lava_show = !do_telegraph_lava_show;
                    telegraph_lava_attack_blink_cd = telegraph_lava_attack_blink_freq;
                    telegraph_lava_attack_blink_num += 1;
                }
            } else {
                show_debug_message("ERROR: Telegraphing failed due to invalid spawn coordinates!")
            }
        }
    
        if ((!is_second_round && entity.hp <= 30) || (entity.hp <= 10)) {
            is_second_round = true;
            entity.changeState(STATES.CHASE);
        }
    }
    
    draw = function() {
        if (do_telegraph_boulder_show) {
            //draw_rectangle_color() 
            draw_circle_color(lava_spawn_x, lava_spawn_y, 30, c_yellow, c_yellow, false);        
        }
    }
}
