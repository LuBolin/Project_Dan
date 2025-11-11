// Check if player is retrying the final boss fight
if (room == Level_FinalBoss && variable_global_exists("boss_retry_inventory") && global.boss_retry_inventory != undefined) {
    // Restore the inventory from the retry
    inv = global.boss_retry_inventory;

    // Convert Elixir back to Lightning for final boss (it was reverted on death)
    for (var i = 0; i < array_length(inv); i++) {
        var elem = inv[i];
        if (is_struct(elem) && variable_struct_exists(elem, "name") && elem.name == "Elixir") {
            inv[i] = gourd_create(GourdLightning);
            show_debug_message("Boss retry: Converted Elixir back to Lightning at slot " + string(i));
        }
    }

    // Restore the selected slot
    if (variable_global_exists("boss_retry_sel_slot")) {
        sel_slot = global.boss_retry_sel_slot;
        equipped_element = inv[sel_slot];
        global.boss_retry_sel_slot = undefined;
    }

    // Restore full HP for retry
    hp = max_hp;

    // Clear the retry inventory flag
    global.boss_retry_inventory = undefined;

    show_debug_message("Boss retry: Inventory restored with " + string(array_length(inv)) + " elements, slot " + string(sel_slot));
}

// Reinitialize collision layer for this room (important for persistent player)
colliders = [layer_tilemap_get_id("Tile_Collision"), obj_clay_wall];

// Use "Instances" layer if it exists, otherwise use any available layer
var target_layer = layer_exists("Instances") ? layer_get_id("Instances") : layer;
var aim_arrow = instance_create_layer(x, y, target_layer, obj_aim_arrow);

aim_arrow.player = id;
aim_arrow.depth = self.depth + 1;

var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
if (cam_inst == noone) cam_inst = instance_create_layer(x, y, target_layer, obj_camera);
cam_inst.follow = id;
cam_inst.smooth = 0.12;
cam_inst.preferred_ratio = 0.2;

// Reheal the player up to 3/8 of their health
var heal_up = max_hp * 0.375;
hp = hp < heal_up ? heal_up : hp; 
is_hurt_this_level = false;

cam_inst.preferred_ratio = 0.12; // Lower = more zoomed out (player takes less of screen)


if (check_if_gourdname_equipped(inv, "Elixir") || check_if_gourdname_equipped(inv, "Lightning")) {
    has_elixir_life = true;
}