// Draw semi-transparent overlay
draw_set_alpha(0.7);
draw_set_color(col_overlay_bg);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw panel background with transparency
draw_set_alpha(0.95);
draw_set_color(col_panel_bg);
draw_rectangle(overlay_x, overlay_y, overlay_x + overlay_width, overlay_y + overlay_height, false);
draw_set_alpha(1);

// Draw panel border
draw_set_color(col_panel_border);
draw_rectangle(overlay_x, overlay_y, overlay_x + overlay_width, overlay_y + overlay_height, true);

// Draw title
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(gui_width / 2, overlay_y + 30, "Element Recipe Tree", 2, 2, 0);

// Draw close button (X)
var close_color = close_button_hovered ? col_close_hover : col_close_normal;
draw_set_color(close_color);
draw_rectangle(close_button_x, close_button_y, close_button_x + close_button_size, close_button_y + close_button_size, false);
draw_set_color(col_panel_border);
draw_rectangle(close_button_x, close_button_y, close_button_x + close_button_size, close_button_y + close_button_size, true);

// Draw X
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(close_button_x + close_button_size / 2, close_button_y + close_button_size / 2, "X", 1.5, 1.5, 0);

// Convert GUI coordinates to window coordinates for scissor
var window_scale_x = window_get_width() / gui_width;
var window_scale_y = window_get_height() / gui_height;
var scissor_x = tree_panel_x * window_scale_x;
var scissor_y = tree_panel_y * window_scale_y;
var scissor_w = tree_panel_w * window_scale_x;
var scissor_h = tree_panel_h * window_scale_y;

// Set up clipping for tree area
gpu_set_scissor(scissor_x, scissor_y, scissor_w, scissor_h);

// Draw tree background (matching brown theme)
draw_set_color(make_color_rgb(25, 20, 15));
draw_rectangle(tree_panel_x, tree_panel_y, tree_panel_x + tree_panel_w, tree_panel_y + tree_panel_h, false);

// Get discovered recipes (same logic as alchemy controller)
var discovered_array = get_discovered_recipes(global.recipe_tree);
var discovered_map = {};
for (var i = 0; i < array_length(discovered_array); i++) {
    discovered_map[$ discovered_array[i].name] = true;
}

// Load JSON for recipe connections
var json_data = load_recipes_from_json("recipes.json");

// Draw connectors first
for (var i = 0; i < array_length(json_data.recipes); i++) {
    var recipe = json_data.recipes[i];
    var result_name = recipe.result;

    if (variable_struct_exists(discovered_map, result_name)) {
        var result_pos = tree_positions[$ result_name];
        var result_x = tree_start_x + result_pos.x;
        var result_y = tree_start_y + result_pos.y;

        for (var j = 0; j < array_length(recipe.ingredients); j++) {
            var ingredient_name = recipe.ingredients[j];

            if (variable_struct_exists(discovered_map, ingredient_name)) {
                var ingredient_pos = tree_positions[$ ingredient_name];
                var ingredient_x = tree_start_x + ingredient_pos.x;
                var ingredient_y = tree_start_y + ingredient_pos.y;

                draw_set_color(make_color_rgb(100, 150, 200));
                draw_line_width(ingredient_x, ingredient_y + tree_node_size / 2,
                              result_x, result_y + tree_node_size / 2, 3);
            }
        }
    }
}

// Draw all nodes (same logic as alchemy controller but bigger)
var element_names = variable_struct_get_names(tree_positions);
for (var i = 0; i < array_length(element_names); i++) {
    var elem_name = element_names[i];
    var pos = tree_positions[$ elem_name];
    var node_x = tree_start_x + pos.x - tree_node_size / 2;
    var node_y = tree_start_y + pos.y - tree_node_size / 2;

    var is_discovered = variable_struct_exists(discovered_map, elem_name);
    var is_elixir = (elem_name == "Elixir");

    // Get element color
    var elem_color = c_gray;
    var gourd_type = get_gourd_type_by_name(elem_name);
    if (gourd_type != undefined) {
        var temp_gourd = gourd_create(gourd_type);
        elem_color = temp_gourd.color;
    }

    // Draw node background
    if (is_discovered) {
        // Special glow effect for Elixir
        if (is_elixir) {
            var glow_radius = tree_node_size * 0.7;
            draw_set_alpha(0.3);
            draw_set_color(c_yellow);
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, glow_radius, false);
            draw_set_alpha(1);
        }

        // Draw discovered node
        draw_set_color(elem_color);
        draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, false);
        
        // Draw gourd sprite scaled to fit
        if (sprite_exists(spr_gourd)) {
            var gourd_scale = (tree_node_size * 0.8) / sprite_get_width(spr_gourd);
            draw_sprite_ext(spr_gourd, 0,
                          node_x + tree_node_size / 2,
                          node_y + tree_node_size / 2,
                          gourd_scale, gourd_scale, 0, c_white, 1);
        }
    } else {
        // Undiscovered node
        if (is_elixir) {
            // Bright undiscovered Elixir
            var gourd_scale = (tree_node_size * 0.8) / sprite_get_width(spr_gourd);
            draw_sprite_ext(spr_gourd, 0,
                          node_x + tree_node_size / 2,
                          node_y + tree_node_size / 2,
                          gourd_scale, gourd_scale, 0, make_color_rgb(180, 180, 200), 1);
        } else {
            // Grey circle for other undiscovered elements
            draw_set_color(make_color_rgb(40, 40, 50));
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, false);
        }
    }

    // Draw yellow border for Elixir
    if (is_elixir) {
        draw_set_color(c_yellow);
        var border_radius = tree_node_size * 0.6;
        for (var b = 0; b < 4; b++) {
            draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, border_radius + b, true);
        }
    }

    // Draw node border
    draw_set_color(col_panel_border);
    draw_circle(node_x + tree_node_size / 2, node_y + tree_node_size / 2, tree_node_size / 2, true);

    // Draw element name
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (is_discovered) {
        draw_set_color(c_white);
        // Outline for better readability
        draw_set_color(c_black);
        for (var ox = -1; ox <= 1; ox++) {
            for (var oy = -1; oy <= 1; oy++) {
                if (ox != 0 || oy != 0) {
                    draw_text_transformed(node_x + tree_node_size / 2 + ox, node_y + tree_node_size / 2 + oy, elem_name, 0.9, 0.9, 0);
                }
            }
        }
        draw_set_color(c_white);
        draw_text_transformed(node_x + tree_node_size / 2, node_y + tree_node_size / 2, elem_name, 0.9, 0.9, 0);
    } else {
        draw_set_color(make_color_rgb(120, 100, 80));
        draw_text_transformed(node_x + tree_node_size / 2, node_y + tree_node_size / 2, "?", 1.2, 1.2, 0);
    }
}

// Reset clipping
gpu_set_scissor(-1, -1, -1, -1);

// Remove scrolling instructions since we don't need them anymore
// draw_set_color(make_color_rgb(200, 180, 140));
// draw_set_halign(fa_left);
// draw_set_valign(fa_bottom);
// draw_text(overlay_x + 20, overlay_y + overlay_height - 20, "Mouse Wheel: Scroll | Shift+Wheel: Horizontal | Middle Click: Pan");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);