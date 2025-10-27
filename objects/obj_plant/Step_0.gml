// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > life_duration - fade_in_duration) {
    image_alpha = min(0.6, image_alpha + (0.6 / fade_in_duration));
}
// Fade out near end
else if (life_timer <= fade_out_duration) {
    image_alpha = max(0, image_alpha - (0.6 / fade_out_duration));
}
// Fully visible in between
else {
    image_alpha = 0.6; // Semi-transparent green
}

// Rotate for visual effect
image_angle += rotation_speed;

// Healing tick logic
tick_counter++;
if (tick_counter >= tick_rate) {
    tick_counter = 0;

    var curr_time = current_time;

    // Check if player is within healing radius
    if (instance_exists(obj_player)) {
        var distance = point_distance(x, y, obj_player.x, obj_player.y);
        
        if (distance <= healing_radius) {
            // Check heal cooldown
            if (curr_time - last_heal_time >= heal_cooldown) {
                // Only heal if player is not at full health
                if (obj_player.hp < obj_player.max_hp) {
                    // Heal the player
                    obj_player.hp = min(obj_player.max_hp, obj_player.hp + heal_per_tick);
                    last_heal_time = curr_time;
                    
                    // Visual feedback - green flash for healing
                    if (variable_instance_exists(obj_player, "image_blend")) {
                        obj_player.image_blend = make_color_rgb(100, 255, 100); // Light green
                        obj_player.alarm[11] = 10; // Short flash duration
                    }
                    
                    // Create healing particle effect
                    create_healing_particles();
                    
                    show_debug_message("Plant healed player for " + string(heal_per_tick) + " HP");
                }
            }
        }
    }
}

// Create ambient particles occasionally
particle_timer++;
if (particle_timer >= 30) { // Every 0.5 seconds
    particle_timer = 0;
    create_ambient_particles();
}

// Destroy when lifetime expires
if (life_timer <= 0) {
    instance_destroy();
}

/// @function create_healing_particles()
/// @description Creates particles when player is healed
create_healing_particles = function() {
    repeat(3) {
        var particle = instance_create_layer(
            obj_player.x + random_range(-16, 16), 
            obj_player.y + random_range(-16, 16), 
            "Instances", 
            obj_projectile
        );
        if (instance_exists(particle)) {
            particle.sprite_index = spr_wind_gust; // Use wind gust or create spr_heal_particle
            particle.image_alpha = 0.8;
            particle.image_xscale = 0.2;
            particle.image_yscale = 0.2;
            particle.image_blend = make_color_rgb(150, 255, 150); // Light green
            particle.speed = 0.5;
            particle.direction = random(360);
            particle.life_steps = 30;
            particle.proj_data = {}; // No collision
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
        particle.sprite_index = spr_wind_gust; // Use wind gust or create spr_nature_particle
        particle.image_alpha = 0.3;
        particle.image_xscale = 0.15;
        particle.image_yscale = 0.15;
        particle.image_blend = make_color_rgb(100, 200, 100); // Green
        particle.speed = 0.2;
        particle.direction = random(360);
        particle.life_steps = 60;
        particle.proj_data = {}; // No collision
    }
}