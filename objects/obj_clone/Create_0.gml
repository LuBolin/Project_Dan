// Clone properties
owner = noone; // The player who created this clone
max_hp = 3; // Clone has lower health than player
hp = max_hp;
base_damage = 1; // Clone deals less damage

// Movement properties
move_speed_ups = 2.5; // Slightly slower than player
vel_hori = 0;
vel_vert = 0;

// Visual properties
image_alpha = 0.8; // Semi-transparent to distinguish from player
image_blend = make_color_rgb(255, 215, 0); // Golden tint
image_xscale = 0.25; // Same size as player
image_yscale = 0.25;

// Lifespan: 12 seconds
life_duration_seconds = 12;
life_duration = life_duration_seconds * game_get_speed(gamespeed_fps);
life_timer = life_duration;

// Combat properties
detection_radius = 3 * global.UNIT_LENGTH; // 3 units detection range
attack_cooldown_seconds = 1.5; // 1.5 seconds between attacks
attack_cooldown = attack_cooldown_seconds * game_get_speed(gamespeed_fps);
attack_timer = 0;

// Clone elements (copy from player)
clone_elements = [];
clone_element_index = 0;

// AI state
target_enemy = noone;
state = "idle"; // "idle", "moving", "attacking"

// Collision (copy from player setup)
colliders = [layer_tilemap_get_id("Tile_Collision"), obj_clay_wall];

// Set depth same as player
depth = -10;

// NO STATUS EFFECTS - Skip them entirely for now

// Other player-like properties that clone needs
invuln = false;
effect_sprite = undefined;

// Fade in effect
fade_in_duration = 20; // frames
fade_timer = 0;

show_debug_message("Clone created with " + string(life_duration_seconds) + " second lifespan (no status effects)");