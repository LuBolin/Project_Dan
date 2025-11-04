update_status_effects(self);


if (hp < 4) {
    //obj_sfx_manager.play_sound()
}

if (hp <= 0) {
    // Player died - show death screen with element selection
    // Store player's current inventory for death screen
    global.player_death_inventory = [inv[0], inv[1], inv[2]];
    
    // Create death screen (persistent so it stays across room transitions)
    if (!instance_exists(obj_death_screen)) {
        instance_create_depth(0, 0, -9999, obj_death_screen);
    }

    // Make player non-persistent and destroy
    persistent = false;
    instance_destroy();
    exit;
}



//********************** MOVEMENT ***********************************/
// Check if stunned - if so, skip movement input
var input_dirn_x = 0;
var input_dirn_y = 0;

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

// Vertical movement
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

//***************************************************************/

// Handle wind gust spawning after dash (used by Current element)
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

// Handle plant healing area spawning after dash (used by Plant element)
if (variable_instance_exists(self, "plant_healing_pending") && plant_healing_pending != undefined) {
    // Increment timer
    if (is_struct(plant_healing_pending) && variable_struct_exists(plant_healing_pending, "timer")) {
        plant_healing_pending.timer++;
    } else {
        plant_healing_pending.timer = 1;
    }

    // Check if dash duration has passed
    if (plant_healing_pending.timer >= plant_healing_pending.dash_duration) {
        // Spawn the healing area at player's current position (after dash)
        var healing_area = instance_create_layer(x, y, "Instances", obj_plant);
        if (instance_exists(healing_area)) {
            healing_area.owner = plant_healing_pending.creator;
            show_debug_message("Plant healing area spawned at player position after " + 
                             string(plant_healing_pending.dash_duration_seconds) + " seconds");
        }

        // Remove the pending healing data
        plant_healing_pending = undefined;
    }
}

// Handle creation clone spawning after dash (used by Creation element)
if (variable_instance_exists(self, "creation_clone_pending") && creation_clone_pending != undefined) {
    // Increment timer
    if (is_struct(creation_clone_pending) && variable_struct_exists(creation_clone_pending, "timer")) {
        creation_clone_pending.timer++;
    } else {
        creation_clone_pending.timer = 1;
    }

    // Check if dash duration has passed
    if (creation_clone_pending.timer >= creation_clone_pending.dash_duration) {
        // Spawn the clone at the initial position (where player started the dash)
        var clone = instance_create_layer(creation_clone_pending.spawn_x, creation_clone_pending.spawn_y, "Instances", obj_clone);
        if (instance_exists(clone)) {
            clone.owner = creation_clone_pending.creator;
            
            // Copy player's elements to clone (simplified versions)
            if (variable_instance_exists(clone, "clone_elements")) {
                clone.clone_elements = [];
                for (var i = 0; i < array_length(inv); i++) {
                    if (inv[i].name != "(Empty)" && inv[i].name != "Creation") { // EXCLUDE Creation element
                        // Use the get_gourd_constructor_by_name function from alchemy controller
                        var element_constructor = get_gourd_type_by_name(inv[i].name);
                        if (element_constructor != undefined) {
                            var clone_element = gourd_create(element_constructor);
                            clone_element.cooldown *= 1.5; // Clone elements have longer cooldowns
                            array_push(clone.clone_elements, clone_element);
                        }
                    }
                }
                
                // If clone has no elements after filtering, give it a basic element
                if (array_length(clone.clone_elements) == 0) {
                    var fallback_element = gourd_create(GourdFire); // Give clone Fire as fallback
                    fallback_element.cooldown *= 1.5;
                    array_push(clone.clone_elements, fallback_element);
                    show_debug_message("Clone had no valid elements, gave Fire as fallback");
                }
            }
            
            show_debug_message("Creation clone spawned at initial position after " + 
                             string(creation_clone_pending.dash_duration_seconds) + " seconds with " + 
                             string(array_length(clone.clone_elements)) + " elements (Creation excluded)");
        }

        // Remove the pending clone data
        creation_clone_pending = undefined;
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