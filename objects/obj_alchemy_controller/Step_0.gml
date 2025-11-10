/// Alchemy Controller - Step

// Advance animated backdrop frame with ping-pong
if (sprite_exists(spr_alchemy_bg_anim)) {
    var _frames = sprite_get_number(spr_alchemy_bg_anim);
    if (_frames > 0) {
        backdrop_frame += backdrop_frame_step * backdrop_frame_direction;

        // Ping-pong: reverse direction at boundaries
        if (backdrop_frame >= _frames - 1) {
            backdrop_frame = _frames - 1;
            backdrop_frame_direction = -1; // Start going backward
        } else if (backdrop_frame <= 0) {
            backdrop_frame = 0;
            backdrop_frame_direction = 1; // Start going forward
        }
    }
}


// ========== ALCHEMY TREE FADE IN ===================
if (recently_crafted) {
    fade_alpha = min(fade_alpha + fade_in_speed, 1);
} else {
    fade_alpha = 1
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// === PAUSE BUTTON INTERACTION ===
// Check if mouse is hovering over button
pause_button_hovered = point_in_rectangle(mx, my, pause_button_x, pause_button_y,
                                          pause_button_x + pause_button_width,
                                          pause_button_y + pause_button_height);

// Check for click on pause button
if (pause_button_hovered && mouse_check_button_pressed(mb_left)) {
    // Trigger pause (same as pressing Escape)
    if (instance_exists(obj_pause_menu)) {
        with (obj_pause_menu) {
            event_perform(ev_keypress, vk_escape);
        }
    }
}

// === TOOLTIP HOVER DETECTION ===
tooltip_hovered_element = noone;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check if mouse is over any element in the tree
var element_names = variable_struct_get_names(tree_positions);
for (var i = 0; i < array_length(element_names); i++) {
    var elem_name = element_names[i];
    var pos = tree_positions[$ elem_name];
    var node_x = tree_start_x + pos.x;
    var node_y = tree_start_y + pos.y;
    
    // Check if mouse is within node circle
    var dist = point_distance(mx, my, node_x, node_y);
    if (dist <= tree_node_size / 2) {
        tooltip_hovered_element = elem_name;
        tooltip_x = mx + 15;
        tooltip_y = my + 15;
        break;
    }
}

// === HELPER FUNCTION: Try to craft from equation inputs ===
function try_craft_equation(eq_index) {
    var eq = equations[eq_index];
    var ing1 = eq.input1.name;
    var ing2 = eq.input2.name;

    // Find matching recipe
    var recipe = find_recipe_by_ingredients(global.recipe_tree, ing1, ing2);

    if (recipe != noone) {
        // Success! Mark recipe as discovered AND crafted
        recipe.discovered = true;
        recipe.crafted = true;
        
        // Find the recipe ID from JSON to update the correct node
        var json_data = load_recipes_from_json("recipes.json");
        var recipe_id = undefined;
        for (var i = 0; i < array_length(json_data.recipes); i++) {
            if (json_data.recipes[i].result == recipe.name) {
                recipe_id = json_data.recipes[i].id;
                break;
            }
        }
        
        // Update using recipe ID (lowercase)
        if (recipe_id != undefined && variable_struct_exists(global.recipe_tree, recipe_id)) {
            global.recipe_tree[$ recipe_id].discovered = true;
            global.recipe_tree[$ recipe_id].crafted = true;
        }

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
        global.has_crafted_before = true;
        recently_crafted = (global.has_crafted_before != recently_crafted) ? true : false;
        fade_alpha = 0;
    } else {
        // Fail
        craft_feedback = "fail";
        craft_feedback_timer = craft_feedback_duration;
        craft_feedback_equation = eq_index;
    }

    // Mark equation as used
    eq.used = true;
}

// === DRAG & DROP SYSTEM ===

// Start dragging
if (mouse_check_button_pressed(mb_left) && !dragging) {
    
    // Check equipped gourds
    for (var i = 0; i < 3; i++) {
        var slot_x = equipped_x;
        var slot_y = equipped_start_y + i * (equipped_slot_size + equipped_slot_spacing);

        if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size)) {
            sfx_play(snd_alchemy, true)
            dragging = true;
            drag_source_type = "equipped";
            drag_source_index = i;
            drag_offset_x = mx - slot_x;
            drag_offset_y = my - slot_y;
            break;
        }
    }
    
    
    // Check new element
    if (!dragging) {
        var new_slot_x = (gui_width - equipped_slot_size - equipped_slot_spacing) / 2;
        var new_slot_y = new_ele_separator_y + 40;
        
        if (point_in_rectangle(mx, my, new_slot_x, new_slot_y, new_slot_x + equipped_slot_size, new_slot_y + equipped_slot_size)) {
            sfx_play(snd_alchemy, true)
            dragging = true;
            drag_source_type = "new";
            drag_source_index = 0;
            drag_offset_x = mx - new_slot_x;
            drag_offset_y = my - new_slot_y;
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
                sfx_play(snd_alchemy, true)
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
    } else if (drag_source_type == "new") {
        dragged_gourd = new_element;
    }

    // Check if dropped on equation slots
    for (var eq = 0; eq < num_equations; eq++) {
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
    if (!dropped && (drag_source_type == "crafted" or drag_source_type == "new")) {
        for (var i = 0; i < 3; i++) {
            var slot_x = equipped_x;
            var slot_y = equipped_start_y + i * (equipped_slot_size + equipped_slot_spacing);

            if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size)) {
                var temp_gourd = equipped_gourds[i];
                equipped_gourds[i] = dragged_gourd;

                // Handle swap differently for crafted vs new elements
                if (drag_source_type == "crafted") {
                    // Replace the crafted element with the equipped one
                    var eq_idx = crafted_elements[drag_source_index].equation_index;
                    crafted_elements[drag_source_index].gourd = temp_gourd;
                    equations[eq_idx].result = temp_gourd; // Also update the equation result
                } else if (drag_source_type == "new") {
                    // Replace the new element with the equipped one
                    new_element = temp_gourd;
                }

                dropped = true;
                break;
            }
        }
    }

    // Check if dropped on crafted slots (for swapping equipped with crafted)
    if (!dropped && (drag_source_type == "equipped" or drag_source_type == "new")) {
        for (var i = 0; i < array_length(crafted_elements); i++) {
            var eq_idx = crafted_elements[i].equation_index;
            var base_y = equation_y + eq_idx * (equation_slot_size + equation_spacing);

            // After crafting, the result is centered
            var result_x = equation_x - equation_slot_size / 2;
            var result_y = base_y;

            if (point_in_rectangle(mx, my, result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size)) {
                // Swap element with crafted result
                var temp_gourd = crafted_elements[i].gourd;
                crafted_elements[i].gourd = dragged_gourd;
                equations[eq_idx].result = dragged_gourd; // Also update the equation result

                // Handle swap differently for equipped vs new elements
                if (drag_source_type == "equipped") {
                    // Replace the equipped element with the crafted one
                    equipped_gourds[drag_source_index] = temp_gourd;
                } else if (drag_source_type == "new") {
                    // Replace the new element with the crafted one
                    new_element = temp_gourd;
                }

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
// Check hover state (only if popup is not shown)
if (!show_confirmation_popup) {
    button_hover = point_in_rectangle(mx, my, button_x, button_y, button_x + button_w, button_y + button_h);

    // Check click
    if (button_hover && mouse_check_button_pressed(mb_left)) {
        // Show confirmation popup instead of immediately proceeding
        show_confirmation_popup = true;
        mouse_clear(mb_left); // Clear click to prevent accidental interactions
    }
}

// === CONFIRMATION POPUP LOGIC ===
if (show_confirmation_popup) {
    // Check button hover states
    popup_ok_hover = point_in_rectangle(mx, my, popup_ok_x, popup_ok_y, 
                                       popup_ok_x + popup_button_width, popup_ok_y + popup_button_height);
    popup_cancel_hover = point_in_rectangle(mx, my, popup_cancel_x, popup_cancel_y, 
                                           popup_cancel_x + popup_button_width, popup_cancel_y + popup_button_height);

    // Handle OK button click
    if (popup_ok_hover && mouse_check_button_pressed(mb_left)) {
        // Proceed to next level (original continue button logic)
        show_confirmation_popup = false;
        
        // Reactivate player
        instance_activate_object(obj_player);

        // Update player's inventory
        if (instance_exists(obj_player)) {
            obj_player.inv[0] = equipped_gourds[0];
            obj_player.inv[1] = equipped_gourds[1];
            obj_player.inv[2] = equipped_gourds[2];
            obj_player.equipped_element = obj_player.inv[obj_player.sel_slot];
        }

        // Clear mouse button state to prevent click carrying over to next room
        io_clear();

        // Advance to next level or return to menu
        advance_level_progress();
    }

    // Handle Cancel button click
    if (popup_cancel_hover && mouse_check_button_pressed(mb_left)) {
        // Close popup and return to alchemy screen
        show_confirmation_popup = false;
        mouse_clear(mb_left);
    }

    // Handle Escape key to cancel
    if (keyboard_check_pressed(vk_escape)) {
        show_confirmation_popup = false;
        keyboard_clear(vk_escape);
    }
}

// === ELIXIR GLOW ANIMATION ===
elixir_glow_timer++;
