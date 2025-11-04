// Initialize recipe tree if not already loaded
if (!variable_global_exists("recipe_tree")) {
    var json_data = load_recipes_from_json("recipes.json");
    global.recipe_tree = build_recipe_tree_from_json(json_data);
}

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Overlay properties (90% of screen for bigger view)
overlay_width = gui_width * 0.9;
overlay_height = gui_height * 0.9;
overlay_x = (gui_width - overlay_width) / 2;
overlay_y = (gui_height - overlay_height) / 2;

// Close button properties
close_button_size = 40;
close_button_x = overlay_x + overlay_width - close_button_size - 10;
close_button_y = overlay_y + 10;
close_button_hovered = false;

// Colors (matching other overlays)
col_overlay_bg = c_black;
col_panel_bg = make_color_rgb(40, 30, 25);
col_panel_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);
col_close_normal = make_color_rgb(80, 50, 40);
col_close_hover = make_color_rgb(120, 80, 60);

// Tree layout (sized to fit everything on screen)
tree_panel_x = overlay_x + 40;
tree_panel_y = overlay_y + 80;
tree_panel_w = overlay_width - 80;
tree_panel_h = overlay_height - 120;

// Tree node layout (fit all elements without scrolling)
tree_node_size = 65;
tree_node_spacing_x = 90;
tree_node_spacing_y = 100;

tree_start_x = tree_panel_x + tree_panel_w / 2;
tree_start_y = tree_panel_y + 60;

// Build tree positions (same logic as alchemy controller but with bigger spacing)
tree_positions = {};

// Load JSON to get display positions
var json_data = load_recipes_from_json("recipes.json");
var max_row = 4;

// Add base elements
var base_tier = json_data.display_tiers.base;
var base_elements = base_tier.elements;
var base_row = base_tier.row_y;

for (var i = 0; i < array_length(base_elements); i++) {
    var elem = base_elements[i];
    var column_offset = (i - (array_length(base_elements) - 1) / 2);
    var inverted_row = max_row - base_row;
    tree_positions[$ elem] = {
        x: column_offset * tree_node_spacing_x,
        y: inverted_row * tree_node_spacing_y
    };
}

// Add recipe elements
for (var i = 0; i < array_length(json_data.recipes); i++) {
    var recipe = json_data.recipes[i];
    var display_pos = recipe.display_position;
    var row = display_pos.row;
    var col = display_pos.column;

    // Calculate row sizes and positions
    var row_size = 0;
    if (row == 1) row_size = 4;
    else if (row == 2) row_size = 4;
    else if (row == 3) row_size = 2;
    else if (row == 4) row_size = 1;

    var column_offset = (col - (row_size - 1) / 2);
    var inverted_row = max_row - row;

    tree_positions[$ recipe.result] = {
        x: column_offset * tree_node_spacing_x,
        y: inverted_row * tree_node_spacing_y
    };
}

// Remove scrolling variables (shouldn't be needed)
// scroll_x = 0;
// scroll_y = 0;
// scroll_speed = 30;
// panning = false;
// pan_start_x = 0;
// pan_start_y = 0;