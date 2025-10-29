// NO STATUS EFFECTS - Skip update_status_effects() entirely

// Check if owner still exists
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// Decrease lifetime
life_timer--;

// Fade in at start
if (fade_timer < fade_in_duration) {
    fade_timer++;
    image_alpha = 0.8 * (fade_timer / fade_in_duration);
}
// Fade out near end of life (last 2 seconds)
else if (life_timer <= 2 * game_get_speed(gamespeed_fps)) {
    var fade_progress = life_timer / (2 * game_get_speed(gamespeed_fps));
    image_alpha = 0.8 * fade_progress;
}
// Fully visible in between
else {
    image_alpha = 0.8;
}

// Destroy when lifetime expires
if (life_timer <= 0) {
    // Create destruction particles
    repeat(8) {
        var particle = instance_create_layer(
            x + random_range(-16, 16), 
            y + random_range(-16, 16), 
            "Instances", 
            obj_projectile
        );
        if (instance_exists(particle)) {
            particle.sprite_index = spr_wind_gust;
            particle.image_alpha = 0.6;
            particle.image_xscale = 0.2;
            particle.image_yscale = 0.2;
            particle.image_blend = make_color_rgb(255, 215, 0); // Golden
            particle.speed = 1;
            particle.direction = random(360);
            particle.life_steps = 30;
            particle.proj_data = {}; // No collision
        }
    }
    
    instance_destroy();
    exit;
}

// Death check
if (hp <= 0) {
    // Create death particles
    repeat(5) {
        var particle = instance_create_layer(
            x + random_range(-8, 8), 
            y + random_range(-8, 8), 
            "Instances", 
            obj_projectile
        );
        if (instance_exists(particle)) {
            particle.sprite_index = spr_wind_gust;
            particle.image_alpha = 0.8;
            particle.image_xscale = 0.15;
            particle.image_yscale = 0.15;
            particle.image_blend = c_red;
            particle.speed = 0.5;
            particle.direction = random(360);
            particle.life_steps = 20;
            particle.proj_data = {}; // No collision
        }
    }
    
    instance_destroy();
    exit;
}

// AI Logic using script functions (no stun checking needed)
switch (state) {
    case "idle":
        clone_ai_find_target(self);
        break;
        
    case "moving":
        clone_ai_move_to_target(self);
        break;
        
    case "attacking":
        clone_ai_attack_target(self);
        break;
}

// Update attack timer
if (attack_timer > 0) attack_timer--;

// Update clone elements cooldowns
for (var i = 0; i < array_length(clone_elements); i++) {
    clone_elements[i].step();
}