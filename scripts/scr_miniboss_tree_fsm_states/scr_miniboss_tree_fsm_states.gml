function MiniBossTreeRoamState(_entity, _duration = undefined, _is_timed = false) : RoamState(_entity, _duration, _is_timed) constructor {

    on_enter = function() {
        create_env_hazard(obj_mud_pool, 5, true, false);
        entity.changeState(STATES.ATTACK);
    }
}

function MiniBossTreeChaseState(_entity, _duration = 8000, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.CHASE;
    
    on_enter = function() {
        
        remaining_time = duration;
        // Create a new list
        enemies = ds_list_create();
        
        // Loop through all instances of obj_enemy (example)
        with (obj_enemy_abstract) {
            if (hp < max_hp) {
                ds_list_add(other.enemies, self);
            }
            
        }
        
        if (ds_list_size(enemies) != 0) {
            var enemy_to_heal = enemies[| irandom(ds_list_size(enemies) - 1)];
            var boss_plant_pool = instance_create_layer(enemy_to_heal.x, enemy_to_heal.y, "Instances", obj_plant);
            if (instance_exists(boss_plant_pool)) {
                boss_plant_pool.heal_enemies = true;
            }
            ds_list_destroy(enemies)           
        } else {
            ds_list_destroy(enemies)
            entity.changeState(STATES.ATTACK);
        }
        
        
        
    }

    on_timeout = function() {
        entity.changeState(STATES.ATTACK);
    }
}

/// Stands still (no movement here), after a brief wind-up (duration frames), 
/// fires once at player_last_known_ then returns to CHASE
function MiniBossTreeAttackState(_entity, _duration = 6000, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
   // Normal Attack
    bullet_attack_freq = 1.5 * game_get_speed(gamespeed_fps); // 1.5 seconds
    bullet_attack_cd_timer = 0;
    
    // Hurricane
    hurricane_attack_freq = 5 * game_get_speed(gamespeed_fps); // 8 seconds
    hurricane_attack_cd_timer = hurricane_attack_freq;
    
    
    on_enter = function() {

        bullet_attack_cd_timer = 0;

        hurricane_attack_cd_timer = 5 * game_get_speed(gamespeed_fps);
        
        remaining_time = duration;
    }
    
    on_step = function() {

        if !instance_exists(obj_player) {
            exit;
        }
        
        // Check if player_last_known position is defined before using
        var _sight_line = collision_line(entity.x, entity.y, obj_player.x, obj_player.y, obj_player.colliders, false, true);
        
        if (!entity.pause) {
            bullet_attack_cd_timer--;
            hurricane_attack_cd_timer--;
        }
        
        if (bullet_attack_cd_timer <= 0 and _sight_line == noone) { 
            
            var boss_bullet = new ProjectileGhost();
            boss_bullet.life_steps = infinity;
            boss_bullet.scale = 2;
            
            spawn_and_set_projectile(entity, boss_bullet, obj_player.x, obj_player.y, obj_enemy_projectile);
            bullet_attack_cd_timer = bullet_attack_freq;
        }
        
        if (hurricane_attack_cd_timer <= 0 and _sight_line == noone) {
            var hurricane = new ProjectileHurricane()
            hurricane.scale = 0.6;
            
            hurricane.damage_player = true;
            hurricane.damage_enemies = false;
            hurricane.speed = 4;
            spawn_and_set_projectile(entity, hurricane, obj_player.x, obj_player.y, obj_enemy_projectile);
            hurricane_attack_cd_timer = hurricane_attack_freq;
        }

    }
    
    on_timeout = function() {
        entity.changeState(STATES.CHASE);
    }
    
}
