/// Alchemy Controller - Draw GUI

// === DRAW PAUSE BUTTON ===
// Position button in top-right corner
var btn_x = pause_button_x;
var btn_y = pause_button_y;

// Button colors
var btn_bg_color = pause_button_hovered ? make_color_rgb(80, 60, 50) : make_color_rgb(50, 40, 30);
var btn_border_color = make_color_rgb(150, 120, 90);
var btn_text_color = c_white;

// Draw button background
draw_set_alpha(0.8);
draw_set_color(btn_bg_color);
draw_rectangle(btn_x, btn_y, btn_x + pause_button_width, btn_y + pause_button_height, false);

// Draw button border
draw_set_alpha(1);
draw_set_color(btn_border_color);
draw_rectangle(btn_x, btn_y, btn_x + pause_button_width, btn_y + pause_button_height, true);

// Draw button text
draw_set_color(btn_text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_x + pause_button_width / 2, btn_y + pause_button_height / 2, pause_button_text);

// Reset draw settings
draw_set_alpha(1);

// Helper function to draw text with black outline
function draw_text_outlined(_x, _y, _text) {
    // Draw black outline
    draw_set_color(c_black);
    for (var ox = -1; ox <= 1; ox++) {
        for (var oy = -1; oy <= 1; oy++) {
            if (ox != 0 || oy != 0) {
                draw_text(_x + ox, _y + oy, _text);
            }
        }
    }
    // Draw white text on top
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}

// === DRAW TITLE ===
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(gui_width / 2, 30, "Alchemy Workshop");

// === DRAW EQUIPPED GOURDS (Left side - vertical row) ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var inventory_text = "Inventory:";
var inventory_y = equipped_start_y - 40;
draw_set_color(col_text);
draw_text(equipped_x, inventory_y, inventory_text);

// Draw underline
var text_width = string_width(inventory_text) - 5; // -5 to not underline the colon
var underline_y = inventory_y + string_height(inventory_text) - 2;
draw_line_width(equipped_x, underline_y, equipped_x + text_width, underline_y, 2);

for (var i = 0; i < 3; i++) {
    // Skip if being dragged
    if (dragging && drag_source_type == "equipped" && drag_source_index == i) continue;

    var slot_x = equipped_x;
    var slot_y = equipped_start_y + i * (equipped_slot_size + equipped_slot_spacing);
    var gourd = equipped_gourds[i];

    // Draw slot background
    draw_set_color(gourd.color);
    draw_rectangle(slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size, false);

    // Draw slot border
    draw_set_color(col_border);
    draw_rectangle(slot_x, slot_y, slot_x + equipped_slot_size, slot_y + equipped_slot_size, true);

    // Draw gourd name with outline
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_outlined(slot_x + equipped_slot_size / 2, slot_y + equipped_slot_size / 2, gourd.name);
}

// === DRAW SEPARATOR LINE (Between left inventory and center crafting) ===
var separator_x = equipped_x + equipped_slot_size + 60;
draw_set_color(col_border);
draw_line_width(separator_x, 60, separator_x, gui_height - 60, 3);

