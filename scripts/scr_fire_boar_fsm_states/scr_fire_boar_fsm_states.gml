/// @description Fire Boar FSM States
/// Custom states for the Fire Boar miniboss

function FireBoarAlertState(_entity, _duration = undefined, _is_timed = false) : AlertState(_entity, _duration, _is_timed) constructor {
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

function FireBoarChaseState(_entity, _duration = 3000, _is_timed = true) : ChaseState(_entity, _duration, _is_timed) constructor {

    on_step = function() {
        path_remaining_time -= 1;

        if (path_remaining_time <= 0) {
            path_remaining_time = path_reset_timer;
            set_path(entity);
        }

        with (entity) {
            // Shoot fireballs while chasing
            if (fireball_cooldown <= 0 && instance_exists(obj_player)) {
                // Calculate direction to player
                var dir = point_direction(x, y, obj_player.x, obj_player.y);

                // Create and shoot fireball projectile
                var fireball = instance_create_depth(x, y, depth - 1, obj_enemy_projectile);
                fireball.projectile_type = new ProjectileFire();
                fireball.damage = 1; // Fire damage
                fireball.direction = dir;
                fireball.speed = fireball.projectile_type.speed;
                fireball.sprite_index = fireball.projectile_type.sprite_index;
                fireball.life_steps = fireball.projectile_type.life_steps;

                // Reset cooldown
                fireball_cooldown = fireball_cooldown_max;

                // Play projectile sound (using air projectile sound as placeholder for fireball)
                // TODO: Replace with snd_fireball when available
                obj_sfx_manager.play_sound(snd_air_projectile, true);
            }

            // Check for charge attack opportunity
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

function FireBoarAttackState(_entity, _duration = 700, _is_timed = true) : AttackState(_entity, _duration, _is_timed) constructor {
    on_enter = function() {
        obj_sfx_manager.play_sound(snd_boar, true);

        // Shoot a burst of fireballs when starting charge
        with (entity) {
            if (instance_exists(obj_player)) {
                // Shoot 3 fireballs in a spread pattern
                var base_dir = point_direction(x, y, obj_player.x, obj_player.y);
                var spread_angle = 15; // Degrees between fireballs

                for (var i = -1; i <= 1; i++) {
                    var fireball = instance_create_depth(x, y, depth - 1, obj_enemy_projectile);
                    fireball.projectile_type = new ProjectileFire();
                    fireball.damage = 1;
                    fireball.direction = base_dir + (i * spread_angle);
                    fireball.speed = fireball.projectile_type.speed;
                    fireball.sprite_index = fireball.projectile_type.sprite_index;
                    fireball.life_steps = fireball.projectile_type.life_steps;
                }

                // Reset fireball cooldown
                fireball_cooldown = fireball_cooldown_max;
            }
        }
    }

    on_timeout = function() {
        // Regular charge attack (wind gust)
        spawn_and_set_projectile(entity, new ProjectileAir(false, 102, 10), entity.player_last_known_x, entity.player_last_known_y)
        remaining_time = duration;
        entity.has_charged = true;
        entity.changeState(STATES.CHASE)
    }
}