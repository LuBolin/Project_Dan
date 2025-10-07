/// Alchemy Controller - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// === HELPER FUNCTION: Try to craft from equation inputs ===
function try_craft_equation(eq_index) {
    var eq = equations[eq_index];
    var ing1 = eq.input1.name;
    var ing2 = eq.input2.name;

    // Find matching recipe
    var recipe = find_recipe_by_ingredients(global.recipe_tree, ing1, ing2);

    if (recipe != noone) {
        // Success! Mark recipe as discovered
        recipe.discovered = true;

        // Create the crafted gourd based on recipe result
        var crafted_gourd = get_gourd_constructor_by_name(recipe.name);

        if (crafted_gourd != noone) {
            // Add to crafted elements array
            array_push(crafted_elements, {
                gourd: crafted_gourd,
                equation_index: eq_index
            });

            eq.result = crafted_gourd;
        }

        craft_feedback = "success";
        craft_feedback_timer = craft_feedback_duration;
        craft_feedback_equation = eq_index;
    } else {
        // Fail
        craft_feedback = "fail";
        craft_feedback_timer = craft_feedback_duration;
        craft_feedback_equation = eq_index;
    }

    // Mark equation as used
    eq.used = true;
}

// === HELPER FUNCTION: Get gourd constructor by name ===
function get_gourd_constructor_by_name(name) {
    switch(name) {
        case "Earth": return gourd_create(GourdEarth);
        case "Water": return gourd_create(GourdWater);
        case "Wind": return gourd_create(GourdWind);
        case "Mud": return gourd_create(GourdMud);
        case "Hurricane": return gourd_create(GourdHurricane);
        default: return noone;
    }
}

// === DRAG & DROP SYSTEM ===

// Start dragging
if (mouse_check_button_pressed(mb_left) && !dragging) {
    // Check equipped gourds
    for (var i = 0; i < 3; i++) {
        var slot_x = equipped_x;
        var slot_y = equipped_start_y + i * (equipped_slot_size + equipped_slot_spacing);

        if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size)) {
            dragging = true;
            drag_source_type = "equipped";
            drag_source_index = i;
            drag_offset_x = mx - slot_x;
            drag_offset_y = my - slot_y;
            break;
        }
    }

    // Check crafted elements
    if (!dragging) {
        for (var i = 0; i < array_length(crafted_elements); i++) {
            var eq_idx = crafted_elements[i].equation_index;
            var base_y = equation_y + eq_idx * (equation_slot_size + equation_spacing);

            // After crafting, the result is centered
            var result_x = equation_x - equation_slot_size / 2;
            var result_y = base_y;

            if (point_in_rectangle(mx, my, result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size)) {
                dragging = true;
                drag_source_type = "crafted";
                drag_source_index = i;
                drag_offset_x = mx - result_x;
                drag_offset_y = my - result_y;
                break;
            }
        }
    }
}

// Stop dragging
if (mouse_check_button_released(mb_left) && dragging) {
    var dropped = false;

    // Get the gourd being dragged
    var dragged_gourd = noone;
    if (drag_source_type == "equipped") {
        dragged_gourd = equipped_gourds[drag_source_index];
    } else if (drag_source_type == "crafted") {
        dragged_gourd = crafted_elements[drag_source_index].gourd;
    }

    // Check if dropped on equation slots
    for (var eq = 0; eq < 2; eq++) {
        if (equations[eq].used) continue; // Skip used equations

        var base_y = equation_y + eq * (equation_slot_size + equation_spacing);

        // Calculate proper positions
        var total_width = equation_slot_size * 3 + equation_symbol_spacing * 2;
        var start_x = equation_x - total_width / 2;

        // Check input slot 1
        var input1_x = start_x;
        var input1_y = base_y;

        if (point_in_rectangle(mx, my, input1_x, input1_y, input1_x + equation_slot_size, input1_y + equation_slot_size)) {
            equations[eq].input1 = dragged_gourd;
            dropped = true;

            // Try to craft if both inputs filled
            if (equations[eq].input1 != noone && equations[eq].input2 != noone) {
                try_craft_equation(eq);
            }
            break;
        }

        // Check input slot 2
        var input2_x = start_x + equation_slot_size + equation_symbol_spacing;
        var input2_y = base_y;

        if (point_in_rectangle(mx, my, input2_x, input2_y, input2_x + equation_slot_size, input2_y + equation_slot_size)) {
            equations[eq].input2 = dragged_gourd;
            dropped = true;

            // Try to craft if both inputs filled
            if (equations[eq].input1 != noone && equations[eq].input2 != noone) {
                try_craft_equation(eq);
            }
            break;
        }
    }

    // Check if dropped on equipped slots (for swapping crafted with equipped)
    if (!dropped && drag_source_type == "crafted") {
        for (var i = 0; i < 3; i++) {
            var slot_x = equipped_x;
            var slot_y = equipped_start_y + i * (equipped_slot_size + equipped_slot_spacing);

            if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size)) {
                // Swap crafted element with equipped
                var temp_gourd = equipped_gourds[i];
                equipped_gourds[i] = dragged_gourd;

                // Replace the crafted element with the equipped one
                var eq_idx = crafted_elements[drag_source_index].equation_index;
                crafted_elements[drag_source_index].gourd = temp_gourd;
                equations[eq_idx].result = temp_gourd; // Also update the equation result

                dropped = true;
                break;
            }
        }
    }

    // Check if dropped on crafted slots (for swapping equipped with crafted)
    if (!dropped && drag_source_type == "equipped") {
        for (var i = 0; i < array_length(crafted_elements); i++) {
            var eq_idx = crafted_elements[i].equation_index;
            var base_y = equation_y + eq_idx * (equation_slot_size + equation_spacing);

            // After crafting, the result is centered
            var result_x = equation_x - equation_slot_size / 2;
            var result_y = base_y;

            if (point_in_rectangle(mx, my, result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size)) {
                // Swap equipped element with crafted
                var temp_gourd = crafted_elements[i].gourd;
                crafted_elements[i].gourd = dragged_gourd;
                equations[eq_idx].result = dragged_gourd; // Also update the equation result

                // Replace the equipped element with the crafted one
                equipped_gourds[drag_source_index] = temp_gourd;

                dropped = true;
                break;
            }
        }
    }

    dragging = false;
    drag_source_type = "none";
    drag_source_index = -1;
}

// === CRAFT FEEDBACK TIMER ===
if (craft_feedback_timer > 0) {
    craft_feedback_timer--;
    if (craft_feedback_timer <= 0) {
        craft_feedback = "none";
    }
}

// === CONTINUE BUTTON ===
// Check hover state
button_hover = point_in_rectangle(mx, my, button_x, button_y, button_x + button_w, button_y + button_h);

// Check click
if (button_hover && mouse_check_button_pressed(mb_left)) {
    // Update player's inventory
    if (instance_exists(obj_player)) {
        obj_player.inv[0] = equipped_gourds[0];
        obj_player.inv[1] = equipped_gourds[1];
        obj_player.inv[2] = equipped_gourds[2];
    }

    // Clear mouse button state to prevent click carrying over to next room
    io_clear();
    room_goto(GameSandbox);
}