// === DRAW CRAFTING EQUATIONS ===
for (var eq = 0; eq < num_equations; eq++) {
    var equation = equations[eq];
    var base_y = equation_y + eq * (equation_slot_size + equation_spacing);

    // If equation is used, show only the result or failure
    if (equation.used) {
        // Center single slot
        var result_x = equation_x - equation_slot_size / 2;
        var result_y = base_y;

        if (equation.result != noone) {
            // Skip drawing result if it's being dragged
            var is_result_dragged = false;
            if (dragging && drag_source_type == "crafted") {
                if (crafted_elements[drag_source_index].equation_index == eq) {
                    is_result_dragged = true;
                }
            }

            if (!is_result_dragged) {
                // Draw successful craft result
                draw_set_color(equation.result.color);
                draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, false);
                draw_set_color(col_border);
                draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, true);

                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text_outlined(result_x + equation_slot_size / 2, result_y + equation_slot_size / 2, equation.result.name);
            }
        } else {
            // Draw failed craft indicator (red X)
            draw_set_color(col_slot_used);
            draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, false);
            draw_set_color(col_border);
            draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, true);

            // Draw red X
            draw_set_color(c_red);
            var center_x = result_x + equation_slot_size / 2;
            var center_y = result_y + equation_slot_size / 2;
            var x_size = 25;
            for (var i = -2; i <= 2; i++) {
                draw_line(center_x - x_size + i, center_y - x_size, center_x + x_size + i, center_y + x_size);
                draw_line(center_x - x_size + i, center_y + x_size, center_x + x_size + i, center_y - x_size);
            }
        }
    } else {
        // Draw full equation: [input1] + [input2] = [result]
        var slot_col = col_slot_empty;

        // Calculate positions for proper spacing
        var total_width = equation_slot_size * 3 + equation_symbol_spacing * 2;
        var start_x = equation_x - total_width / 2;

        // Draw input slot 1
        var input1_x = start_x;
        var input1_y = base_y;

        draw_set_color(equation.input1 != noone ? equation.input1.color : slot_col);
        draw_rectangle(input1_x, input1_y, input1_x + equation_slot_size, input1_y + equation_slot_size, false);
        draw_set_color(col_border);
        draw_rectangle(input1_x, input1_y, input1_x + equation_slot_size, input1_y + equation_slot_size, true);

        if (equation.input1 != noone) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_outlined(input1_x + equation_slot_size / 2, input1_y + equation_slot_size / 2, equation.input1.name);
        }

        // Draw "+" symbol
        draw_set_color(col_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var plus_x = input1_x + equation_slot_size + equation_symbol_spacing / 2;
        draw_text(plus_x, base_y + equation_slot_size / 2, "+");

        // Draw input slot 2
        var input2_x = input1_x + equation_slot_size + equation_symbol_spacing;
        var input2_y = base_y;

        draw_set_color(equation.input2 != noone ? equation.input2.color : slot_col);
        draw_rectangle(input2_x, input2_y, input2_x + equation_slot_size, input2_y + equation_slot_size, false);
        draw_set_color(col_border);
        draw_rectangle(input2_x, input2_y, input2_x + equation_slot_size, input2_y + equation_slot_size, true);

        if (equation.input2 != noone) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_outlined(input2_x + equation_slot_size / 2, input2_y + equation_slot_size / 2, equation.input2.name);
        }

        // Draw "=" symbol
        draw_set_color(col_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var equals_x = input2_x + equation_slot_size + equation_symbol_spacing / 2;
        draw_text(equals_x, base_y + equation_slot_size / 2, "=");

        // Draw result slot
        var result_x = input2_x + equation_slot_size + equation_symbol_spacing;
        var result_y = base_y;

        draw_set_color(slot_col);
        draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, false);
        draw_set_color(col_border);
        draw_rectangle(result_x, result_y, result_x + equation_slot_size, result_y + equation_slot_size, true);
    }
}

// === DRAW CRAFT FEEDBACK ===
if (craft_feedback != "none" && craft_feedback_timer > 0 && craft_feedback_equation >= 0) {
    var eq_y = equation_y + craft_feedback_equation * (equation_slot_size + equation_spacing);
    var center_x = equation_x; // Center of screen
    var center_y = eq_y + equation_slot_size / 2;

    if (craft_feedback == "success") {
        // Green checkmark effect
        var radius = 50;
        draw_set_color(c_lime);
        draw_set_alpha(0.5);
        draw_circle(center_x, center_y, radius, false);
        draw_set_alpha(1);
    } else if (craft_feedback == "fail") {
        // Red X effect
        var size = 40;
        draw_set_color(c_red);
        draw_set_alpha(0.8);
        for (var i = -2; i <= 2; i++) {
            draw_line(center_x - size + i, center_y - size, center_x + size + i, center_y + size);
            draw_line(center_x - size + i, center_y + size, center_x + size + i, center_y - size);
        }
        draw_set_alpha(1);
    }
}

