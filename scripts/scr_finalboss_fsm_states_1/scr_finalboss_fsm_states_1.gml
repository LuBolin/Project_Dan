/// @description FSM States
/// States to be used in Enemy's FSM

function FinalBossPhase_1(_entity, _duration = -1, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {    
    id = STATES.ATTACK;
    
    fireball_attack_freq = 1.67 * game_get_speed(gamespeed_fps); // 1.67 seconds
    fireball_attack_cd_timer = 0;
    
    lava_attack_freq = 8 * game_get_speed(gamespeed_fps); // 8 seconds
    lava_attack_cd_timer = 0;
    
    lava_spawn_x = -1;
    lava_spawn_y = -1;
    
    // CONVERT TELEGRAPH TIMING TO SECONDS-BASED
    telegraph_lava_attack_blink_duration_seconds = 0.167; // 0.167 seconds between blinks
    telegraph_lava_attack_blink_freq = telegraph_lava_attack_blink_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames
    telegraph_lava_attack_blink_cd = 0;
    telegraph_lava_attack_blink_num = 0;
    telegraph_total_blinks = 3; // Total number of blinks before attack (was 3, now 6 for longer warning)
    telegraph_total_duration_seconds = 1.5; // Total telegraph duration: 3 seconds
    telegraph_total_duration = telegraph_total_duration_seconds * game_get_speed(gamespeed_fps);
    do_telegraph_lava_show = false;
    
    on_step = function() {

        if !instance_exists(obj_player) {
            exit;
        }
        
        // Check if player_last_known position is defined before using
        var _sight_line = collision_line(entity.x, entity.y, obj_player.x, obj_player.y, obj_player.colliders, false, true);
        
        if (!entity.pause) {
            fireball_attack_cd_timer--;
            lava_attack_cd_timer--;
        }
        
        if (fireball_attack_cd_timer <= 0 and _sight_line == noone) {
            spawn_and_set_projectile(entity, new ProjectileFire(), obj_player.x, obj_player.y, obj_enemy_projectile);
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
                    
                    // Make boss lava pools more threatening
                    boss_lava_pool.damage_per_tick = 3;     // Higher damage
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
                
            } else if (lava_spawn_x != -1 and lava_spawn_y != -1) {
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
    
        if (entity.hp <= 30) {
            entity.changeState(STATES.CHASE);
        }
    }
    
    draw = function() {
        if (do_telegraph_lava_show) {
            draw_circle_color(lava_spawn_x, lava_spawn_y, 30, c_yellow, c_yellow, false);        
        }
    }
}

function FinalBossPhase_2(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {
    path_reset_timer = 30; // This is a separate timer for pathfinding
    path_remaining_time = path_reset_timer;
    g_steam = new GourdSteam(2);
    
    steam_attack_freq = 4 * game_get_speed(gamespeed_fps); // 4 seconds
    steam_attack_cd_timer = 0;
    
    air_lunge_freq = 8 * game_get_speed(gamespeed_fps); // 8 seconds  
    air_lunge_cd_timer = 0;
    
    on_step = function() {

        if !instance_exists(obj_player) {
            exit;
        }
        
        path_remaining_time -= 1;

        if (path_remaining_time <= 0) {
            path_remaining_time = path_reset_timer;
            set_path(entity, obj_player.x, obj_player.y);
        }
        
        if (!entity.pause) {
            steam_attack_cd_timer--;
            air_lunge_cd_timer--;
        }
        
        if (steam_attack_cd_timer <= 0) {
            g_steam.use(entity);
            steam_attack_cd_timer = steam_attack_freq;
        }
        
        var _sight_line = collision_line(entity.x, entity.y, obj_player.x, obj_player.y, obj_player.colliders, false, true);
        if (air_lunge_cd_timer <= 0 and _sight_line == noone) {
            spawn_and_set_projectile(entity, new ProjectilEnemyAir(false, 102, 10), obj_player.x, obj_player.y);
            air_lunge_cd_timer = air_lunge_freq;
        }
        
        if (entity.hp <= 20) {
            entity.changeState(STATES.ATTACK);
        }
    }
}

function shoot_fireball(entity) {

}
