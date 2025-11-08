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
	scale = 1;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
    }
    
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
	damage      = 2;
	life_steps  = game_get_speed(gamespeed_fps) * 0.5;
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_rock;
	scale = 1;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
    }
    
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
	kb_speed = 8;        // pixels per frame (knockback still frame-based) - increased from 5
	kb_distance = 20;    // was 30 pixels total - increased from 10
	sprite_index = spr_water_ball;
	scale = 1;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
    }
    
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

        // Immediately dash the player
        if (instance_exists(projectile_inst.creator)) {
            var player = projectile_inst.creator;
            projectile_inst.depth = 0;
            
            // DETERMINE DASH DIRECTION: Player movement takes priority over mouse direction
            var dash_dir;
            
            // Check if player is moving (get current input)
            var input_x = 0;
            var input_y = 0;
            
            if (keyboard_check(ord("A"))) input_x -= 1;
            if (keyboard_check(ord("D"))) input_x += 1;
            if (keyboard_check(ord("W"))) input_y -= 1;
            if (keyboard_check(ord("S"))) input_y += 1;
            
            // If player is moving, dash in movement direction
            if (input_x != 0 || input_y != 0) {
                dash_dir = point_direction(0, 0, input_x, input_y);
                show_debug_message("Air dash: Using movement direction " + string(dash_dir));
            } else {
                // If not moving, dash toward mouse
                dash_dir = point_direction(player.x, player.y, mouse_x, mouse_y);
                show_debug_message("Air dash: Using mouse direction " + string(dash_dir));
            }
            
            projectile_inst.image_angle = dash_dir;

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

function ProjectilEnemyAir(_is_invuln = true, _dash_distance = 128, _dash_duration = 8) constructor {
    name = "EnemyAir";
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

        // Immediately dash the player
        if (instance_exists(projectile_inst.creator)) {
     		// Spawn projectile on player
    		projectile_inst.x = projectile_inst.creator.x;
    		projectile_inst.y = projectile_inst.creator.y;
    		projectile_inst.speed = 0;
    		projectile_inst.image_alpha = 0.5;  // Semi-transparent
            projectile_inst.depth = 0;
    		
            // Immediately dash the player towards mouse
    		if (instance_exists(projectile_inst.creator)) {
    			var player = projectile_inst.creator;
    			//var dash_dir = point_direction(player.x, player.y, projectile_inst, mouse_y);
                dash_dir = projectile_inst.image_angle
            

                if (is_invuln) { 
                    // Make player invincible during dash + 0.2 seconds after
                    var invuln_time = 0.2; // seconds
                    var invuln_duration = dash_duration + (invuln_time * game_get_speed(gamespeed_fps));
                    add_status_effect(player, new InvincibilityEffect(invuln_duration));
                }
    
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
    kb_distance = 20; // knockback distance
    sprite_index = spr_water_ball;
    scale = 0.8;
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
        projectile_inst.depth = 0;
        projectile_inst.image_blend = make_color_rgb(255, 50, 0); // make water ball red
        
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
                var lava = instance_create_layer(projectile_inst.target_x, projectile_inst.target_y, "Instances", obj_lava_pool);
                if (instance_exists(lava) && projectile_inst.creator == obj_player) {
                    lava.damage_enemies = true;
                    lava.damage_player = false;
                }
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
        var lava = instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
        if (instance_exists(lava) && projectile_inst.creator == obj_player) {
            lava.damage_enemies = true;
            lava.damage_player = false;
        }
        instance_destroy(projectile_inst);
    }

    on_wall_hit = function(projectile_inst) {
        // Mark that we're spawning a pool
        projectile_inst.spawned_pool = true;

        // Spawn lava pool at wall impact location
        var lava = instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
        if (instance_exists(lava) && projectile_inst.creator == obj_player) {
            lava.damage_enemies = true;
            lava.damage_player = false;
        }
        instance_destroy(projectile_inst);
    }

    on_destroy = function(projectile_inst) {
        // Only spawn pool if we haven't already spawned one (from hit or wall)
        if (instance_exists(projectile_inst) && !variable_instance_exists(projectile_inst, "spawned_pool")) {
            var lava = instance_create_layer(projectile_inst.x, projectile_inst.y, "Instances", obj_lava_pool);
            if (instance_exists(lava) && projectile_inst.creator == obj_player) {
                lava.damage_enemies = true;
                lava.damage_player = false;
            }
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
	damage      = 1;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;
	kb_speed = 2;  // pixels per frame (knockback still frame-based)
	kb_distance = 40;
	sprite_index = spr_mud_ball;
	scale = 1;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
    }

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

        // Immediately dash the player towards movement direction or mouse
        if (instance_exists(projectile_inst.creator)) {
            var player = projectile_inst.creator;
            projectile_inst.depth = 0;
            // DETERMINE DASH DIRECTION: Player movement takes priority
            var dash_dir;
            var gust_dir; // Direction for the air gust (always toward mouse for Current)
            
            // Check if player is moving (get current input)
            var input_x = 0;
            var input_y = 0;
            
            if (keyboard_check(ord("A"))) input_x -= 1;
            if (keyboard_check(ord("D"))) input_x += 1;
            if (keyboard_check(ord("W"))) input_y -= 1;
            if (keyboard_check(ord("S"))) input_y += 1;
            
            // If player is moving, dash in movement direction
            if (input_x != 0 || input_y != 0) {
                dash_dir = point_direction(0, 0, input_x, input_y);
                show_debug_message("Current dash: Using movement direction " + string(dash_dir));
            } else {
                // If not moving, dash toward mouse
                dash_dir = point_direction(player.x, player.y, mouse_x, mouse_y);
                show_debug_message("Current dash: Using mouse direction " + string(dash_dir));
            }
            
            // Air gust ALWAYS goes toward mouse for Current (for strategic aiming)
            gust_dir = point_direction(player.x, player.y, mouse_x, mouse_y);
            
            projectile_inst.image_angle = dash_dir;

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
                direction: gust_dir, // Use mouse direction for gust
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
    speed       = 7.5;  // units per second (480 / 64) - slightly faster than lava
    damage      = 1.5;    // 50% higher damage than regular lava
    life_steps  = game_get_speed(gamespeed_fps) * 2.5; // 2.5 second max flight time
    kb_speed = 4;  // pixels per frame
    kb_distance = 20; // Same knockback than lava
    sprite_index = spr_water_ball; // Reuse lava ball sprite
    scale = 0.8; // Slightly larger than regular lava
    sfx_fire = undefined;
    sfx_hit = undefined;

    // Target position for homing
    target_x = 0;
    target_y = 0;
    homing_enabled = false;

    // Eruption-specific properties
    explosion_radius = 64 // Distance between pools (1.5 units)
    num_secondary_pools = 6; // Number of pools to spawn around center

    on_launch = function(projectile_inst) {
        // Store target position (mouse position at launch)
        projectile_inst.target_x = mouse_x;
        projectile_inst.target_y = mouse_y;
        projectile_inst.homing_enabled = true;
        projectile_inst.depth = 0;
        projectile_inst.image_blend = make_color_rgb(255, 50, 0);
        
        // Calculate initial direction towards target
        var dir = point_direction(projectile_inst.x, projectile_inst.y, mouse_x, mouse_y);
        projectile_inst.direction = dir;
        projectile_inst.image_angle = dir;
    }

    on_step = function(projectile_inst) {
        // Home towards target position (same as lava)
        if (projectile_inst.homing_enabled) {
            var dist_to_target = point_distance(projectile_inst.x, projectile_inst.y, 
                                                projectile_inst.target_x, projectile_inst.target_y);
            
            // Stop homing if very close to target (within 15 pixels for eruption)
            if (dist_to_target < 15) {
                projectile_inst.homing_enabled = false;
                projectile_inst.speed = 0; // Stop moving
                // Trigger eruption at target location
                trigger_eruption(projectile_inst.target_x, projectile_inst.target_y, projectile_inst.creator);
                projectile_inst.spawned_pool = true;
                instance_destroy(projectile_inst);
            } else {
                // Adjust direction towards target with smooth homing
                var target_dir = point_direction(projectile_inst.x, projectile_inst.y, 
                                                 projectile_inst.target_x, projectile_inst.target_y);
                
                // Smooth turning
                var turn_speed = 4; // degrees per frame (slightly slower than lava for heavier feel)
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

        // Mark that we're spawning pools
        projectile_inst.spawned_pool = true;

        // Trigger eruption at impact location
        trigger_eruption(projectile_inst.x, projectile_inst.y, projectile_inst.creator);
        instance_destroy(projectile_inst);
    }

    on_wall_hit = function(projectile_inst) {
        // Mark that we're spawning pools
        projectile_inst.spawned_pool = true;

        // Trigger eruption at wall impact location
        trigger_eruption(projectile_inst.x, projectile_inst.y, projectile_inst.creator);
        instance_destroy(projectile_inst);
    }

    on_destroy = function(projectile_inst) {
        // Only spawn eruption if we haven't already spawned one (from hit or wall)
        if (instance_exists(projectile_inst) && !variable_instance_exists(projectile_inst, "spawned_pool")) {
            trigger_eruption(projectile_inst.x, projectile_inst.y, projectile_inst.creator);
        }
    }

    // Helper function to create the eruption pattern
    trigger_eruption = function(center_x, center_y, creator) {
        // Spawn center lava pool immediately
        var center_pool = instance_create_layer(center_x, center_y, "Instances", obj_lava_pool);

        // Make center pool slightly more powerful AND bigger
        if (instance_exists(center_pool)) {
            center_pool.damage_per_tick = 3; // 50% higher damage than lava
            center_pool.life_timer = game_get_speed(gamespeed_fps) * 10; // Lasts longer
            // Make center pool bigger
            center_pool.image_xscale = 1.5;
            center_pool.image_yscale = 1.5;
            // Set damage flags if created by player
            if (creator == obj_player) {
                center_pool.damage_enemies = true;
                center_pool.damage_player = false;
            }
        }
        
        // Create eruption controller to spawn secondary pools with delays
        var eruption_controller = instance_create_layer(center_x, center_y, "Instances", obj_projectile);
        if (instance_exists(eruption_controller)) {
            eruption_controller.sprite_index = -1; // Invisible
            eruption_controller.speed = 0;
            eruption_controller.life_steps = num_secondary_pools * 3 + 10; // Live long enough to spawn all pools

            // Store eruption data
            eruption_controller.proj_data = {
                center_x: center_x,
                center_y: center_y,
                pools_spawned: 0,
                spawn_timer: 0,
                explosion_radius: explosion_radius,
                num_secondary_pools: num_secondary_pools,
                creator: creator,
                
                on_step: function(projectile_inst) {
                    self.spawn_timer++;

                    // Spawn a pool every 3 frames
                    if (self.spawn_timer >= 3 && self.pools_spawned < self.num_secondary_pools) {
                        self.spawn_timer = 0;

                        var angle = (360 / self.num_secondary_pools) * self.pools_spawned;
                        var pool_x = self.center_x + lengthdir_x(self.explosion_radius, angle);
                        var pool_y = self.center_y + lengthdir_y(self.explosion_radius, angle);

                        // Check if position is valid (not in walls)
                        var tilemap = layer_tilemap_get_id("Tile_Collision");
                        var tile = tilemap_get_at_pixel(tilemap, pool_x, pool_y);
                        //if (!place_meeting(pool_x, pool_y, layer_tilemap_get_id("Tile_Collision"))) {
                        if (tile == 0) {
                            var secondary_pool = instance_create_layer(pool_x, pool_y, "Instances", obj_lava_pool);
                            if (instance_exists(secondary_pool)) {
                                secondary_pool.life_timer = game_get_speed(gamespeed_fps) * 6; // 6 seconds
								secondary_pool.damage_per_tick = 0.6; // 70% of damage of lava
                                // Make secondary pools smaller
                                secondary_pool.image_xscale = 0.8;
                                secondary_pool.image_yscale = 0.8;
                                // Set damage flags if created by player
                                if (self.creator == obj_player) {
                                    secondary_pool.damage_enemies = true;
                                    secondary_pool.damage_player = false;
                                }
                            }
                        }

                        self.pools_spawned++;

                        // Destroy controller when all pools are spawned
                        if (self.pools_spawned >= self.num_secondary_pools) {
                            instance_destroy(projectile_inst);
                        }
                    }
                }
            };
        }
        
        show_debug_message("ERUPTION! Spawning " + string(num_secondary_pools) + " secondary lava pools");
    }
}

function ProjectileClay() constructor {
    name = "Clay";
    // Clay is now implemented as direct wall spawning from gourd
    // Constructor is kept for compatibility but not used
    show_debug_message("Clay uses direct wall spawning instead of projectile");
}

function ProjectilePlant() constructor {
    name = "Plant";
    speed = 0;  // Doesn't move (player dashes instead)
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 10;  // Dash speed (pixels per frame) - slightly slower than Air/Current
    kb_distance = 96;  // Total dash distance (1.5 units) - shorter than Air/Current
    dash_duration_seconds = 0.16;  // Dash duration in seconds (slightly longer for nature feel)
    dash_duration = dash_duration_seconds * game_get_speed(gamespeed_fps);  // Convert to frames
    sprite_index = spr_wind_gust; // Reuse wind gust sprite or create spr_plant_dash
    scale = 0.2;  // Small visual effect during dash
    sfx_fire = undefined;
    sfx_hit = undefined;

    on_launch = function(projectile_inst) {
        // Spawn projectile on player
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;
        projectile_inst.speed = 0;
        projectile_inst.image_alpha = 0.5;  // Semi-transparent

        // Immediately dash the player
        if (instance_exists(projectile_inst.creator)) {
            var player = projectile_inst.creator;
            projectile_inst.depth = 0;
            // DETERMINE DASH DIRECTION: Player movement takes priority over mouse direction
            var dash_dir;
            
            if (player == obj_player) { 
                
                // Check if player is moving (get current input)
                var input_x = 0;
                var input_y = 0;
                
                if (keyboard_check(ord("A"))) input_x -= 1;
                if (keyboard_check(ord("D"))) input_x += 1;
                if (keyboard_check(ord("W"))) input_y -= 1;
                if (keyboard_check(ord("S"))) input_y += 1; 
                    
                // If player is moving, dash in movement direction
                if (input_x != 0 || input_y != 0) {
                    dash_dir = point_direction(0, 0, input_x, input_y);
                    show_debug_message("Plant dash: Using movement direction " + string(dash_dir));
                } else {
                    // If not moving, dash toward mouse
                    dash_dir = point_direction(player.x, player.y, mouse_x, mouse_y);
                    show_debug_message("Plant dash: Using mouse direction " + string(dash_dir));
                }
            
            } else if (player == obj_enemy_abstract) {
                
                dash_dir = point_direction(player.x, player.y, obj_player.x, obj_player.y);    
            }

 
            projectile_inst.image_angle = dash_dir;

            // Apply knockback effect to dash player (false = no stun)
            add_status_effect(player, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

            // Make player invincible during dash (shorter than Air/Current for balance)
            if (player == obj_player) {
                var invuln_time_seconds = 0.15; // seconds
                var invuln_duration = (dash_duration_seconds + invuln_time_seconds) * game_get_speed(gamespeed_fps);
                add_status_effect(player, new InvincibilityEffect(invuln_duration));
            }

            // Create particle effect trail behind player (green nature particles)
            var trail_length = 5;  // Number of particles
            for (var i = 0; i < trail_length; i++) {
                var offset = i * 8;  // Space particles along the trail
                var trail_x = player.x - lengthdir_x(offset, dash_dir);
                var trail_y = player.y - lengthdir_y(offset, dash_dir);

                // Create a nature particle at this position
                var particle = instance_create_layer(trail_x, trail_y, "Instances", obj_projectile);
                if (particle != noone) {
                    particle.sprite_index = spr_wind_gust; // Use wind gust or create spr_leaf_particle
                    particle.image_alpha = 0.3 - (i * 0.05);  // Fade out
                    particle.image_xscale = 0.25;
                    particle.image_yscale = 0.25;
                    particle.image_angle = dash_dir + random_range(-15, 15); // Slight rotation variation
                    particle.image_blend = make_color_rgb(100, 200, 100); // Green tint
                    particle.speed = 0;
                    particle.life_steps = (1.0 - (i * 0.15)) * game_get_speed(gamespeed_fps); // Particles fade over 0.5-1 seconds
                    particle.proj_data = {};  // Empty data, no collision
                }
            }

            // Schedule healing area to spawn after dash completes
            var healing_data = {
                spawn_x: 0, // Will be set to player position after dash
                spawn_y: 0,
                creator: player,
                timer: 0,
                dash_duration: dash_duration,
                dash_duration_seconds: dash_duration_seconds
            };

            // Store healing data on player to spawn after dash
            player.plant_healing_pending = healing_data;
        }

        // Destroy projectile immediately
        instance_destroy(projectile_inst);
    }
}

function ProjectileHurricane() constructor {
	name = "Hurricane";
	speed       = 4;  // units per second (300 / 64) - slow moving
	damage      = 3;  // Used for DoT tick damage
	life_steps  = game_get_speed(gamespeed_fps) * 5;  // 5 second max lifetime
	kb_speed = 0;     
	kb_distance = 0;    
	sprite_index = spr_hurricane_collision;
	scale = 0.2;
    damage_player = false;
    damage_enemies = !damage_player;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
	on_launch = function(projectile_inst) {
		// Keep hurricane vertically aligned regardless of shoot direction
		projectile_inst.image_angle = 0;
		// Initialize hit tracking
		projectile_inst.hit_targets = ds_map_create();
        projectile_inst.depth = 0;

        if (variable_instance_exists(projectile_inst, "hide_self")) {
            projectile_inst.hide_self = true;      
        }
	}

	on_step = function(projectile_inst) {
		// Check all enemies overlapping with hurricane
		with (projectile_inst) {
			enemy_list = ds_list_create();
			//var num_colliding = instance_place_list(x, y, obj_enemy_abstract, enemy_list, false);
            _scale = other.scale * 4;
            
            if (other.damage_player) {
                with (obj_player) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist <= (sprite_get_width(spr_hurricane) / 2) * other._scale) {
                        // Add this enemy's id to the list of the checking object
                        ds_list_add(other.enemy_list, id);
                    }
                }
            }
            
            if (other.damage_enemies) {
                with (obj_enemy_abstract) {
                    var dist = point_distance(x, y + (sprite_get_height(spr_hurricane) / 2) * other._scale, other.x, other.y);
                    if (dist <= (sprite_get_width(spr_hurricane) / 2) * other._scale) {
                        // Add this enemy's id to the list of the checking object
                        ds_list_add(other.enemy_list, id);
                    }
                }
            }
                

            
            var num_colliding = ds_list_size(enemy_list) 
            
			var curr_time = current_time;

			for (var i = 0; i < num_colliding; i++) {
				var enemy = enemy_list[| i];
				var target_id = enemy.id;
				var last_hit_time = ds_map_find_value(hit_targets, target_id);
                
                // Copy and Paste from Mud Pool. Inflict slowness on Enemy to make Hurricane more useful
                // Apply slow effect using status effect system
                if (!variable_instance_exists(enemy, "mud_pool_slow") || !enemy.mud_pool_slow) {
                    // Apply slow effect for 0.2 seconds (will be refreshed while in pool)
                    var slow_duration = game_get_speed(gamespeed_fps) * 0.2; // 0.2 seconds
                    add_status_effect(enemy, new SlowEffect(slow_duration, 0.3));
                    
                    enemy.mud_pool_slow = true;
                    show_debug_message("Applied slow effect to enemy " + string(enemy.id));
            
                    // Add "Slowed" status text
                    if (variable_instance_exists(enemy, "status_texts")) {
                        if (array_get_index(enemy.status_texts, "Slowed") == -1) {
                            array_push(enemy.status_texts, "Slowed");
                        }
                    }
                    
                } else {
                    // Refresh slow effect for enemies still in pool
                    var slow_duration = game_get_speed(gamespeed_fps) * 0.2;
                    add_status_effect(enemy, new SlowEffect(slow_duration, 0.3));
                }
                
				// If never hit or 1 second has passed (1000 milliseconds)
				if (is_undefined(last_hit_time) || (curr_time - last_hit_time >= 1000)) {
					damage_entity(enemy, 1);
                    
					ds_map_set(hit_targets, target_id, curr_time);
				}
			}

			ds_list_destroy(enemy_list);
            
            // Hurricane Test
            projectile_inst.speed = projectile_inst.speed - 0.05 < 0 ? 0 : projectile_inst.speed - 0.05
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
    
    on_draw = function(projectile_inst) {
        draw_sprite_ext(spr_hurricane, 0, projectile_inst.x, projectile_inst.y, scale * 4, scale * 4, 0, c_white, 1);
    }
}

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function ProjectileDestruction() constructor {
    name = "Destruction";
    // Destruction is now implemented as screen-wide effect
    // This constructor is kept for compatibility but not used
    show_debug_message("Destruction uses screen-wide effect instead of projectile");
}

function ProjectileCreation() constructor {
    name = "Creation";
    speed = 0;  // Doesn't move (player dashes instead)
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 12;  // Dash speed (pixels per frame) - same as Air
    kb_distance = 128;  // Total dash distance (2 units) - same as Air
    dash_duration_seconds = 0.16;  // Dash duration in seconds
    dash_duration = dash_duration_seconds * game_get_speed(gamespeed_fps);  // Convert to frames
    sprite_index = spr_wind_gust; // Reuse wind gust sprite for dash effect
    scale = 0.2;  // Small visual effect during dash
    sfx_fire = undefined;
    sfx_hit = undefined;
    

    on_launch = function(projectile_inst) {
        // Spawn projectile on player
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;
        projectile_inst.speed = 0;
        projectile_inst.image_alpha = 0.5;  // Semi-transparent

        // Store initial position for clone spawning
        var initial_x = projectile_inst.creator.x;
        var initial_y = projectile_inst.creator.y;

        // Immediately dash the player
        if (instance_exists(projectile_inst.creator)) {
            var player = projectile_inst.creator;
            projectile_inst.depth = 0;
            
            // DETERMINE DASH DIRECTION: Player movement takes priority over mouse direction
            var dash_dir;
            
            // Check if player is moving (get current input)
            var input_x = 0;
            var input_y = 0;
            
            if (keyboard_check(ord("A"))) input_x -= 1;
            if (keyboard_check(ord("D"))) input_x += 1;
            if (keyboard_check(ord("W"))) input_y -= 1;
            if (keyboard_check(ord("S"))) input_y += 1;
            
            // If player is moving, dash in movement direction
            if (input_x != 0 || input_y != 0) {
                dash_dir = point_direction(0, 0, input_x, input_y);
                show_debug_message("Creation dash: Using movement direction " + string(dash_dir));
            } else {
                // If not moving, dash toward mouse
                dash_dir = point_direction(player.x, player.y, mouse_x, mouse_y);
                show_debug_message("Creation dash: Using mouse direction " + string(dash_dir));
            }
            
            projectile_inst.image_angle = dash_dir;

            // Apply knockback effect to dash player (false = no stun)
            add_status_effect(player, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

            // Make player invincible during dash
            var invuln_time_seconds = 0.2; // seconds
            var invuln_duration = (dash_duration_seconds + invuln_time_seconds) * game_get_speed(gamespeed_fps);
            add_status_effect(player, new InvincibilityEffect(invuln_duration));

            // Create particle effect trail behind player (golden creation particles)
            var trail_length = 5;  // Number of particles
            for (var i = 0; i < trail_length; i++) {
                var offset = i * 8;  // Space particles along the trail
                var trail_x = player.x - lengthdir_x(offset, dash_dir);
                var trail_y = player.y - lengthdir_y(offset, dash_dir);

                // Create a golden particle at this position
                var particle = instance_create_layer(trail_x, trail_y, "Instances", obj_projectile);
                if (particle != noone) {
                    particle.sprite_index = spr_wind_gust; // Use wind gust or create spr_creation_particle
                    particle.image_alpha = 0.4 - (i * 0.05);  // Fade out
                    particle.image_xscale = 0.25;
                    particle.image_yscale = 0.25;
                    particle.image_angle = dash_dir + random_range(-15, 15); // Slight rotation variation
                    particle.image_blend = make_color_rgb(255, 215, 0); // Golden tint
                    particle.speed = 0;
                    particle.life_steps = (1.0 - (i * 0.15)) * game_get_speed(gamespeed_fps); // Particles fade over 0.5-1 seconds
                    particle.proj_data = {};  // Empty data, no collision
                }
            }

            // Schedule clone spawning after dash completes
            var clone_data = {
                spawn_x: initial_x, // Spawn at initial position
                spawn_y: initial_y,
                creator: player,
                timer: 0,
                dash_duration: dash_duration,
                dash_duration_seconds: dash_duration_seconds
            };

            // Store clone data on player to spawn after dash
            player.creation_clone_pending = clone_data;
        }

        // Destroy projectile immediately
        instance_destroy(projectile_inst);
    }
}

function ProjectileLightningBeam() constructor {
    name = "LightningBeam";
    speed = 0;
    damage = 0;
    life_steps = 2.5 * game_get_speed(gamespeed_fps);
    kb_speed = 0;
    kb_distance = 0;
    sprite_index = -1;
    scale = 1.0;
    sfx_fire = undefined;
    sfx_hit = undefined;

    beam_length = 900;
    beam_width = 16;
    beam_glow = 32;
    beam_dps = 8;
    beam_acc = undefined;
    damage_enemies = true;
    damage_player = false;

    beam_sprite = spr_lightning_beam; // your animated sprite (set origin to Left Middle)
    beam_anim_t = 0;
    beam_anim_speed = 0.6;

    origin_x = 0;
    origin_y = 0;
    end_x = 0;
    end_y = 0;

    on_launch = function(projectile_inst) {
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;

        projectile_inst.beam_acc = ds_map_create();
        projectile_inst.origin_x = projectile_inst.x;
        projectile_inst.origin_y = projectile_inst.y;
        projectile_inst.beam_anim_t = 0;
        
        // Copy beam properties from constructor to instance
        projectile_inst.beam_sprite = beam_sprite;
        projectile_inst.beam_anim_speed = beam_anim_speed;
        projectile_inst.beam_length = beam_length;
        projectile_inst.beam_width = beam_width;
        projectile_inst.beam_glow = beam_glow;
        projectile_inst.beam_dps = beam_dps;

        var ex = projectile_inst.origin_x + lengthdir_x(projectile_inst.beam_length, projectile_inst.image_angle);
        var ey = projectile_inst.origin_y + lengthdir_y(projectile_inst.beam_length, projectile_inst.image_angle);
        var clamped = _beam_clamp_to_walls(projectile_inst.origin_x, projectile_inst.origin_y, ex, ey);
        projectile_inst.end_x = clamped.x;
        projectile_inst.end_y = clamped.y;
    }

    on_step = function(projectile_inst) {
        if (instance_exists(projectile_inst.creator)) {
            projectile_inst.origin_x = projectile_inst.creator.x;
            projectile_inst.origin_y = projectile_inst.creator.y;
            
            // Update beam angle to follow mouse
            var new_angle = point_direction(projectile_inst.origin_x, projectile_inst.origin_y, mouse_x, mouse_y);
            projectile_inst.image_angle = new_angle;
        }

        var ex = projectile_inst.origin_x + lengthdir_x(projectile_inst.beam_length, projectile_inst.image_angle);
        var ey = projectile_inst.origin_y + lengthdir_y(projectile_inst.beam_length, projectile_inst.image_angle);
        var clamped = _beam_clamp_to_walls(projectile_inst.origin_x, projectile_inst.origin_y, ex, ey);
        projectile_inst.end_x = clamped.x;
        projectile_inst.end_y = clamped.y;

        var x1 = projectile_inst.origin_x;
        var y1 = projectile_inst.origin_y;
        var x2 = projectile_inst.end_x;
        var y2 = projectile_inst.end_y;

        var hit_list = ds_list_create();
        if (collision_line_list(x1, y1, x2, y2, obj_enemy_abstract, true, true, hit_list, true)) {
            var curr_fps = max(1, game_get_speed(gamespeed_fps));
            for (var i = 0; i < ds_list_size(hit_list); i++) {
                var e = hit_list[| i];
                if (!instance_exists(e)) continue;

                var key = string(e);
                var accum = 0;
                if (ds_map_exists(projectile_inst.beam_acc, key)) {
                    accum = ds_map_find_value(projectile_inst.beam_acc, key);
                }

                accum += projectile_inst.beam_dps / curr_fps;
                var dmg_now = floor(accum);
                if (dmg_now >= 1) {
                    damage_entity(e, dmg_now);
                    accum -= dmg_now;
                }

                ds_map_set(projectile_inst.beam_acc, key, accum);
            }
        }
        ds_list_destroy(hit_list);

        projectile_inst.beam_anim_t += projectile_inst.beam_anim_speed;

        projectile_inst.life_steps -= 1;
        if (projectile_inst.life_steps <= 0) {
            if (!is_undefined(projectile_inst.beam_acc)) {
                ds_map_destroy(projectile_inst.beam_acc);
                projectile_inst.beam_acc = undefined;
            }
            instance_destroy(projectile_inst);
        }
    }

    on_draw = function(projectile_inst) {
        var x1 = projectile_inst.origin_x;
        var y1 = projectile_inst.origin_y;
        var x2 = projectile_inst.end_x;
        var y2 = projectile_inst.end_y;

        var len = point_distance(x1, y1, x2, y2);

        if (sprite_exists(projectile_inst.beam_sprite)) {
            var frames = max(1, sprite_get_number(projectile_inst.beam_sprite));
            var frame = floor(projectile_inst.beam_anim_t) mod frames;
            var sw = max(1, sprite_get_width(projectile_inst.beam_sprite));
            var sh = max(1, sprite_get_height(projectile_inst.beam_sprite));

            var xscale = len / sw;
            var yscale = projectile_inst.beam_width / sh;

            draw_sprite_ext(projectile_inst.beam_sprite, frame, x1, y1, xscale, yscale, projectile_inst.image_angle, c_white, 1);
        } else {
            gpu_set_blendmode(bm_add);
            draw_set_alpha(0.35);
            draw_set_color(make_color_rgb(120, 170, 255));
            draw_line_width(x1, y1, x2, y2, projectile_inst.beam_glow);
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_line_width(x1, y1, x2, y2, projectile_inst.beam_width);
            gpu_set_blendmode(bm_normal);
        }
    }

    _beam_clamp_to_walls = function(x1, y1, x2, y2) {
        var tmap = layer_tilemap_get_id("Tile_Collision");
        var max_len = point_distance(x1, y1, x2, y2);
        var ang = point_direction(x1, y1, x2, y2);
        var step = 4;
        var steps = ceil(max_len / step);
        var last_x = x1, last_y = y1;

        for (var i = 1; i <= steps; i++) {
            var px = x1 + lengthdir_x(i * step, ang);
            var py = y1 + lengthdir_y(i * step, ang);

            var hit_tile = false;
            var hit_wall = false;

            if (tmap != -1) {
                hit_tile = tilemap_get_at_pixel(tmap, px, py) != 0;
            }

            // Let's Buff Lightning a bit shall we
            //with (obj_clay_wall) {
                //if (point_distance(x, y, px, py) < 32) {
                    //hit_wall = true;
                    //break;
                //}
            //}

            if (hit_tile || hit_wall) {
                return { x: last_x, y: last_y };
            }

            last_x = px;
            last_y = py;
        }

        return { x: x2, y: y2 };
    }
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

