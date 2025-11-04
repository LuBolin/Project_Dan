/// @description FSM States
/// States to be used in Enemy's FSM

function FinalBossPhase_1(_entity, _duration = -1, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {    
    id = STATES.ATTACK;
    
    // FIREBALL
    fireball_attack_freq = 1.5 * game_get_speed(gamespeed_fps); // 1.5 seconds
    fireball_attack_cd_timer = 0;
    
    // LAVA
    lava_attack_freq = 8 * game_get_speed(gamespeed_fps); // 8 seconds
    lava_attack_cd_timer = lava_attack_freq;
    
    lava_spawn_x = -1;
    lava_spawn_y = -1;
    
    // CONVERT TELEGRAPH TIMING TO SECONDS-BASED
    telegraph_lava_attack_blink_duration_seconds = 0.167; // 0.167 seconds between blinks
    telegraph_lava_attack_blink_freq = telegraph_lava_attack_blink_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames
    telegraph_lava_attack_blink_cd = 0;
    telegraph_lava_attack_blink_num = 0;
    do_telegraph_lava_show = false;    
    telegraph_total_blinks = 6; // Total number of blinks before attack (was 3, now 6 for longer warning)
    telegraph_total_duration_seconds = 1.5; // Total telegraph duration: 3 seconds
    telegraph_total_duration = telegraph_total_duration_seconds * game_get_speed(gamespeed_fps);
    
    // SECOND ROUND OF PHASE 1
    is_second_round = false;
    
    num_mud_hazards = 8;
    
    on_enter = function() {

        fireball_attack_cd_timer = 0;

        if (is_second_round) {
            lava_attack_cd_timer = 0;
            create_env_hazard(obj_mud_pool ,num_mud_hazards, true);
            spawn_more_enemies();
        } else {
            lava_attack_cd_timer = lava_attack_freq;
        }
                
        lava_spawn_x = -1;
        lava_spawn_y = -1;
        
        telegraph_lava_attack_blink_freq = telegraph_lava_attack_blink_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames
        telegraph_lava_attack_blink_cd = 0;
        telegraph_lava_attack_blink_num = 0;
        do_telegraph_lava_show = false;      
    }
    
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
        
		var boss_fire_ball = new ProjectileFire();
		boss_fire_ball.speed = 6.0; // half speed
		boss_fire_ball.scale = 1.5; // 1.5 size
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
                    boss_lava_pool.scale = 2;               // Set the Lava to be bigger so the player has less room to "camp"
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
        if (do_telegraph_lava_show) {
            draw_circle_color(lava_spawn_x, lava_spawn_y, 30, c_yellow, c_yellow, false);        
        }
    }
}

function FinalBossPhase_2(_entity, _duration = undefined, _is_timed = false) : State(_entity, _duration, _is_timed) constructor {
    path_reset_timer = 30; // This is a separate timer for pathfinding
    path_remaining_time = path_reset_timer;
    
    steam_attack_freq = 4 * game_get_speed(gamespeed_fps); // 4 seconds
    steam_attack_cd_timer = 0;
    
    air_lunge_freq = 5 * game_get_speed(gamespeed_fps); // 8 seconds  
    air_lunge_cd_timer = 0;
    
    nearby_centre_radius = 20;
    runaway_speed = 3;
    chase_speed = 2.7;
    
    // SECOND ROUND OF PHASE 1
    is_second_round = false;
    
    on_enter = function() {
        chase_speed = instance_exists(obj_player) ? obj_player.move_speed_ups * (3/4) : chase_speed;
    }
    
    on_step = function() {

        if !instance_exists(obj_player) {
            exit;
        }
        
        if (!is_second_round && entity.hp <= 20) {
            entity.move_speed_ups = runaway_speed;
            set_path(entity, obj_final_boss_centre.x, obj_final_boss_centre.y);
            if (point_distance(entity.x, entity.y, obj_final_boss_centre.x, obj_final_boss_centre.y) <= nearby_centre_radius) {
                is_second_round = true;
                entity.changeState(STATES.ATTACK);
                exit;
            }
            
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
            var steam = instance_create_layer(entity.x, entity.y, "Instances", obj_steam);
            steam.owner = entity;
            steam.damage_enemies = false;
            steam_attack_cd_timer = steam_attack_freq;
        }
        
        var _sight_line = collision_line(entity.x, entity.y, obj_player.x, obj_player.y, obj_player.colliders, false, true);
        if (air_lunge_cd_timer <= 0 and _sight_line == noone) {
            spawn_and_set_projectile(entity, new ProjectilEnemyAir(false, 102, 10), obj_player.x, obj_player.y);
            air_lunge_cd_timer = air_lunge_freq;
        }
        

    }
}

function create_env_hazard(obj_hazard, num_hazards, _is_permanent = true, _is_affect_enemy = true) {
    // Borrowed from Level Manager code. Thanks!
    // Get all spawn points in the room
    var spawn_points = [];
    
    with (obj_env_hazard_spawn) {
        array_push(spawn_points, id);
    }
    
    var spawn_points_len = array_length(spawn_points)
    if (num_hazards >= spawn_points_len) {
        show_debug_message("Trying to spawn more Hazards than spawn points available! :<")
        num_hazards = spawn_points_len
    }
    
    spawn_points = array_shuffle(spawn_points, _is_permanent = true);
    
    for (var i = 0; i < num_hazards; i+= 1) {
        var spawn_point = spawn_points[i]
        var env = instance_create_layer(spawn_point.x, spawn_point.y, "Instances", obj_hazard);
        env.damage_player = true; 
        env.is_forever = _is_permanent;
        env.damage_enemies = _is_affect_enemy;
        // Visual differentiation - make boss lava pools red-tinted
        env.image_blend = make_color_rgb(255, 150, 150);
    }
}

function spawn_more_enemies() {
    var spawn_points = [];
    nearby_centre_radius = 20;
    
    with (obj_enemy_conditional_spawn_point) {
        array_push(spawn_points, id);
    }
    var spawn_points_len = array_length(spawn_points)
    for (var i = 0; i < spawn_points_len; i+= 1) {
        var spawn_point = spawn_points[i]
        
        var inst = collision_circle(spawn_point.x, spawn_point.y, 30, [obj_enemy_abstract, obj_player], false, true);
        if (inst == noone) { 
            // Spawn enemy at spawn point
            var enemy = instance_create_depth(spawn_point.x, spawn_point.y, 0, spawn_point.enemy_to_spawn);
            //TODO: REMIND ME TO CHANGE THIS
            enemy.curr_state = enemy.states_array[STATES.ROAM];
            enemy.curr_state.enter();
        }

    }
}