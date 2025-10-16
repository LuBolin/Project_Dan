/// Alchemy Controller - Create

// === LAYOUT CONFIG ===
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// === COLORS ===
col_bg = make_color_rgb(30, 30, 40);
col_border = make_color_rgb(60, 60, 80);
col_slot_empty = make_color_rgb(50, 50, 60);
col_slot_filled = make_color_rgb(60, 100, 60);
col_slot_used = make_color_rgb(40, 40, 50);
col_button = make_color_rgb(80, 160, 220);
col_button_hover = make_color_rgb(100, 180, 240);
col_text = c_white;

// === CRAFTING SYSTEM ===
// Load recipes from JSON and build tree (only if not already loaded)
if (!variable_global_exists("recipe_tree")) {
    var json_data = load_recipes_from_json("recipes.json");
    global.recipe_tree = build_recipe_tree_from_json(json_data);
}

// === DRAG & DROP SYSTEM ===
dragging = false;
drag_source_type = "none"; // "equipped", "crafted", "equation"
drag_source_index = -1;
drag_offset_x = 0;
drag_offset_y = 0;

// === EQUIPPED GOURDS (Left side - vertical row) ===
equipped_slot_size = 80;
equipped_slot_spacing = 20;
equipped_x = 100;
equipped_start_y = gui_height / 2 - (3 * equipped_slot_size + 2 * equipped_slot_spacing) / 2;

// Get player's equipped gourds BEFORE deactivating player
if (instance_exists(obj_player)) {
    equipped_gourds = [
        obj_player.inv[0],
        obj_player.inv[1],
        obj_player.inv[2]
    ];
} else {
    // Fallback if player doesn't exist
    equipped_gourds = [
        gourd_create(GourdEarth),
        gourd_create(GourdWater),
        gourd_create(GourdWind)
    ];
}

// Deactivate player to prevent input while in alchemy room (after reading inventory)
if (instance_exists(obj_player)) {
    instance_deactivate_object(obj_player);
}

// === CRAFTING EQUATIONS (Center) ===
num_equations = 2; // CHANGE THIS to adjust number of crafting slots (e.g., 3 for three rows)
equation_slot_size = 70;
equation_spacing = 20; // Space between slots
equation_symbol_spacing = 30; // Space for + and = symbols
equation_x = gui_width / 2;
equation_y = gui_height / 2 - (num_equations * equation_slot_size + (num_equations - 1) * equation_spacing) / 2;

// Create equations array dynamically based on num_equations
equations = [];
for (var i = 0; i < num_equations; i++) {
    equations[i] = {
        input1: noone,
        input2: noone,
        result: noone,
        used: false
    };
}

// === CRAFTED ELEMENTS (temporary storage) ===
// Array of crafted gourd instances that can be used in equations
crafted_elements = [];

// === CONTINUE BUTTON ===
button_w = 150;
button_h = 50;
button_x = gui_width - button_w - 40;
button_y = gui_height - button_h - 40;
button_hover = false;

// === CRAFT FEEDBACK ===
craft_feedback = "none"; // "none", "success", "fail"
craft_feedback_timer = 0;
craft_feedback_duration = 60; // frames
craft_feedback_equation = -1;

// === RECIPE TREE LAYOUT (Right side) ===
tree_panel_x = gui_width - 250; // Further reduced for narrower panel
tree_panel_y = 50;
tree_panel_w = 230; // Further reduced (about 12% smaller than 260)
tree_panel_h = 520; // Reduced from gui_height - 100 to fit content better

// Tree node layout
tree_node_size = 40; // Reduced from 60 to fit narrower panel
tree_node_spacing_x = 50; // Reduced from 80 for tighter horizontal packing
tree_node_spacing_y = 90; // Reduced slightly from 100
tree_start_x = tree_panel_x + tree_panel_w / 2;
tree_start_y = tree_panel_y + 50; // Start at top for Elixir

// Build tree positions dynamically from JSON
tree_positions = {};

// Load JSON again to get display positions (already in memory in global.recipe_tree)
var json_data = load_recipes_from_json("recipes.json");

// The max row for inversion (Elixir is at row 4, which should become y=0)
var max_row = 4;

// Add base elements from display_tiers
var base_tier = json_data.display_tiers.base;
var base_elements = base_tier.elements;
var base_row = base_tier.row_y;

// Center base elements (4 elements evenly spaced)
for (var i = 0; i < array_length(base_elements); i++) {
    var elem = base_elements[i];
    // Center around 0: columns at -1.5, -0.5, 0.5, 1.5
    var column_offset = (i - (array_length(base_elements) - 1) / 2);
    // Invert the row: row 0 becomes row 4, row 4 becomes row 0
    var inverted_row = max_row - base_row;
    tree_positions[$ elem] = {
        x: column_offset * tree_node_spacing_x,
        y: inverted_row * tree_node_spacing_y
    };
}

// Add recipe elements from recipes array
for (var i = 0; i < array_length(json_data.recipes); i++) {
    var recipe = json_data.recipes[i];
    var display_pos = recipe.display_position;
    var row = display_pos.row;
    var col = display_pos.column;

    // Calculate centered position based on row size
    var row_size = 0;
    if (row == 1) row_size = 4;      // Tier 2 has 4 elements
    else if (row == 2) row_size = 4; // Tier 3 has 4 elements
    else if (row == 3) row_size = 2; // Tier 4 has 2 elements
    else if (row == 4) row_size = 1; // Final tier has 1 element

    // Center around 0: for 4 elements -> -1.5, -0.5, 0.5, 1.5
    // for 2 elements -> -0.5, 0.5
    // for 1 element -> 0
    var column_offset = (col - (row_size - 1) / 2);

    // Invert the row: row 0 becomes row 4, row 4 becomes row 0
    var inverted_row = max_row - row;

    tree_positions[$ recipe.result] = {
        x: column_offset * tree_node_spacing_x,
        y: inverted_row * tree_node_spacing_y
    };
}

// Glow animation for Elixir
elixir_glow_timer = 0;
