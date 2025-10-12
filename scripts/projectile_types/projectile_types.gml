function ProjectileRock() constructor {
	name = "Rock";
	speed       = 18.75;  // units per second (1200 / 64)
	damage      = 1;
	life_steps  = game_get_speed(gamespeed_fps) * 0.5;
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_rock;
	scale = 0.25;

	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		add_status_effect(target, new StunEffect(game_get_speed(gamespeed_fps) * 0.5));
		instance_destroy(projectile_inst);
	}
}

function ProjectileWaterBall() constructor {
	name = "Water Ball";
	speed       = 14.0625;  // units per second (900 / 64)
	damage      = 2;
	life_steps  = game_get_speed(gamespeed_fps) * 1.0;
	kb_speed = 5;        // pixels per frame (knockback still frame-based)
	kb_distance = 30;    // 30 pixels total
	sprite_index = spr_water_ball;
	scale = 0.5;

	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		instance_destroy(projectile_inst);
	}
}

function ProjectileWindGust() constructor {
	name = "Wind Gust";
	speed       = 9.375;  // units per second (600 / 64)
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 0.2;
	kb_speed = 4;  // pixels per frame (knockback still frame-based)
	kb_distance = 30;
	sprite_index = spr_wind_gust;
	scale = 0.7;

	on_hit = function(projectile_inst, target) {
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		// Wind gust doesn't destroy on hit - passes through enemies
	}
}

function ProjectileMudBall() constructor {
	name = "Mud Ball";
	speed       = 7.5;  // units per second (480 / 64)
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;
	kb_speed = 2;  // pixels per frame (knockback still frame-based)
	kb_distance = 40;
	sprite_index = spr_mud_ball;
	scale = 1.0;

	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		instance_destroy(projectile_inst);
	}
}

function ProjectileHurricane() constructor {
	name = "Hurricane";
	speed       = 4.6875;  // units per second (300 / 64) - slow moving
	damage      = 1;  // Used for DoT tick damage
	life_steps  = game_get_speed(gamespeed_fps) * 5;  // 5 second max lifetime
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_hurricane;
	scale = 0.5;

	on_launch = function(projectile_inst) {
		// Keep hurricane vertically aligned regardless of shoot direction
		projectile_inst.image_angle = 0;
		// Initialize hit tracking
		projectile_inst.hit_targets = ds_map_create();
	}

	on_step = function(projectile_inst) {
		// Check all enemies overlapping with hurricane
		with (projectile_inst) {
			var enemy_list = ds_list_create();
			var num_colliding = instance_place_list(x, y, obj_enemy_abstract, enemy_list, false);

			var curr_time = current_time;

			for (var i = 0; i < num_colliding; i++) {
				var enemy = enemy_list[| i];
				var target_id = enemy.id;
				var last_hit_time = ds_map_find_value(hit_targets, target_id);

				// If never hit or 1 second has passed (1000 milliseconds)
				if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= 1000)) {
					damage_entity(enemy, 1);
					ds_map_set(hit_targets, target_id, curr_time);
				}
			}

			ds_list_destroy(enemy_list);
		}
	}

	on_hit = function(projectile_inst, target) {
		// Damage handling is done in on_step for continuous checking
		// Hurricane doesn't destroy on enemy hit - persists
	}

	on_wall_hit = function(projectile_inst) {
		// Hurricane stops when hitting wall
		projectile_inst.speed = 0;
		// Increment wall timer
		if (!variable_instance_exists(projectile_inst, "wall_hit_timer")) {
			projectile_inst.wall_hit_timer = 0;
		}
		projectile_inst.wall_hit_timer++;
		// Destroy after 1 second (60 frames)
		if (projectile_inst.wall_hit_timer >= game_get_speed(gamespeed_fps) * 1.0) {
			instance_destroy(projectile_inst);
		}
	}
}