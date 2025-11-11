// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > life_duration - fade_in_duration) {
    image_alpha = min(0.6, image_alpha + (0.6 / fade_in_duration));
}
// Fade out near end
else if (!is_forever && life_timer <= fade_out_duration) {
    image_alpha = max(0, image_alpha - (0.6 / fade_out_duration));
}
// Fully visible in between
else {
    image_alpha = 0.6; // Semi-transparent green
}

// Rotate for visual effect
// image_angle += rotation_speed; // remove rotation
image_angle = 0; // ensure no rotation

// Healing tick logic
tick_counter++;
if (tick_counter >= tick_rate) {
    tick_counter = 0;

    curr_time = current_time;
    
    // Loop through both player and enemy objects
    var possible_heal_targets = heal_enemies ? [obj_player, obj_enemy_abstract] : [obj_player];
    
    for (var i = 0; i < array_length(possible_heal_targets); i += 1) {
        var entity = possible_heal_targets[i]
        // Check if player is within healing radius
        if (instance_exists(entity)) {
            with(entity) { 
                var distance = point_distance(x, y, other.x, other.y);
            
                if (distance <= other.healing_radius) {
                    // Check heal cooldown
                    if (other.curr_time - other.last_heal_time >= other.heal_cooldown) {
                        // Only heal if player is not at full health
                        if (hp < max_hp) {
                            // Heal the player
                            hp = min(max_hp, hp + other.heal_per_tick);
                            other.last_heal_time = other.curr_time;
                            
                            // Visual feedback - green flash for healing
                            if (variable_instance_exists(self, "image_blend")) {
                                image_blend = make_color_rgb(100, 255, 100); // Light green
                                sfx_play(snd_heal, false, entity.object_index == obj_player ? 1 : 0.5);
                                alarm[11] = 10; // Short flash duration
                            }
                            
                            // Create healing particle effect
                            other.create_healing_particles(self);
                            
                            show_debug_message("Plant healed player for " + string(other.heal_per_tick) + " HP");
                        }
                    }
                }
            }

        }
    }
    
}

// Create ambient particles occasionally
particle_timer++;
if (particle_timer >= particle_interval) {
    particle_timer = 0;
    create_ambient_particles();
}

// Destroy when lifetime expires
if (!is_forever and life_timer <= 0) {
    instance_destroy();
}

/// @function create_healing_particles()
/// @description Creates particles when player is healed
create_healing_particles = function(_target) {
    repeat(3) {
        var particle = instance_create_layer(
            _target.x + random_range(-16, 16), 
            _target.y + random_range(-16, 16), 
            "Instances", 
            obj_projectile
        );
        if (instance_exists(particle)) {
            particle.sprite_index = spr_ambient_heal_particle; // Use wind gust or create spr_heal_particle
            particle.image_alpha = 1;
            particle.image_xscale = 1;
            particle.image_yscale = 1;
            particle.image_blend = make_color_rgb(150, 255, 150); // Light green
            particle.speed = 0.5;
            particle.direction = random(360);
            particle.life_steps = 0.5 * game_get_speed(gamespeed_fps); // 0.5 seconds
            particle.proj_data = {}; // No collision
            
            // Set depth to render above player (player depth is -10)
			// Note: Should use the effects layer i think
            particle.depth = -20; // More negative = renders on top
        }
    }
}

/// @function create_ambient_particles()
/// @description Creates ambient floating particles around the healing area
create_ambient_particles = function() {
    var particle = instance_create_layer(
        x + random_range(-healing_radius, healing_radius), 
        y + random_range(-healing_radius, healing_radius), 
        "Instances", 
        obj_projectile
    );
    if (instance_exists(particle)) {
        particle.sprite_index = spr_ambient_heal_particle; // Use wind gust or create spr_nature_particle
        particle.image_alpha = 0.7;
        particle.image_xscale = 0.8;
        particle.image_yscale = 0.8;
        particle.image_blend = make_color_rgb(100, 200, 100); // Green
        particle.speed = 0.2;
        particle.direction = random(360);
        particle.life_steps = 1.0 * game_get_speed(gamespeed_fps); // 1 second
        particle.proj_data = {}; // No collision
    }
}