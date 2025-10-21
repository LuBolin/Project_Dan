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
    sfx_fire = undefined;
    sfx_hit = undefined;

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
    sfx_fire = undefined;
    sfx_hit = undefined;
    
	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		add_status_effect(target, new StunEffect(game_get_speed(gamespeed_fps) * 0.5));
		instance_destroy(projectile_inst);
	}
}

function ProjectileWaterBall() constructor {
	name = "Water Ball";
	speed       = 14.0625;  // units per second (900 / 64)
	damage      = 1; // was 2
	life_steps  = game_get_speed(gamespeed_fps) * 1.0;
	kb_speed = 5;        // pixels per frame (knockback still frame-based)
	kb_distance = 10;    // was 30 pixels total
	sprite_index = spr_water_ball;
	scale = 0.5;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		instance_destroy(projectile_inst);
	}
}

function ProjectileAir(_is_invuln = true, _dash_distance = 128, _dash_duration = 8) constructor {
	name = "Air";
	speed = 0;  // Doesn't move
	damage = 0;
	life_steps = 1;  // Destroy immediately after dash
	kb_speed = 12;  // Dash speed (pixels per frame) - slower for smoother dash
	kb_distance = _dash_distance;  // Total dash distance (2 units)
	dash_duration = _dash_duration;  // 0.133 seconds at 60 FPS (96 / 12 = 8 frames)
	sprite_index = spr_wind_gust;
	scale = 0.2;  // Small visual effect
    sfx_fire = snd_air_projectile;
    sfx_hit = undefined;
    is_invuln = _is_invuln;

	on_launch = function(projectile_inst) {
		// Spawn projectile on player
		projectile_inst.x = projectile_inst.creator.x;
		projectile_inst.y = projectile_inst.creator.y;
		projectile_inst.speed = 0;
		projectile_inst.image_alpha = 0.5;  // Semi-transparent

		// Immediately dash the player towards mouse
		if (instance_exists(projectile_inst.creator)) {
			var player = projectile_inst.creator;
			//var dash_dir = point_direction(player.x, player.y, projectile_inst, mouse_y);
            dash_dir = projectile_inst.image_angle

			// Apply knockback effect to dash player (false = no stun)
			add_status_effect(player, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

            if (is_invuln) { 
                // Make player invincible during dash + 0.2 seconds after
    			var invuln_time = 0.2; // seconds
    			var invuln_duration = dash_duration + (invuln_time * game_get_speed(gamespeed_fps));
    			add_status_effect(player, new InvincibilityEffect(invuln_duration));
            }

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
    speed       = 6.25;  // units per second (400 / 64) - moderate speed
    damage      = 1;
    life_steps  = game_get_speed(gamespeed_fps) * 2.0; // 2 second max flight time
    kb_speed = 3;  // pixels per frame
    kb_distance = 50; // knockback distance
    sprite_index = spr_lava_ball;
    scale = 0.6;
    sfx_fire = undefined;
    sfx_hit = undefined;

    // Target position for homing
    target_x = 0;
    target_y = 0;
    homing_enabled = false;

    on_launch = function(projectile_inst) {
        // Store target position (mouse position at launch)
        projectile_inst.target_x = mouse_x;
        projectile_inst.target_y = mouse_y;
        projectile_inst.homing_enabled = true;
        
        // Calculate initial direction towards target
        var dir = point_direction(projectile_inst.x, projectile_inst.y, mouse_x, mouse_y);
        projectile_inst.direction = dir;
        projectile_inst.image_angle = dir;
    }

    on_step = function(projectile_inst) {
        // Home towards target position
        if (projectile_inst.homing_enabled) {
            var dist_to_target = point_distance(projectile_inst.x, projectile_inst.y, 
                                                projectile_inst.target_x, projectile_inst.target_y);
            
            // Stop homing if very close to target (within 10 pixels)
            if (dist_to_target < 10) {
                projectile_inst.homing_enabled = false;
                projectile_inst.speed = 0; // Stop moving
                // Spawn lava pool at target location
                projectile_inst.spawned_pool = true;
                instance_create_layer(projectile_inst.target_x, projectile_inst.target_y, "Instances", obj_lava_pool);
                instance_destroy(projectile_inst);
            } else {
                // Adjust direction towards target with smooth homing
                var target_dir = point_direction(projectile_inst.x, projectile_inst.y, 
                                                 projectile_inst.target_x, projectile_inst.target_y);
                
                // Smooth turning (adjust turn_speed for more/less agile homing)
                var turn_speed = 5; // degrees per frame
                var angle_diff = angle_difference(target_dir, projectile_inst.direction);
                
                if (abs(angle_diff) > turn_speed) {
                    projectile_inst.direction += sign(angle_diff) * turn_speed;
                } else {
                    projectile_inst.direction = target_dir;
                }
                
                projectile_inst.image_angle = projectile_inst.direction;
            }
        }
    }

    on_hit = function(projectile_inst, target) {
        // Apply damage and knockback
        damage_entity(target, projectile_inst.damage);
        apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
        
        // Mark that we're spawning a pool
        projectile_inst.spawned_pool = true;
        
        // Spawn lava pool at impact location
        instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
        instance_destroy(projectile_inst);
    }

    on_wall_hit = function(projectile_inst) {
        // Mark that we're spawning a pool
        projectile_inst.spawned_pool = true;
        
        // Spawn lava pool at wall impact location
        instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
        instance_destroy(projectile_inst);
    }

    on_destroy = function(projectile_inst) {
        // Only spawn pool if we haven't already spawned one (from hit or wall)
        if (instance_exists(projectile_inst) && !variable_instance_exists(projectile_inst, "spawned_pool")) {
            instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
        }
    }
}

function ProjectileSteam() constructor {
    name = "Steam";
    // Steam is now implemented as obj_steam area-of-effect
    // This constructor is kept for compatibility but not used
    show_debug_message("Steam uses obj_steam AoE instead of projectile");
}

function ProjectileMudBall() constructor {
	name = "Mud Ball";
	speed       = 7.5;  // units per second (480 / 64)
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;
	kb_speed = 2;  // pixels per frame (knockback still frame-based)
	kb_distance = 40;
	sprite_index = spr_mud_ball;
	scale = 0.5;
    sfx_fire = undefined;
    sfx_hit = undefined;

	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		// Mark that we're spawning a pool, so on_destroy doesn't spawn another
		projectile_inst.spawned_pool = true;
		// Spawn mud pool at projectile location
		instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_mud_pool);
		instance_destroy(projectile_inst);
	}

	on_wall_hit = function(projectile_inst) {
		// Mark that we're spawning a pool, so on_destroy doesn't spawn another
		projectile_inst.spawned_pool = true;
		// Spawn mud pool at wall impact location
		instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_mud_pool);
		instance_destroy(projectile_inst);
	}

	on_destroy = function(projectile_inst) {
		// Only spawn pool if we haven't already spawned one (from hit or wall)
		if (instance_exists(projectile_inst) && !variable_instance_exists(projectile_inst, "spawned_pool")) {
			instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_mud_pool);
		}
	}
}

