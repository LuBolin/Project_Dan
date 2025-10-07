/// Alchemy Controller - Create

// === LAYOUT CONFIG ===
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Main panel (left 75%)
main_panel_x = 0;
main_panel_y = 0;
main_panel_w = gui_width * 0.75;
main_panel_h = gui_height;

// Side panel (right 25%)
side_panel_x = main_panel_w;
side_panel_y = 0;
side_panel_w = gui_width * 0.25;
side_panel_h = gui_height;

// === COLORS ===
col_main_bg = make_color_rgb(30, 30, 40);
col_side_bg = make_color_rgb(20, 20, 30);
col_border = make_color_rgb(60, 60, 80);
col_button = make_color_rgb(80, 160, 220);
col_button_hover = make_color_rgb(100, 180, 240);
col_text = c_white;

// === CRAFTING SYSTEM ===
// Load recipes from JSON and build tree
var json_data = load_recipes_from_json("recipes.json");
global.recipe_tree = build_recipe_tree_from_json(json_data);

// === DRAG & DROP SYSTEM ===
dragging = false;
drag_item = noone;
drag_offset_x = 0;
drag_offset_y = 0;

// Draggable basic elements
draggable_items = [
    { name: "Water", x: 50, y: 100, w: 80, h: 80, color: c_blue },
    { name: "Earth", x: 150, y: 100, w: 80, h: 80, color: make_color_rgb(139, 69, 19) },
    { name: "Wind", x: 250, y: 100, w: 80, h: 80, color: c_ltgray },
];

// Crafting zones
craft_zone_1 = { x: 400, y: 200, w: 100, h: 100, item: noone };
craft_zone_2 = { x: 550, y: 200, w: 100, h: 100, item: noone };

// === SCROLLABLE TREE ===
scroll_offset = 0;
scroll_max = 0;
scroll_speed = 20;

// === CONTINUE BUTTON ===
button_w = 120;
button_h = 40;
button_x = side_panel_x + side_panel_w - button_w - 20;
button_y = gui_height - button_h - 20;
button_hover = false;

// === CRAFT FEEDBACK ===
craft_feedback = "none"; // "none", "success", "fail", "already_unlocked"
craft_feedback_timer = 0;
craft_feedback_duration = 60; // frames
