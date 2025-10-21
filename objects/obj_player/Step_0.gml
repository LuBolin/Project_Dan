update_status_effects(self);

if (hp <= 0) {
    // Player died - make non-persistent and return to main menu
    persistent = false;
    instance_destroy();
    room_goto(MainMenu);
    exit;
}

// Check if stunned - if so, skip movement input
var input_dirn_x = 0;
var input_dirn_y = 0;

if (!variable_instance_exists(self, "is_stunned") || !is_stunned) {
    if (keyboard_check(ord("A"))) input_dirn_x -= 1;
    if (keyboard_check(ord("D"))) input_dirn_x += 1;
    if (keyboard_check(ord("W"))) input_dirn_y -= 1;
    if (keyboard_check(ord("S"))) input_dirn_y += 1;

    var magnitude = sqrt(input_dirn_x * input_dirn_x + input_dirn_y * input_dirn_y);

    // Convert units per second to pixels per frame
    // units/sec * pixels/unit / frames/sec = pixels/frame
    var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);

    var vel_hori = (magnitude == 0 ? 0 : (input_dirn_x / magnitude)) * move_speed_this_frame;
    var vel_vert = (magnitude == 0 ? 0 : (input_dirn_y / magnitude)) * move_speed_this_frame;

    
    // Horizontal movement
    if (place_meeting(x + vel_hori, y, colliders)) {
        
        // Allows the players to smoothly slide past corners
        if (!place_meeting(x + vel_hori, y + move_speed_this_frame, colliders)) {
            y += move_speed_this_frame
        } else if (!place_meeting(x + vel_hori, y - move_speed_this_frame, colliders)) {
            y -= move_speed_this_frame
        } else {
            vel_hori = 0;   
        }
        
    }
    
    x += vel_hori;
    
    if (place_meeting(x, y + vel_vert, colliders)) {
        
        // Allows the players to smoothly slide past corners
        if (!place_meeting(x + move_speed_this_frame, y + vel_vert , colliders)) {
            x += move_speed_this_frame
        } else if (!place_meeting(x - move_speed_this_frame, y + vel_vert, colliders)) {
            x -= move_speed_this_frame
        } else {
            vel_vert = 0;   
        }
    }
    
    y += vel_vert;
    

    if (input_dirn_x != 0) {
        var scale = abs(image_xscale);
        image_xscale = (input_dirn_x > 0) ? scale : -scale;
    }
}

// Handle wind gust spawning after dash
if (variable_instance_exists(self, "wind_gust_pending") && wind_gust_pending != undefined) {
    // Increment timer
    if (is_struct(wind_gust_pending) && variable_struct_exists(wind_gust_pending, "timer")) {
        wind_gust_pending.timer++;
    } else {
        wind_gust_pending.timer = 1;
    }

    if (wind_gust_pending.timer >= wind_gust_pending.dash_duration) {
        // Spawn the knockback gust projectile at player's current position
        var gust_proj = instance_create_layer(x, y, "Instances", obj_projectile);
        if (gust_proj != noone) {
            gust_proj.sprite_index = spr_wind_gust;
            gust_proj.image_angle = wind_gust_pending.direction;
            gust_proj.direction = wind_gust_pending.direction;
            gust_proj.speed = wind_gust_pending.gust_speed;
            gust_proj.image_xscale = 0.7;
            gust_proj.image_yscale = 0.7;
            gust_proj.life_steps = wind_gust_pending.gust_lifetime;
            gust_proj.damage = 0;
            gust_proj.kb_speed = wind_gust_pending.kb_speed;
            gust_proj.kb_distance = wind_gust_pending.kb_distance;
            gust_proj.creator = wind_gust_pending.creator;

            // Set up on_hit to apply knockback
            gust_proj.proj_data = {
                on_hit: function(projectile_inst, target) {
                    apply_knockback(projectile_inst, target, projectile_inst.kb_speed, projectile_inst.kb_distance);
                    // Wind gust doesn't destroy on hit - passes through enemies
                }
            };
        }

        // Remove the pending gust data
        wind_gust_pending = undefined;
    }
}

// Ranged Vacuum Pickup for Chi
with (obj_chi) {
    var dist = point_distance(x, y, other.x, other.y);
    
    if (dist < other.pickup_radius) {
        // Move toward player smoothly
        var dir = point_direction(x, y, other.x, other.y);
        x = lerp(x, other.x, 0.1);
        y = lerp(y, other.y, 0.1);
    }
}


for (var i = 0; i < array_length(self.inv); i++) {
    self.inv[i].step();
}