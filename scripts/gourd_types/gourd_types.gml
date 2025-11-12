function GourdNone()  : GourdBase() constructor {
	name = "(Empty)";
	cooldown = 0;
	use=function(_p){};
}

// ========================================
// TIER 0 - BASE ELEMENTS
// ========================================

function GourdFire() : GourdBase() constructor
{
    name = "Fire";
	color = c_red;
    cooldown = 3;
	projectile = ProjectileFire;
}

function GourdEarth() : GourdBase() constructor
{
    name = "Earth";
	color = make_color_rgb(25, 50, 0);
    cooldown = 1.5;
	projectile = ProjectileRock;
}

function GourdWater() : GourdBase() constructor
{
    name = "Water";
	color = c_blue;
    cooldown = 1; // was 3
	projectile = ProjectileWaterBall;
}

function GourdAir() : GourdBase() constructor
{
    name = "Air";
	color = c_white;
    cooldown = 3;
	projectile = ProjectileAir;
}

// ========================================
// TIER 1 - BASIC COMBINATIONS
// ========================================

function GourdLava() : GourdBase() constructor
{
    name = "Lava";
    color = c_orange;
    cooldown = 6;
    projectile = ProjectileLava;
}

function GourdSteam() : GourdBase() constructor
{
    name = "Steam";
	color = make_color_rgb(200, 220, 255);
    cooldown = 8;
	projectile = undefined; // Steam doesn't use projectiles
    
    use = function(_p) {
        if (can_use()) {
            // Check if steam cloud already exists for this player
            var player_steam = noone;
            with (obj_steam) {
                if (owner == _p) {
                    player_steam = id;
                    break;
                }
            }

            if (player_steam == noone) {
                // Create steam cloud at player position
                var steam = instance_create_layer(_p.x, _p.y, "Instances", obj_steam);
                steam.owner = _p;
                trigger_cd();
            } else {
                // Refresh existing steam cloud duration for this player
                with (player_steam) {
                    life_timer = life_duration;
                }
                trigger_cd();
            }
        }
    }
}

function GourdMud() : GourdBase() constructor
{
    name = "Mud";
	color = make_color_rgb(101, 67, 33);
    cooldown = 4;
	projectile = ProjectileMudBall;
}

function GourdCurrent() : GourdBase() constructor
{
    name = "Current";
	color = make_color_rgb(100, 150, 200);
    cooldown = 5;
	projectile = ProjectileCurrent;
}

// ========================================
// TIER 2 - ADVANCED COMBINATIONS
// ========================================

function GourdEruption() : GourdBase() constructor
{
    name = "Eruption";
	color = make_color_rgb(255, 50, 0);
    cooldown = 7;
	projectile = ProjectileEruption;
}

function GourdHurricane() : GourdBase() constructor
{
    name = "Hurricane";
	color = make_color_rgb(70, 130, 180);
    cooldown = 6;
	projectile = ProjectileHurricane;
}