// === TODO: DRAW NEW ELEMENT ===
draw_set_color(col_text);
draw_text(gui_width / 2, new_ele_separator_y + 20, "New Element!");
draw_line_width(separator_x, new_ele_separator_y, tree_panel_x, new_ele_separator_y, 2);

var new_slot_x = (gui_width - equipped_slot_size - equipped_slot_spacing) / 2;
var new_slot_y = new_ele_separator_y + 40;

// Draw slot background
var new_ele_color = c_gray; // default color
if (new_element != noone && variable_struct_exists(new_element, "color")) {
    new_ele_color = new_element.color;
}
draw_set_color(new_ele_color);
draw_rectangle(new_slot_x, new_slot_y, new_slot_x + equipped_slot_size, new_slot_y + equipped_slot_size, false);

// Draw slot border
draw_set_color(col_border);
draw_rectangle(new_slot_x, new_slot_y, new_slot_x + equipped_slot_size, new_slot_y + equipped_slot_size, true);

// Draw gourd name with outline
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_outlined(new_slot_x + equipped_slot_size / 2, new_slot_y + equipped_slot_size / 2, new_element.name);


// === DRAW DRAGGED ITEM (on top of everything) ===
if (dragging) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var draw_x = mx - drag_offset_x;
    var draw_y = my - drag_offset_y;
    var draw_size = equipped_slot_size;
    var dragged_gourd = noone;

    if (drag_source_type == "equipped") {
        dragged_gourd = equipped_gourds[drag_source_index];
    } else if (drag_source_type == "crafted") {
        dragged_gourd = crafted_elements[drag_source_index].gourd;
        draw_size = equation_slot_size;
    } else if (drag_source_type == "new") {
        dragged_gourd = new_element;
    }

    if (dragged_gourd != noone) {
        draw_set_alpha(0.7);
        draw_set_color(dragged_gourd.color);
        draw_rectangle(draw_x, draw_y, draw_x + draw_size, draw_y + draw_size, false);
        draw_set_alpha(1);

        draw_set_color(col_border);
        draw_rectangle(draw_x, draw_y, draw_x + draw_size, draw_y + draw_size, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_outlined(draw_x + draw_size / 2, draw_y + draw_size / 2, dragged_gourd.name);
    }
}

draw_set_alpha(1);

// === DRAW RECIPE TREE (Right side) ===
// Draw tree panel background
draw_set_color(make_color_rgb(20, 20, 30));
draw_rectangle(tree_panel_x, tree_panel_y, tree_panel_x + tree_panel_w, tree_panel_y + tree_panel_h, false);

// Draw panel border
draw_set_color(col_border);
draw_rectangle(tree_panel_x, tree_panel_y, tree_panel_x + tree_panel_w, tree_panel_y + tree_panel_h, true);

// Get all discovered recipes
var discovered_array = get_discovered_recipes(global.recipe_tree);
// GML bugs out here and gives warning about discovered_map
// separate declaration and initialization into 2 lines fixes it, idk why -- Bolin
var discovered_map = pointer_null;
discovered_map = {};
for (var i = 0; i < array_length(discovered_array); i++) {
    discovered_map[$ discovered_array[i].name] = true;
}

// Load JSON to get recipe connections
var json_data = load_recipes_from_json("recipes.json");

