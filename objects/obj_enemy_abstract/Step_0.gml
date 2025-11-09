// Update status effects
update_status_effects(self);

if_death();

if (!pause && !is_undefined(curr_state)) {
    curr_state.step();
} else {
    path_end();
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