/// Alchemy Controller - Draw GUI

// === DRAW BACKGROUND ===
draw_set_color(col_bg);
draw_rectangle(0, 0, gui_width, gui_height, false);

// === DRAW TITLE ===
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(gui_width / 2, 30, "Alchemy Workshop");

// === DRAW EQUIPPED GOURDS (Left side - vertical row) ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(equipped_x, equipped_start_y - 40, "Equipped:");

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

    // Draw gourd name
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(slot_x + equipped_slot_size / 2, slot_y + equipped_slot_size / 2, gourd.name);
}

// === DRAW CRAFTING EQUATIONS ===
for (var eq = 0; eq < 2; eq++) {
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

                draw_set_color(col_text);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(result_x + equation_slot_size / 2, result_y + equation_slot_size / 2, equation.result.name);
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
            draw_set_color(col_text);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(input1_x + equation_slot_size / 2, input1_y + equation_slot_size / 2, equation.input1.name);
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
            draw_set_color(col_text);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(input2_x + equation_slot_size / 2, input2_y + equation_slot_size / 2, equation.input2.name);
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
    }

    if (dragged_gourd != noone) {
        draw_set_alpha(0.7);
        draw_set_color(dragged_gourd.color);
        draw_rectangle(draw_x, draw_y, draw_x + draw_size, draw_y + draw_size, false);
        draw_set_alpha(1);

        draw_set_color(col_border);
        draw_rectangle(draw_x, draw_y, draw_x + draw_size, draw_y + draw_size, true);

        draw_set_color(col_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(draw_x + draw_size / 2, draw_y + draw_size / 2, dragged_gourd.name);
    }
}

draw_set_alpha(1);

// === DRAW RECIPE PANEL (Right side) ===
var panel_x = gui_width - 250;
var panel_y = 80;
var panel_w = 230;
var panel_h = gui_height - 200;

// Draw panel background
draw_set_color(make_color_rgb(20, 20, 30));
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);

// Draw panel border
draw_set_color(col_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);

// Draw panel title
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(panel_x + 10, panel_y + 10, "Discovered Recipes:");

// Get all discovered recipes
var discovered = get_discovered_recipes(global.recipe_tree);
var line_height = 35;
var content_start_y = panel_y + 40;

// Draw discovered recipes
for (var i = 0; i < array_length(discovered); i++) {
    var recipe = discovered[i];
    var item_y = content_start_y + (i * line_height);

    // Only draw if visible in panel
    if (item_y + line_height >= panel_y && item_y <= panel_y + panel_h) {
        // Draw recipe name
        draw_set_color(recipe.tier == 0 ? c_yellow : c_lime);
        draw_text(panel_x + 15, item_y, recipe.name);

        // Draw ingredients if not basic element
        if (recipe.tier > 0) {
            draw_set_color(c_gray);
            var ingredients_text = recipe.ingredients[0] + " + " + recipe.ingredients[1];
            draw_text(panel_x + 20, item_y + 15, ingredients_text);
        }
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
draw_text(button_x + button_w / 2, button_y + button_h / 2, "Continue");

// === RESET DRAW SETTINGS ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