function GourdClay() : GourdBase() constructor
{
    name = "Clay";
    color = make_color_rgb(178, 118, 88);
    cooldown = 6; // 6 second cooldown
    projectile = undefined; // Clay doesn't use projectiles
    
    use = function(_p) {
        if (can_use()) {
            // Get direction player is aiming
            var aim_direction = point_direction(_p.x, _p.y, mouse_x, mouse_y);
            
            // Spawn clay wall extending from player in aim direction
            spawn_clay_wall(_p.x, _p.y, aim_direction);
            trigger_cd();
        }
    }
    
    // Helper function to create the clay fissure
    spawn_clay_wall = function(start_x, start_y, direction) {
        // Wall properties
        var wall_segments = 6; // Number of wall pieces
        var segment_spacing = 45; // Distance between wall segments (0.75 units)
        var wall_scale = 1.0; // Scale factor for wall size
        var initial_offset = 20; // Start wall further away from player
        
        // IMMEDIATELY UPDATE COLLISION ARRAYS BEFORE SPAWNING WALLS
        with (obj_player) {
            if (array_get_index(colliders, obj_clay_wall) == -1) {
                array_push(colliders, obj_clay_wall);
                show_debug_message("Added clay wall to player collision array");
            }
        }
        
        with (obj_enemy_abstract) {
            if (array_get_index(colliders, obj_clay_wall) == -1) {
                array_push(colliders, obj_clay_wall);
                show_debug_message("Added clay wall to enemy " + string(id) + " collision array");
            }
        }
        
        // Start spawning from offset position, extending outward in aim direction
        for (var i = 1; i <= wall_segments; i++) {
            // Add initial_offset to push wall away from player
            var segment_x = start_x + lengthdir_x(initial_offset + (i * segment_spacing), direction);
            var segment_y = start_y + lengthdir_y(initial_offset + (i * segment_spacing), direction);
            
            // Check if position is valid (not in existing walls)
            var can_place = true;
            
            // Check collision with terrain
            var tilemap = layer_tilemap_get_id("Tile_Collision");
            var tile = tilemap_get_at_pixel(tilemap, segment_x, segment_y);
            if (tile != 0) {
                can_place = false;
            }
            
            // Check collision with existing clay walls (minimum distance check)
            with (obj_clay_wall) {
                if (point_distance(x, y, segment_x, segment_y) < 20) {
                    can_place = false;
                    break;
                }
            }
            
            // Only spawn if position is valid
            if (can_place) {
                var wall_segment = instance_create_layer(segment_x, segment_y, "Instances", obj_clay_wall);
                if (instance_exists(wall_segment)) {
                    // Orient wall segment in the same direction as aim
                    wall_segment.image_angle = direction - 90;
                    
                    // Scale segments
                    wall_segment.image_xscale = wall_scale;
                    wall_segment.image_yscale = wall_scale;
                }
            } else {
                // Stop creating wall if we hit an obstacle
                break;
            }
        }
        
        show_debug_message("Clay fissure spawned with " + string(wall_segments) + " segments in direction " + string(direction));
    }
}

function GourdPlant() : GourdBase() constructor
{
    name = "Plant";
    color = make_color_rgb(50, 200, 50);
    cooldown = 7; // 7 second cooldown (longer than Air/Current due to healing benefit)
    projectile = ProjectilePlant;
}

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function GourdDestruction() : GourdBase() constructor
{
    name = "Destruction";
    color = make_color_rgb(150, 0, 0);
    cooldown = 15; // Long cooldown for powerful screen-clearing ability
    projectile = undefined; // Destruction doesn't use projectiles
    
    use = function(_p) {
        if (can_use()) {
            // Create destruction effect that covers the screen
            var destruction_effect = instance_create_layer(_p.x, _p.y, "Instances", obj_destruction_effect);
            if (instance_exists(destruction_effect)) {
                destruction_effect.creator = _p;
                show_debug_message("Destruction effect activated - screen clearing attack!");
            }
            trigger_cd();
        }
    }
}

function GourdCreation() : GourdBase() constructor
{
    name = "Creation";
	color = make_color_rgb(255, 255, 200);
    cooldown = 12;
	projectile = ProjectileCreation;
}

// ========================================
// TIER 4 - FINAL ELEMENT
// ========================================

