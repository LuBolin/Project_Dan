global.player = id;

// Set depth so player renders in front of doors and other objects
depth = -10;

// Invuln timer for player to escape if they get hit
invuln = false

// Detection radius used to check if enemies can spot player
detection_radius = default_detection_radius;
// Wind gust pending for Current element ability
wind_gust_pending = undefined;
plant_healing_pending = undefined;
creation_clone_pending = undefined;

// Check if player is carrying over an element from previous run
var carried_element = undefined;
if (variable_global_exists("carried_over_element") && global.carried_over_element != undefined) {
    carried_element = global.carried_over_element;
    // Clear the carried over element so it's only used once
    global.carried_over_element = undefined;
}

if (carried_element != undefined) {
    // Player is carrying over one element from previous run
    // Randomly select 2 more base elements (excluding the carried one if it's a base element)
    var base_elements = [GourdFire, GourdEarth, GourdWater, GourdAir];

    // Remove the carried element type if it's a base element (by name)
    var carried_name = carried_element.name;
    var base_names = ["Fire", "Earth", "Water", "Air"];

    for (var i = array_length(base_elements) - 1; i >= 0; i--) {
        if (base_names[i] == carried_name) {
            array_delete(base_elements, i, 1);
            break;
        }
    }

    // Shuffle remaining base elements
    for (var i = array_length(base_elements) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = base_elements[i];
        base_elements[i] = base_elements[j];
        base_elements[j] = temp;
    }

    // Create inventory with carried element and 2 random base elements
    self.inv = [
        carried_element,
        gourd_create(base_elements[0]),
        gourd_create(base_elements[1])
    ];
} else {
    // Fresh start - randomly select 3 of the 4 base elements (Fire, Earth, Water, Air)
    var base_elements = [GourdFire, GourdEarth, GourdWater, GourdAir];

    // Shuffle the array using Fisher-Yates algorithm
    for (var i = array_length(base_elements) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = base_elements[i];
        base_elements[i] = base_elements[j];
        base_elements[j] = temp;
    }

    // Take the first 3 elements after shuffling
    self.inv = [
        //gourd_create(base_elements[0]),
        //gourd_create(base_elements[1]),
        //gourd_create(base_elements[2])
		gourd_create(GourdElixir),
		gourd_create(GourdEruption),
		gourd_create(GourdDestruction)
    ];
}

// Apply inventory override from cutscene (if present)
if (variable_global_exists("next_room_inv_names") && is_array(global.next_room_inv_names)) {
    self.inv = [];
    var names = global.next_room_inv_names;
    for (var i = 0; i < array_length(names); i++) {
        var ctor = get_gourd_type_by_name(names[i]);
        if (ctor != undefined) {
            array_push(self.inv, gourd_create(ctor));
        }
    }

    // Pad to 3 if any failed to map
    var fallbacks = [GourdFire, GourdEarth, GourdWater, GourdAir];
    var f = 0;
    while (array_length(self.inv) < 3 && f < array_length(fallbacks)) {
        array_push(self.inv, gourd_create(fallbacks[f]));
        f++;
    }

    if (array_length(self.inv) == 0) {
        self.inv = [ gourd_create(GourdFire), gourd_create(GourdEarth), gourd_create(GourdWater) ];
    }

    // Restore selection
    if (variable_global_exists("next_room_sel_slot")) {
        self.sel_slot = clamp(global.next_room_sel_slot, 0, max(0, array_length(self.inv) - 1));
    } else {
        self.sel_slot = 0;
    }
    self.equipped_element = self.inv[self.sel_slot];

    global.next_room_inv_names = undefined;
    global.next_room_sel_slot = undefined;
}

self.sel_slot = 0;
self.equipped_element = inv[sel_slot]

alarm[0] = 10
//var aim_arrow = instance_create_layer(x, y, layer, obj_aim_arrow);
//aim_arrow.player = id;
//aim_arrow.depth = self.depth + 1;

//var cam_isnst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
//if (cam_inst == noone) cam_inst = instance_create_layer(x, y, layer, obj_camera);
//cam_inst.follow = id;
//cam_inst.smooth = 0.12;
//cam_inst.preferred_ratio = 0.2;

// Entities that the player will physically collide with, such as walls
colliders = [layer_tilemap_get_id("Tile_Collision"), obj_clay_wall];


// ==================== SPRITES =============================
// active gourd icon
spr_gourd_icon = spr_gourd;

// Effect Sprite for Burn Effect, etc
// Switch to a Hashmap or sth if needed
effect_sprite = undefined

// Character sprites - idle/still
spr_idle_right = spr_character_still;
spr_idle_up = spr_character_still_up;
spr_idle_down = spr_character_still_down;

// Character sprites - attack
spr_attack_right = spr_character_attack_right;
spr_attack_left = spr_character_attack_left;
spr_attack_up = spr_character_attack_up;
spr_attack_down = spr_character_attack_down;

// Animation state
facing_direction = "right"; // "up", "down", "left", "right"
is_attacking = false;
attack_frame = 0;
attack_animation_speed = 0.5; // frames per game frame
// ==========================================================

// For Health HUD
is_hurt_this_level = false;


death_timer = -1;