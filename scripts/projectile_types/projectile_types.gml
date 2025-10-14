// ========================================
// TIER 0 - BASE ELEMENTS
// ========================================

function ProjectileFire() constructor {
	name = "Fire";
	speed = 12.0;  // units per second
	damage = 1;  // Initial hit damage
	life_steps = game_get_speed(gamespeed_fps) * 0.8;
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_fire_ball;
	scale = 0.5;

	on_hit = function(projectile_inst, target) {
		// Initial damage
		damage_entity(target, projectile_inst.damage);
		// Apply burn effect: 1 damage per second for 3 seconds
		add_status_effect(target, new BurnEffect(game_get_speed(gamespeed_fps) * 3, 1));
		instance_destroy(projectile_inst);
	}
}

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

function ProjectileAir() constructor {
	name = "Air";
	speed = 0;  // Doesn't move
	damage = 0;
	life_steps = 1;  // Destroy immediately after dash
	kb_speed = 12;  // Dash speed (pixels per frame) - slower for smoother dash
	kb_distance = 96;  // Total dash distance (1.5 units)
	dash_duration = 8;  // 0.133 seconds at 60 FPS (96 / 12 = 8 frames)
	sprite_index = spr_wind_gust;
	scale = 0.2;  // Small visual effect

	on_launch = function(projectile_inst) {
		// Spawn projectile on player
		projectile_inst.x = projectile_inst.creator.x;
		projectile_inst.y = projectile_inst.creator.y;
		projectile_inst.speed = 0;
		projectile_inst.image_alpha = 0.5;  // Semi-transparent

		// Immediately dash the player towards mouse
		if (instance_exists(projectile_inst.creator)) {
			var player = projectile_inst.creator;
			var dash_dir = point_direction(player.x, player.y, mouse_x, mouse_y);

			// Apply knockback effect to dash player (false = no stun)
			add_status_effect(player, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

			// Create particle effect trail behind player
			var trail_length = 5;  // Number of particles
			for (var i = 0; i < trail_length; i++) {
				var offset = i * 10;  // Space particles along the trail
				var trail_x = player.x - lengthdir_x(offset, dash_dir);
				var trail_y = player.y - lengthdir_y(offset, dash_dir);

				// Create a wind particle at this position
				var particle = instance_create_layer(trail_x, trail_y, "Instances", obj_projectile);
				if (particle != noone) {
					particle.sprite_index = spr_wind_gust;
					particle.image_alpha = 0.4 - (i * 0.06);  // Fade out
					particle.image_xscale = 0.3;
					particle.image_yscale = 0.3;
					particle.image_angle = dash_dir;
					particle.speed = 0;
					particle.life_steps = 15 - (i * 2);  // Particles fade quickly
					particle.proj_data = {};  // Empty data, no collision
				}
			}
		}

		// Destroy projectile immediately
		instance_destroy(projectile_inst);
	}
}

// ========================================
// TIER 1 - BASIC COMBINATIONS
// ========================================

function ProjectileLava() constructor {
	name = "Lava";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Lava is unimplemented");
}

function ProjectileSteam() constructor {
	name = "Steam";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Steam is unimplemented");
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

// ========================================
// TIER 2 - ADVANCED COMBINATIONS
// ========================================

function ProjectileObsidian() constructor {
	name = "Obsidian";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Obsidian is unimplemented");
}

function ProjectileFog() constructor {
	name = "Fog";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Fog is unimplemented");
}

function ProjectileClay() constructor {
	name = "Clay";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Clay is unimplemented");
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

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function ProjectileGolem() constructor {
	name = "Golem";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Golem is unimplemented");
}

function ProjectileSoulMist() constructor {
	name = "Soul-Mist";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Soul-Mist is unimplemented");
}

// ========================================
// ENEMY PROJECTILE
// ========================================

function ProjectileGhost() constructor {
    name = "Ghost";
    speed = 9.0;                             // units per second
    damage = 1;
    life_steps = game_get_speed(gamespeed_fps) * 0.8; // ~0.8s lifetime
    kb_speed = 12.0;                         // units per second for knockback motion
    kb_distance = 2 * global.UNIT_LENGTH;    // 2 units of knockback
    sprite_index = spr_ghost_projectile;     // replace with your sprite; or -1 if none
    scale = 0.6;

    on_hit = function(projectile_inst, target) {
        // Simple: 1 damage, no status effects; knockback handled by your hit system via kb_* fields
        damage_entity(target, projectile_inst.damage);
        instance_destroy(projectile_inst);
    }
}