function GourdElixir() : GourdBase() constructor
{
    name = "Elixir";
    color = make_color_rgb(255, 215, 0);
    cooldown = 10;
    projectile = undefined; // Final element - no projectile
    
    use = function(_p) {
        if (can_use()) {
            // Create visual effect at player position
            var elixir_effect = instance_create_layer(_p.x, _p.y, "Instances", obj_projectile);
            if (instance_exists(elixir_effect)) {
                elixir_effect.sprite_index = spr_wind_gust; // Reuse wind sprite or create elixir effect sprite
                elixir_effect.image_alpha = 0.8;
                elixir_effect.image_xscale = 0.8;
                elixir_effect.image_yscale = 0.8;
                elixir_effect.image_blend = make_color_rgb(255, 215, 0); // Golden color
                elixir_effect.speed = 0; // Stationary effect
                elixir_effect.life_steps = 60; // 1 second visual effect
                elixir_effect.proj_data = {}; // No collision
            }
            
            // Apply 5 seconds of invincibility
            var invuln_duration = 5 * game_get_speed(gamespeed_fps); // 5 seconds in frames
            add_status_effect(_p, new ElixirInvincibilityEffect(invuln_duration));
            
            // Visual feedback - golden flash
            if (variable_instance_exists(_p, "image_blend")) {
                _p.image_blend = make_color_rgb(255, 215, 0); // Golden flash
                _p.alarm[11] = 20; // Flash duration (will reset to white after 20 frames)
            }
            
            trigger_cd();
            show_debug_message("Elixir used - Player is invulnerable for 5 seconds!");
        }
    }
}

function GourdLightning() : GourdBase() constructor
{
    name = "Lightning";
    color = make_color_rgb(180, 220, 255);
    cooldown = 15; // seconds
    projectile = ProjectileLightningBeam;

    use = function(_p) {
        if (can_use()) {
            // Fire at current aim (mouse) position
            spawn_and_set_projectile(_p, new projectile(), mouse_x, mouse_y);
            trigger_cd();
        }
    }
}

// Helper function to get gourd type constructor by element name
function get_gourd_type_by_name(element_name) {
    switch (element_name) {
        case "Earth": return GourdEarth;
        case "Water": return GourdWater;
        case "Fire": return GourdFire;
        case "Air": return GourdAir;
        case "Mud": return GourdMud;
        case "Lava": return GourdLava;
        case "Steam": return GourdSteam;
        case "Current": return GourdCurrent;
        case "Eruption": return GourdEruption;
        case "Hurricane": return GourdHurricane;
        case "Clay": return GourdClay;
        case "Plant": return GourdPlant;
        case "Destruction": return GourdDestruction;
        case "Creation": return GourdCreation;
        case "Elixir": return GourdElixir;
        case "Lightning": return GourdLightning;
        default: return undefined;
    }
}

// Helper function to get element descriptions
function get_element_description(element_name) {
    switch(element_name) {
        // Base elements
        case "Fire": return "Shoots water balls that burns enemies";
        case "Earth": return "Launches rocks that stuns enemies";
        case "Water": return "Shoots water balls that knocks back enemies";
        case "Air": return "Use wind to dash through enemies";
        
        // Tier 1
        case "Mud": return "Shoots a mud ball that makes a pool of mud to slow enemies within it";
        case "Lava": return "Create a pool of lava at where you click to burn enemies within it";
        case "Steam": return "Creates steam clouds around you that burns enemies within it";
        case "Current": return "Blow enemies away after dashing";
        
        // Tier 2
        case "Eruption": return "Create a strong pool of lava at where you click with additional pools surrounding it";
        case "Hurricane": return "Shoots a large wind vortex that slows and damages enemies";
        case "Clay": return "Creates defensive walls that stuns and blocks enemies";
        case "Plant": return "Spawns a healing area after dashing";
        
        // Tier 3
        case "Destruction": return "Destruction rains down on all enemies on screen, stunning and damaging them";
        case "Creation": return "Creates a clone after dashing that can use the other elements equipped";
        
        // Tier 4
        case "Elixir": return "Grants invincibility for a short period of time. " +
                              "In certain circumstances, transforms into a powerful lightning beam that pierces through enemies";
        case "Lightning": return "Powerful lightning beam that shoots at where you aim";
        
        default: return "No description available";
    }
}

function check_if_gourdname_equipped(arr, element_name) {
    // Check if this element is already equipped
    for (var i = 0; i < array_length(arr); i++) { 
        if (arr[i].name == element_name) {
            return true;
        }  
    }
    return false;
}

