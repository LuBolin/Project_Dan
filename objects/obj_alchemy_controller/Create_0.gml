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
equation_slot_size = 70;
equation_spacing = 20; // Space between slots
equation_symbol_spacing = 30; // Space for + and = symbols
equation_x = gui_width / 2;
equation_y = gui_height / 2 - (2 * equation_slot_size + equation_spacing) / 2;

// Each equation: [input1, input2, result, used]
equations = [
    {
        input1: noone,
        input2: noone,
        result: noone,
        used: false
    },
    {
        input1: noone,
        input2: noone,
        result: noone,
        used: false
    }
];

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