function ProjectileCurrent() constructor {
	name = "Current";
	speed = 0;  // Doesn't move (player dashes instead)
	damage = 0;
	life_steps = 1;  // Destroy immediately after dash
	kb_speed = 12;  // Dash speed (pixels per frame)
	kb_distance = 128;  // Total dash distance (2 units)
	dash_duration = 8;  // Frames for dash
	sprite_index = spr_wind_gust;
	scale = 0.2;  // Small visual effect during dash
    sfx_fire = undefined;
    sfx_hit = undefined;

	// Knockback gust properties (applied at end of dash)
	gust_kb_speed = 4;
	gust_kb_distance = 30;
	gust_speed = 9.375;  // units per second (600 / 64)
	gust_lifetime = game_get_speed(gamespeed_fps) * 0.2;

	on_launch = function(projectile_inst) {
		// Spawn projectile on player
		projectile_inst.x = projectile_inst.creator.x;
		projectile_inst.y = projectile_inst.creator.y;
		projectile_inst.speed = 0;
		projectile_inst.image_alpha = 0.5;  // Semi-transparent

		// Immediately dash the player towards mouse
		if (instance_exists(projectile_inst.creator)) {
			var player = projectile_inst.creator;
			var dash_dir = projectile_inst.image_angle;

			// Apply knockback effect to dash player (false = no stun)
			add_status_effect(player, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

			// Make player invincible during dash + 0.2 seconds after
			var invuln_time = 0.2; // seconds
			var invuln_duration = dash_duration + (invuln_time * game_get_speed(gamespeed_fps));
			add_status_effect(player, new InvincibilityEffect(invuln_duration));

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

			// After dash completes, spawn the knockback gust projectile
			// Schedule it to spawn after dash_duration frames
			var gust_data = {
				x: player.x,
				y: player.y,
				direction: dash_dir,
				creator: player,
				kb_speed: gust_kb_speed,
				kb_distance: gust_kb_distance,
				gust_speed: gust_speed,
				gust_lifetime: gust_lifetime,
				timer: 0,
				dash_duration: dash_duration
			};

			// Store gust data on player to spawn after dash
			player.wind_gust_pending = gust_data;
		}

		// Destroy projectile immediately
		instance_destroy(projectile_inst);
	}
}

// ========================================
// TIER 2 - ADVANCED COMBINATIONS
// ========================================

function ProjectileEruption() constructor {
	name = "Eruption";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Eruption is unimplemented");
}

function ProjectileClay() constructor {
	name = "Clay";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Clay is unimplemented");
}

function ProjectilePlant() constructor {
	name = "Plant";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Plant is unimplemented");
}

function ProjectileHurricane() constructor {
	name = "Hurricane";
	speed       = 4.6875;  // units per second (300 / 64) - slow moving
	damage      = 2;  // Used for DoT tick damage
	life_steps  = game_get_speed(gamespeed_fps) * 5;  // 5 second max lifetime
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_hurricane;
	scale = 0.5;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
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
		// Hurricane stops when hitting wall but continues to damage enemies
		projectile_inst.speed = 0;
		// Don't destroy - let it last its full duration
	}
}

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function ProjectileDestruction() constructor {
	name = "Destruction";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Destruction is unimplemented");
}

function ProjectileCreation() constructor {
	name = "Creation";
	// UNIMPLEMENTED - Print message instead of shooting
	show_debug_message("Creation is unimplemented");
}

// ========================================
// ENEMY PROJECTILE
// ========================================

function ProjectileGhost() constructor {
    name = "Ghost";
    speed = 4.0;                             // units per second
    damage = 1;
    life_steps = game_get_speed(gamespeed_fps) * 5; // ~5s lifetime
    kb_speed = 12.0;                         // units per second for knockback motion
    kb_distance = 2 * global.UNIT_LENGTH;    // 2 units of knockback
    sprite_index = spr_ghost_projectile;     // replace with your sprite; or -1 if none
    scale = 1.5;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_hit = function(projectile_inst, target) {
        // Simple: 1 damage, no status effects; knockback handled by your hit system via kb_* fields
        damage_entity(target, projectile_inst.damage);
        instance_destroy(projectile_inst);
    }
}