// Draw connectors first (so they appear behind nodes)
for (var i = 0; i < array_length(json_data.recipes); i++) {
    var recipe = json_data.recipes[i];
    var result_name = recipe.result;

    // Only draw connectors if result is discovered
    if (variable_struct_exists(discovered_map, result_name)) {
        var result_pos = tree_positions[$ result_name];
        var result_x = tree_start_x + result_pos.x;
        var result_y = tree_start_y + result_pos.y;

        // Draw lines to each ingredient
        for (var j = 0; j < array_length(recipe.ingredients); j++) {
            var ingredient_name = recipe.ingredients[j];

            // Only draw connector if ingredient is discovered
            if (variable_struct_exists(discovered_map, ingredient_name)) {
                var ingredient_pos = tree_positions[$ ingredient_name];
                var ingredient_x = tree_start_x + ingredient_pos.x;
                var ingredient_y = tree_start_y + ingredient_pos.y;

                // Draw line from ingredient to result
                draw_set_color(make_color_rgb(100, 150, 200));
                draw_line_width(ingredient_x, ingredient_y + tree_node_size / 2,
                              result_x, result_y + tree_node_size / 2, 2);
            }
        }
    }
}

// Draw all nodes
var element_names = variable_struct_get_names(tree_positions);
for (var i = 0; i < array_length(element_names); i++) {
    var elem_name = element_names[i];
    var pos = tree_positions[$ elem_name];
    var node_x = tree_start_x + pos.x - tree_node_size / 2;
    var node_y = tree_start_y + pos.y - tree_node_size / 2;

    var is_discovered = variable_struct_exists(discovered_map, elem_name);

    // Get element color (find matching gourd type)
    var elem_color = c_gray;
    var gourd_type = get_gourd_type_by_name(elem_name);
    if (gourd_type != undefined) {
        var temp_gourd = gourd_create(gourd_type);
        elem_color = temp_gourd.color;
    }

    // Check if this is the Elixir (final goal)
    var is_elixir = (elem_name == "Elixir");

    // Draw node background
    if (is_discovered) {
        // Special glow effect for Elixir
        if (is_elixir) {
            var glow_alpha = 0.3 + sin(elixir_glow_timer * 0.1) * 0.2;
            draw_set_alpha(glow_alpha);
            draw_set_color(c_yellow);
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size * 0.7, false);
            draw_set_alpha(1);

            // Draw gourd sprite for Elixir
            var gourd_scale = tree_node_size / sprite_get_width(spr_gourd);
            draw_sprite_ext(spr_gourd, 0,
                          node_x + tree_node_size / 2,
                          node_y + tree_node_size / 2,
                          gourd_scale, gourd_scale, 0, c_black, 1);
        } else {
            // Draw circle for other elements
            draw_set_color(elem_color);
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, false);
        }
    } else {
        // Greyed out for undiscovered
        if (is_elixir) {
            // Draw gourd sprite in grey for undiscovered Elixir
            var gourd_scale = tree_node_size / sprite_get_width(spr_gourd);
            draw_sprite_ext(spr_gourd, 0,
                          node_x + tree_node_size / 2,
                          node_y + tree_node_size / 2,
                          gourd_scale, gourd_scale, 0, make_color_rgb(40, 40, 50), 1);
        } else {
            // Draw circle in grey for undiscovered other elements
            draw_set_color(make_color_rgb(40, 40, 50));
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, false);
        }
    }

    // Draw node border (only for non-Elixir nodes)
    if (!is_elixir) {
        draw_set_color(is_discovered ? col_border : make_color_rgb(60, 60, 70));
        draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, true);
    }

    // Draw element name with outline (for discovered elements) or grey (for undiscovered)
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (is_discovered) {
        draw_text_outlined(node_x + tree_node_size / 2, node_y + tree_node_size / 2, elem_name);
    } else {
        draw_set_color(make_color_rgb(80, 80, 90));
        draw_text(node_x + tree_node_size / 2, node_y + tree_node_size / 2, "?");
    }
}


// === DRAW CONTINUE BUTTON ===
draw_set_color(button_hover ? col_button_hover : col_button);
draw_rectangle(button_x, button_y, button_x + button_w, button_y + button_h, false);

draw_set_color(col_border);
draw_rectangle(button_x, button_y, button_x + button_w, button_y + button_h, true);

draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(button_x + button_w / 2, button_y + button_h / 2, "Continue to Next Level");

// === RESET DRAW SETTINGS ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
