// ========================================
// TIER 0 - BASE ELEMENTS
// ========================================

function ProjectileFire() : ProjectileBase() constructor {
	name = "Fire";
	speed = 6.0;  // units per second
	damage = 1;  // Initial hit damage
	life_steps = game_get_speed(gamespeed_fps) * 0.8;
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = spr_fire_ball;
	scale = 0.6;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
        projectile_inst.image_speed = 0.5; // Animate fire ball
    }
    
	on_hit = function(projectile_inst, target) {
		// Initial damage
		damage_entity(target, projectile_inst.damage);
		// Apply burn effect: 1 damage per second for 3 seconds
		add_status_effect(target, new BurnEffect(game_get_speed(gamespeed_fps) * 3, 1));
		instance_destroy(projectile_inst);
	}
}

function ProjectileRock() : ProjectileBase() constructor {
	name = "Rock";
	speed       = 5.0;  // units per second (1200 / 64)
	damage      = 2;
	life_steps  = game_get_speed(gamespeed_fps) * 1.0;
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

function ProjectileWaterBall() : ProjectileBase() constructor {
	name = "Water Ball";
	speed       = 6.0;  // units per second (900 / 64)
	damage      = 1; // was 2
	life_steps  = game_get_speed(gamespeed_fps) * 1.0;
	kb_speed = 8;        // pixels per frame (knockback still frame-based) - increased from 5
	kb_distance = 20;    // was 30 pixels total - increased from 10
	sprite_index = spr_water_ball;
	scale = 0.6;
    sfx_fire = undefined;
    sfx_hit = undefined;
    
    on_launch = function(projectile_inst) {
        projectile_inst.depth = 0;
        projectile_inst.image_speed = 0.5; // Animate water ball
    }
    
	on_hit = function(projectile_inst, target) {
		damage_entity(target, projectile_inst.damage);
		apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
		instance_destroy(projectile_inst);
	}
}

// Note: Dash distance doesnt do anything. Whoops
function ProjectileAir(_is_invuln = true, _dash_speed = 12, _dash_duration = 10) : ProjectileBase() constructor {
    name = "Air";
    speed = 0;  // Doesn't move
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = _dash_speed;  // Dash speed (pixels per frame) - slower for smoother dash
    //kb_distance = _dash_distance;  // Total dash distance (2 units)
    dash_duration = _dash_duration;  // 0.133 seconds at 60 FPS (96 / 12 = 8 frames)
    sprite_index = spr_wind_gust;
    scale = 0.8;  // Small visual effect
    sfx_fire = snd_air_projectile;
    sfx_hit = undefined;
    is_invuln = _is_invuln;

    on_launch = function(projectile_inst) {
        // Spawn projectile on player
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;
        projectile_inst.speed = 0;
        projectile_inst.image_alpha = 1.0; // Semi-transparent
        projectile_inst.image_speed = 0.3; // Animate wind gust

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
                    particle.image_alpha = 0.6 - (i * 0.06);  // Fade out
                    particle.image_xscale = 4.0;
                    particle.image_yscale = 4.0;
                    particle.image_angle = dash_dir;
                    particle.image_speed = 2.0; // animate trail
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

function ProjectilEnemyAir(_is_invuln = true, _dash_distance = 128, _dash_duration = 8) : ProjectileBase() constructor {
    name = "EnemyAir";
    speed = 0;  // Doesn't move
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 12;  // Dash speed (pixels per frame) - slower for smoother dash
    kb_distance = _dash_distance;  // Total dash distance (2 units)
    dash_duration = _dash_duration;  // 0.133 seconds at 60 FPS (96 / 12 = 8 frames)
    sprite_index = spr_current_gust;
    scale = 0.8;  // Small visual effect
    sfx_fire = snd_air_projectile;
    sfx_hit = undefined;
    is_invuln = _is_invuln;

    // Explicit flags for enemy dash projectile
    damage_player  = true;
    damage_enemies = false;

    on_launch = function(projectile_inst) {
        // Spawn projectile on player
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;
        projectile_inst.speed = 0;
        projectile_inst.image_alpha = 0.8;  // Semi-transparent
        projectile_inst.depth = 0;
        projectile_inst.image_speed = 0.5; // Animate

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
                add_status_effect(player, new EnemyChargeEffect(dash_dir, kb_speed, dash_duration, false));
                
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
                        particle.image_alpha = 0.6 - (i * 0.06);  // Fade out
                        particle.image_xscale = 4.0;
                        particle.image_yscale = 4.0;
                        particle.image_angle = dash_dir;
                        particle.image_speed = 2.0; // animate trail
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

function ProjectileLava() : ProjectileBase() constructor {
    name = "Lava";
    speed       = 6.25;  // units per second (400 / 64) - moderate speed
    damage      = 1;
    life_steps  = game_get_speed(gamespeed_fps) * 2.0; // 2 second max flight time
    kb_speed = 3;  // pixels per frame
    kb_distance = 20; // knockback distance
    sprite_index = spr_lava_ball;
    scale = 0.7;
    sfx_fire = undefined;
    sfx_hit = undefined;

    // Target position for homing
    target_x = 0;
    target_y = 0;
    homing_enabled = false;

    on_launch = function(projectile_inst) {
        // OVERRIDE: use clone's target_enemy if creator is a clone
        var tx, ty;
        if (instance_exists(projectile_inst.creator)
            && projectile_inst.creator.object_index == obj_clone
            && instance_exists(projectile_inst.creator.target_enemy)) {
            tx = projectile_inst.creator.target_enemy.x;
            ty = projectile_inst.creator.target_enemy.y;
        } else {
            tx = mouse_x;
            ty = mouse_y;
        }
        projectile_inst.target_x = tx;
        projectile_inst.target_y = ty;
        projectile_inst.homing_enabled = true;
        projectile_inst.depth = 0;
        projectile_inst.image_speed = 0.2;

        var dir = point_direction(projectile_inst.x, projectile_inst.y, tx, ty);
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
                if (instance_exists(lava) && (projectile_inst.creator == obj_player || projectile_inst.creator == obj_clone)) {
                    lava.damage_enemies = true;
                    lava.damage_player = false;
                }
                lava.creator = projectile_inst.creator;
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
        if (instance_exists(lava) && (projectile_inst.creator == obj_player || projectile_inst.creator == obj_clone)) {
            lava.damage_enemies = true;
            lava.damage_player = false;
        }
        lava.creator = projectile_inst.creator;
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

function ProjectileSteam() : ProjectileBase() constructor {
    name = "Steam";
    // Steam is now implemented as obj_steam area-of-effect
    // This constructor is kept for compatibility but not used
    show_debug_message("Steam uses obj_steam AoE instead of projectile");
}

function ProjectileMudBall() : ProjectileBase() constructor {
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

function ProjectileCurrent() : ProjectileBase() constructor {
    name = "Current";
    speed = 0;  // Doesn't move (player dashes instead)
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 12;  // Dash speed (pixels per frame)
    kb_distance = global.UNIT_LENGTH * 3.5;  // Total dash distance (2 units)
    dash_duration = 10;  // Frames for dash
    sprite_index = spr_wind_gust; // this doesnt affect anything
    scale = 8;  // Small visual effect during dash
    sfx_fire = undefined;
    sfx_hit = undefined;

    // Knockback gust properties (applied at end of dash)
    gust_kb_speed = 4;
    gust_kb_distance = 30;
    gust_speed = 9.375;  // units per second (600 / 64)
    gust_lifetime = game_get_speed(gamespeed_fps) * 0.3;

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
                    particle.sprite_index = spr_current_gust;
                    particle.image_alpha = 0.6 - (i * 0.06);  // Fade out
                    particle.image_xscale = 4.0;
                    particle.image_yscale = 4.0;
                    particle.image_angle = dash_dir;
                    particle.image_speed = 3.0; // animate trail
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

function ProjectileEruption() : ProjectileBase() constructor {
    name = "Eruption";
    speed       = 7.5;  // units per second (480 / 64) - slightly faster than lava
    damage      = 0.8;    // 50% higher damage than regular lava
    life_steps  = game_get_speed(gamespeed_fps) * 2.5; // 2.5 second max flight time
    kb_speed = 4;  // pixels per frame
    kb_distance = 20; // Same knockback than lava
    sprite_index = spr_water_ball; // Reuse lava ball sprite
    scale = 0.8; // Slightly larger than regular lava
    sfx_fire = undefined;
    sfx_hit = undefined;

    // Explicit target flags
    damage_player  = false;
    damage_enemies = true;

    // Target position for homing
    target_x = 0;
    target_y = 0;
    homing_enabled = false;

    // Eruption-specific properties
    explosion_radius = 64 // Distance between pools (1.5 units)
    num_secondary_pools = 6; // Number of pools to spawn around center

    on_launch = function(projectile_inst) {
        // OVERRIDE: use clone target_enemy if available
        var tx, ty;
        if (instance_exists(projectile_inst.creator)
            && projectile_inst.creator.object_index == obj_clone
            && instance_exists(projectile_inst.creator.target_enemy)) {
            tx = projectile_inst.creator.target_enemy.x;
            ty = projectile_inst.creator.target_enemy.y;
        } else {
            tx = mouse_x;
            ty = mouse_y;
        }
        projectile_inst.target_x = tx;
        projectile_inst.target_y = ty;
        projectile_inst.homing_enabled = true;
        projectile_inst.depth = 0;
        projectile_inst.image_speed = 0.2;

        var dir = point_direction(projectile_inst.x, projectile_inst.y, tx, ty);
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
            var base_scale = 0.25; // matches obj_lava_pool base
            center_pool.damage_per_tick = 1; // 50% higher damage than lava
            center_pool.life_timer = game_get_speed(gamespeed_fps) * 10; // Lasts longer
            // Make center pool bigger
            center_pool.image_xscale = base_scale * 1.2;
            center_pool.image_yscale = base_scale * 1.2;
            // Set damage flags if created by player
            if (creator == obj_player || creator == obj_clone) {
                center_pool.damage_enemies = true;
                center_pool.damage_player = false;
            }
            center_pool.creator = creator;
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
                                var base_scale = 0.25;
                                secondary_pool.life_timer = game_get_speed(gamespeed_fps) * 6; // 6 seconds
								secondary_pool.damage_per_tick = 0.2; // 70% of damage of lava
                                // Make secondary pools smaller
                                secondary_pool.image_xscale = base_scale * 0.8;
                                secondary_pool.image_yscale = base_scale * 0.8;
                                // Set damage flags if created by player
                                if (self.creator == obj_player || self.creator == obj_clone) {
                                    secondary_pool.damage_enemies = true;
                                    secondary_pool.damage_player = false;
                                }
                                secondary_pool.creator = self.creator;
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

function ProjectileClay() : ProjectileBase() constructor {
    name = "Clay";
    // Clay is now implemented as direct wall spawning from gourd
    // Constructor is kept for compatibility but not used
    show_debug_message("Clay uses direct wall spawning instead of projectile");
}

function ProjectilePlant() : ProjectileBase() constructor {
    name = "Plant";
    speed = 0;  // Doesn't move (player dashes instead)
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 12; // I suggest we keep it the same throughout for consistency
    //kb_speed = 10;  // Dash speed (pixels per frame) - slightly slower than Air/Current
    
    kb_distance = global.UNIT_LENGTH * 3.5;
    dash_duration_seconds = 0.16;
    dash_duration = 10;
    
    //kb_distance = 96;  // Total dash distance (1.5 units) - shorter than Air/Current
    //dash_duration_seconds = 0.16;  // Dash duration in seconds (slightly longer for nature feel)
    //dash_duration = dash_duration_seconds * game_get_speed(gamespeed_fps);  // Convert to frames
    sprite_index = spr_wind_gust; // Reuse wind gust sprite or create spr_plant_dash
    scale = 0.2;  // Small visual effect during dash
    sfx_fire = undefined;
    sfx_hit = undefined;

    on_launch = function(projectile_inst) {
        // Spawn projectile on player
        projectile_inst.x = projectile_inst.creator.x;
        projectile_inst.y = projectile_inst.creator.y;
        projectile_inst.speed = 0;
        projectile_inst.image_alpha = 0.5;
        projectile_inst.depth = 0;

        // Reference to creator
        var user = projectile_inst.creator;
        if (!instance_exists(user)) {
            instance_destroy(projectile_inst);
            return;
        }

        // Default dash direction toward mouse
        var dash_dir = point_direction(user.x, user.y, mouse_x, mouse_y);

        // If player, prefer movement keys
        if (user.object_index == obj_player) {
            var input_x = (keyboard_check(ord("D")) - keyboard_check(ord("A")));
            var input_y = (keyboard_check(ord("S")) - keyboard_check(ord("W")));
            if (input_x != 0 || input_y != 0) {
                dash_dir = point_direction(0, 0, input_x, input_y);
            }
        } else if (user.object_index == obj_enemy_abstract && instance_exists(global.player)) {
            dash_dir = point_direction(user.x, user.y, global.player.x, global.player.y);
        }

        // Apply knockback dash
        add_status_effect(user, new KnockbackEffect(dash_dir, kb_speed, dash_duration, false));

        // Short invuln only for player
        if (user.object_index == obj_player) {
            var invuln_time_seconds = 0.15;
            var invuln_duration = (dash_duration_seconds + invuln_time_seconds) * game_get_speed(gamespeed_fps);
            add_status_effect(user, new InvincibilityEffect(invuln_duration));
        }

        // Particle & healing scheduling only for player
        if (user.object_index == obj_player) {
            // Nature particle trail
            var trail_length = 5;
            for (var i = 0; i < trail_length; i++) {
                var offset = i * 8;
                var trail_x = user.x - lengthdir_x(offset, dash_dir);
                var trail_y = user.y - lengthdir_y(offset, dash_dir);
                var particle = instance_create_layer(trail_x, trail_y, "Instances", obj_projectile);
                if (particle != noone) {
                    particle.sprite_index = spr_current_gust; // placeholder leaf/plant sprite
                    particle.image_alpha = 0.6 - (i * 0.06);  // Fade out
                    particle.image_xscale = 4.0;
                    particle.image_yscale = 4.0;
                    particle.image_angle = dash_dir;
                    particle.image_blend = make_color_rgb(100, 200, 100); // Green nature tint
                    particle.image_speed = 3.0; // animate trail
                    particle.speed = 0;
                    particle.life_steps = (0.5 - (i * 0.15)) * game_get_speed(gamespeed_fps);
                    particle.proj_data = {};
                }
            }

            // Schedule healing area spawn after dash (handled in player step using plant_healing_pending)
            user.plant_healing_pending = {
                spawn_x: user.x,
                spawn_y: user.y,
                creator: user,
                timer: 0,
                dash_duration: dash_duration,
                dash_duration_seconds: dash_duration_seconds
            };
        }

        // Destroy projectile immediately
        instance_destroy(projectile_inst);
    }
}

function ProjectileHurricane() : ProjectileBase() constructor {
    name = "Hurricane";
    speed       = 3;
    damage      = 3;
    life_steps  = game_get_speed(gamespeed_fps) * 5;
    kb_speed = 0;
    kb_distance = 0;

    // Base logical scale
    scale = 0.4;

    // Visual multiplier used when drawing
    visual_mul = 4;

    // Use single sprite for both visual & collision (optional keep separate)
    sprite_index = spr_hurricane;
    sfx_fire = undefined;
    sfx_hit = undefined;
    damage_player  = false;
    damage_enemies = !damage_player;

    on_launch = function(projectile_inst) {
        projectile_inst.image_angle = 0;
        projectile_inst.hit_targets = ds_map_create();
        projectile_inst.depth = 0;
        // Store cached visual scale (actual draw scale)
        projectile_inst.visual_scale = scale * visual_mul;
        // Precompute radius from bbox to better match visible cyclone
        var bw = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index);
        var bh = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index);
        var base_diam = max(bw, bh); // bounding box diameter
        projectile_inst.aoe_radius = (base_diam * projectile_inst.visual_scale) * 0.5;
    }

    on_step = function(projectile_inst) {
        // If scale changes dynamically, recompute (else comment out)
        var bw = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index);
        var bh = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index);
        projectile_inst.aoe_radius = (max(bw, bh) * projectile_inst.visual_scale) * 0.5;

        var radius = projectile_inst.aoe_radius;
        var now_ms = current_time;

        // Helper to apply slow+periodic damage
        var tick_ms = 500; // 0.5s between damage ticks
        var slow_dur = game_get_speed(gamespeed_fps) * 0.7;
        var slow_pct = 0.5;

        // Damage enemies in radius
        if (projectile_inst.damage_enemies) {
            var enemies = ds_list_create();
            var n = collision_circle_list(projectile_inst.x, projectile_inst.y, radius, obj_enemy_abstract, false, true, enemies, false);
            for (var i = 0; i < n; i++) {
                var e = enemies[| i];
                if (!instance_exists(e)) continue;

                // Refresh slow while overlapping
                add_status_effect(e, new SlowEffect(slow_dur, slow_pct));
                
                // Periodic damage each second
                var key = e.id;
                var last = ds_map_find_value(projectile_inst.hit_targets, key);
                if (is_undefined(last) || (now_ms - last >= tick_ms)) {
                    damage_entity(e, damage/2);
                    // projectile_inst.creator
                    with (e) {
                        curr_state.player_interact()
                    }
                    ds_map_set(projectile_inst.hit_targets, key, now_ms);
                }
            }
            ds_list_destroy(enemies);
        }

        // Damage player in radius (if configured)
        if (projectile_inst.damage_player && instance_exists(obj_player)) {
            if (point_distance(projectile_inst.x, projectile_inst.y, obj_player.x, obj_player.y) <= radius) {
                add_status_effect(obj_player, new SlowEffect(slow_dur, slow_pct));
                var keyp = obj_player.id;
                var lastp = ds_map_find_value(projectile_inst.hit_targets, keyp);
                if (is_undefined(lastp) || (now_ms - lastp >= tick_ms)) {
                    damage_entity(obj_player, 1);
                    ds_map_set(projectile_inst.hit_targets, keyp, now_ms);
                }
            }
        }

        // Gentle deceleration (optional)
        projectile_inst.speed = max(0, projectile_inst.speed - 0.04);
    }

    on_draw = function(projectile_inst) {
        draw_sprite_ext(sprite_index, 0,
            projectile_inst.x, projectile_inst.y,
            projectile_inst.visual_scale, projectile_inst.visual_scale,
            0, c_white, 1);

        // Optional debug: show AoE circle
        if (global.debug_draw_collisions) {
            draw_set_color(c_aqua);
            draw_set_alpha(0.35);
            draw_circle(projectile_inst.x, projectile_inst.y, projectile_inst.aoe_radius, true);
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }

    on_destroy = function(projectile_inst) {
        if (!is_undefined(projectile_inst.hit_targets)) {
            ds_map_destroy(projectile_inst.hit_targets);
            projectile_inst.hit_targets = undefined;
        }
    }
}
// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function ProjectileDestruction() : ProjectileBase() constructor {
    name = "Destruction";
    // Destruction is now implemented as screen-wide effect
    // This constructor is kept for compatibility but not used
    show_debug_message("Destruction uses screen-wide effect instead of projectile");
}

function ProjectileCreation() : ProjectileBase() constructor {
    name = "Creation";
    speed = 0;  // Doesn't move (player dashes instead)
    damage = 0;
    life_steps = 1;  // Destroy immediately after dash
    kb_speed = 12;  // Dash speed (pixels per frame) - same as Air
    kb_distance = global.UNIT_LENGTH * 3.5;  // Total dash distance (2 units) - same as Air
    dash_duration_seconds = 0.16;  // Dash duration in seconds
    dash_duration = dash_duration_seconds * game_get_speed(gamespeed_fps);  // Convert to frames
    sprite_index = spr_wind_gust; // Reuse wind gust sprite for dash effect
    scale = 0.8;  // Small visual effect during dash
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
                    particle.sprite_index = spr_current_gust; // Use wind gust or create spr_creation_particle
                    particle.image_alpha = 0.6 - (i * 0.06);  // Fade out
                    particle.image_xscale = 4.0;
                    particle.image_yscale = 4.0;
                    particle.image_angle = dash_dir;
                    particle.image_blend = make_color_rgb(255, 215, 0); // Golden tint
                    particle.image_speed = 3.0; // animate trail
                    particle.speed = 0;
                    particle.life_steps = (0.5 - (i * 0.15)) * game_get_speed(gamespeed_fps);
                    particle.proj_data = {};
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

function ProjectileLightningBeam() : ProjectileBase() constructor {
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

    beam_length = 400;
    beam_width = 48; // NEW: matches sprite width (was 16, now base width of sprite)
    beam_glow = 64;  // NEW: increased for better visibility (was 32)
    beam_dps = 8;
    beam_acc = undefined;
    damage_enemies = true;
    damage_player = false;

    beam_sprite = spr_lightning_beam; // NEW sprite: 48×111, origin top-middle
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

            // OVERRIDE: clones aim at their target_enemy instead of mouse
            var aim_x, aim_y;
            if (projectile_inst.creator.object_index == obj_clone
                && instance_exists(projectile_inst.creator.target_enemy)) {
                aim_x = projectile_inst.creator.target_enemy.x;
                aim_y = projectile_inst.creator.target_enemy.y;
            } else {
                aim_x = mouse_x;
                aim_y = mouse_y;
            }
            var new_angle = point_direction(projectile_inst.origin_x, projectile_inst.origin_y, aim_x, aim_y);
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
                    with(e) {
                        curr_state.player_interact();
                    }
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
            
            // NEW: sprite is 48×111 (width × height)
            var sw = max(1, sprite_get_width(projectile_inst.beam_sprite));   // 48
            var sh = max(1, sprite_get_height(projectile_inst.beam_sprite));  // 111

            // ROTATION FIX: New sprite is vertical (top-down), old was horizontal (left-right)
            // Add 90° to image_angle to rotate vertical sprite to horizontal aim direction
            var draw_angle = projectile_inst.image_angle + 90;

            // SCALE SWAP: length stretches sprite vertically (yscale), width controls thickness (xscale)
            // Old (horizontal sprite): xscale = len/sw, yscale = width/sh
            // New (vertical sprite rotated 90°): xscale = width/sw, yscale = len/sh
            var xscale = projectile_inst.beam_width / sw;  // thickness (48px base → beam_width)
            var yscale = len / sh;                         // length stretch

            draw_sprite_ext(projectile_inst.beam_sprite, frame, x1, y1, xscale, yscale, draw_angle, c_white, 1);
        } else {
            // Fallback line drawing (unchanged)
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

            if (tmap != -1) {
                hit_tile = tilemap_get_at_pixel(tmap, px, py) != 0;
            }

            if (hit_tile) {
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

function ProjectileGhost() : ProjectileBase() constructor {
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

    // Explicit target flags
    damage_player  = true;
    damage_enemies = false;
    
    on_hit = function(projectile_inst, target) {
        // Simple: 1 damage, no status effects; knockback handled by your hit system via kb_* fields
        damage_entity(target, projectile_inst.damage);
        instance_destroy(projectile_inst);
    }
}

