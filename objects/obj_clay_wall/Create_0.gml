life_timer = game_get_speed(gamespeed_fps) * 6; // Same as cooldown (6 seconds)

// Initial placement damage (only when wall spawns)
placement_damage = 2;
placement_knockback_speed = 12;
placement_knockback_distance = 80;

// Animation control: play once, hold last frame
image_speed = 0.5; // Adjust speed to taste (lower = slower)
image_index = 0;    // Start from first frame

// Track which enemies have been damaged by initial placement
initially_damaged_enemies = ds_list_create();

// Set depth so walls render above terrain but below projectiles
depth = 50;

// Visual fade-out at end of life
fade_out_duration = 30; // frames to fade out at end
alpha = 1;

// Initial damage flag - only damage on first frame
is_first_frame = true;

// FORCE COLLISION RECOGNITION - Make sure ALL entities see this wall immediately
with (obj_player) {
    if (array_get_index(colliders, obj_clay_wall) == -1) {
        array_push(colliders, obj_clay_wall);
    }
}

with (obj_enemy_abstract) {
    if (array_get_index(colliders, obj_clay_wall) == -1) {
        array_push(colliders, obj_clay_wall);
    }
}

// Visual scale (for center pieces)
if (!variable_instance_exists(self, "image_xscale")) image_xscale = 1;
if (!variable_instance_exists(self, "image_yscale")) image_yscale = 1;

sfx_play(snd_clay, false);    