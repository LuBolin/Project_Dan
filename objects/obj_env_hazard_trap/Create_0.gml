function lava_attack() {
    var env_trap = instance_create_layer(other.x, other.y, "Instances", obj_lava_pool);
    if (instance_exists(env_trap)) {
        // Configure this lava pool to damage the player instead of enemies
        env_trap.damage_enemies = true;  // damage enemies (For consistency :< )
        env_trap.damage_player = true;    // Damage the player
        env_trap.creator = self;        // Set boss as creator
        env_trap.scale = 2;               // Set the Lava to be bigger so the player has less room to "camp"
        // Make boss lava pools more threatening // Higher damage
        // UPDATE NOTE: Made it lower damage cuz player dies way too quickly
        env_trap.damage_per_tick = 1;     
        env_trap.life_timer = game_get_speed(gamespeed_fps) * spawn_freq; // Last longer
        
        show_debug_message("Spawned player-damaging lava pool at " + string(other.x) + ", " + string(other.y));
    }
}

function spawn_hazard() {
    var telegraphing = instance_create_layer(x, y, "Instances", obj_telegraph_attack); 
    if (instance_exists(telegraphing)) { 
        telegraphing.init_telegraph_attack(lava_attack, c_yellow, 6);
    } else {
        show_debug_message("ERROR: Telegraphing failed due to invalid spawn coordinates!") 
    }
}

spawn_cd = 0;