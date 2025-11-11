/// Alchemy Controller - Create

// Play BGM for alchemy room (looping) at 50% volume
if (!audio_is_playing(snd_dungeon_bgm)) {
    var bgm_instance = audio_play_sound(snd_dungeon_bgm, 1, true);
    audio_sound_gain(bgm_instance, 0.5, 0); // Set volume to 50%
}

// Backdrop animation + darken settings
backdrop_frame = 0;                                  // fractional frame index
backdrop_fps = 5;                                    // play at 5 FPS (slow, calming animation)
backdrop_frame_step = backdrop_fps / game_get_speed(gamespeed_fps);
backdrop_frame_direction = 1;                        // 1 = forward, -1 = backward (for ping-pong)
backdrop_darken_alpha = 0.7;  

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
col_title = make_color_rgb(255, 215, 150);

// === HELPER FUNCTION: Get gourd constructor by name ===
function get_gourd_constructor_by_name(name) {
    switch(name) {
        case "Fire": return gourd_create(GourdFire);
        case "Earth": return gourd_create(GourdEarth);
        case "Water": return gourd_create(GourdWater);
        case "Air": return gourd_create(GourdAir);
        case "Mud": return gourd_create(GourdMud);
        case "Lava": return gourd_create(GourdLava);
        case "Steam": return gourd_create(GourdSteam);
        case "Current": return gourd_create(GourdCurrent);
        case "Eruption": return gourd_create(GourdEruption);
        case "Hurricane": return gourd_create(GourdHurricane);
        case "Clay": return gourd_create(GourdClay);
        case "Plant": return gourd_create(GourdPlant);
        case "Destruction": return gourd_create(GourdDestruction);
        case "Creation": return gourd_create(GourdCreation);
        case "Elixir": return gourd_create(GourdElixir);
        default: return noone;
    }
}


// === CRAFTING SYSTEM ===
// Force rebuild recipe tree to ensure all nodes have the 'crafted' property
var json_data = load_recipes_from_json("recipes.json");

if (!variable_global_exists("recipe_tree")) {
    global.recipe_tree = build_recipe_tree_from_json(json_data);
} else {
    // Ensure all existing nodes have the 'crafted' property
    var keys = variable_struct_get_names(global.recipe_tree);
    for (var i = 0; i < array_length(keys); i++) {
        var node = global.recipe_tree[$ keys[i]];
        if (!variable_struct_exists(node, "crafted")) {
            node.crafted = false; // Default to false for existing nodes
        }
    }
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
equipped_x = 80;
equipped_start_y = gui_height / 2 - (3 * equipped_slot_size + 2 * equipped_slot_spacing) / 2;
upwards_offset = gui_height / 10; // Move the whole equipped section up a bit
equipped_start_y -= upwards_offset;

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

// === CONFIRMATION POPUP ===
show_confirmation_popup = false;
popup_width = 500;
popup_height = 300;
popup_x = (gui_width - popup_width) / 2;
popup_y = (gui_height - popup_height) / 2;

// Popup buttons
popup_button_width = 120;
popup_button_height = 40;
popup_button_spacing = 20;

// Calculate button positions centered in popup
popup_buttons_total_width = (popup_button_width * 2) + popup_button_spacing;
popup_buttons_start_x = popup_x + (popup_width - popup_buttons_total_width) / 2;
popup_buttons_y = popup_y + popup_height - 70;

// OK button (left)
popup_ok_x = popup_buttons_start_x;
popup_ok_y = popup_buttons_y;
popup_ok_hover = false;

// Cancel button (right)
popup_cancel_x = popup_buttons_start_x + popup_button_width + popup_button_spacing;
popup_cancel_y = popup_buttons_y;
popup_cancel_hover = false;

// === CRAFT FEEDBACK ===
craft_feedback = "none"; // "none", "success", "fail"
craft_feedback_timer = 0;
craft_feedback_duration = 60; // frames
craft_feedback_equation = -1;

// === RECIPE TREE LAYOUT (Right side) ===
tree_panel_x = gui_width - 250; // Further reduced for narrower panel
tree_panel_y = 80; // Moved down from 50 to avoid overlap with pause button
tree_panel_w = 200; // Reduced width from 230
tree_panel_h = 480; // Reduced height from 520

fade_alpha = 0;        // start invisible
fade_in_speed = 0.05;  // adjust how fast it fades in
recently_crafted = global.has_crafted_before;

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

// Get new element for player
new_ele_separator_y = tree_panel_y + tree_panel_h

var level = global.level_progress;
var tier_elements;

switch (level) {
    case 2:
    case 3:    
        tier_elements = json_data.display_tiers.tier1.elements;
    break;
    case 4:
    case 5:    
        tier_elements = json_data.display_tiers.tier2.elements;
    break;
    case 1:
    default:    
        tier_elements = json_data.display_tiers.base.elements;
        global.prev_received_elements = []
    break;
}

var rand_i;
var arr_len = array_length(tier_elements);
new_element = gourd_create(GourdEarth);


// Filter out elements that are already equipped
var available_elements = [];
for (var t = 0; t < array_length(tier_elements); t++) {
    var tier_element = tier_elements[t];
    var is_equipped = false;
    
    if (array_contains(global.prev_received_elements, tier_element)) {
        continue;    
    }
    
    // Check if this element is already equipped
    is_equipped = check_if_gourdname_equipped(equipped_gourds, tier_element);
    
    // Only add to available list if not equipped
    if (!is_equipped) {
        array_push(available_elements, tier_element);
    }
}
show_debug_message(available_elements)

// Helper function to check if an element can create valid crafts with equipped elements
function can_create_valid_craft(_element_name, _equipped_gourds) {
    // Check all 3 combinations of new element + each equipped element
    for (var i = 0; i < array_length(_equipped_gourds); i++) {
        var equipped_name = _equipped_gourds[i].name;
        var recipe = find_recipe_by_ingredients(global.recipe_tree, _element_name, equipped_name);
        if (recipe != noone) {
            return true; // Found at least one valid craft
        }
    }
    return false; // No valid crafts found
}

// Pick random element from available (non-equipped) elements
if (array_length(available_elements) > 0) {
    var selected_element_name = "";
    var max_attempts = 10; // Prevent infinite loop
    var attempt = 0;
    var found_element = false;

    show_debug_message("=== ELEMENT SELECTION START ===");
    show_debug_message("Available elements pool: " + string(available_elements));
    show_debug_message("Equipped elements: [" + equipped_gourds[0].name + ", " + equipped_gourds[1].name + ", " + equipped_gourds[2].name + "]");

    // Step 1: Filter available_elements to only those that can craft with equipped elements
    var craftable_elements = [];
    for (var i = 0; i < array_length(available_elements); i++) {
        var elem_name = available_elements[i];
        if (can_create_valid_craft(elem_name, equipped_gourds)) {
            array_push(craftable_elements, elem_name);
        }
    }

    show_debug_message("Craftable elements (can make recipes with equipped): " + string(craftable_elements));

    // Step 2: Pick element based on whether we have craftable options
    if (array_length(craftable_elements) > 0) {
        // We have elements that can craft - pick randomly from craftable elements
        var random_index = irandom(array_length(craftable_elements) - 1);
        selected_element_name = craftable_elements[random_index];
        show_debug_message(">>> SELECTED FROM CRAFTABLE: " + selected_element_name + " <<<");
    } else {
        // No craftable elements available - pick randomly from all available
        var random_index = irandom(array_length(available_elements) - 1);
        selected_element_name = available_elements[random_index];
        show_debug_message(">>> NO CRAFTABLE ELEMENTS - SELECTED RANDOM: " + selected_element_name + " <<<");
    }

    show_debug_message("=== FINAL ELEMENT: " + selected_element_name + " ===");

    new_element = get_gourd_constructor_by_name(selected_element_name);
    array_push(global.prev_received_elements, new_element.name);

    // Find recipe ID for this element
    var recipe_id = undefined;
    for (var i = 0; i < array_length(json_data.recipes); i++) {
        if (json_data.recipes[i].result == selected_element_name) {
            recipe_id = json_data.recipes[i].id;
            break;
        }
    }
    
    // Mark as discovered using recipe ID (keep crafted status if already crafted)
    if (recipe_id != undefined) {
        var recipe_node = global.recipe_tree[$ recipe_id];
        if (!is_undefined(recipe_node) && recipe_node != noone) {
            recipe_node.discovered = true;
            // Only set crafted to false if it wasn't already true (preserve previously crafted recipes)
            if (!recipe_node.crafted) {
                recipe_node.crafted = false;
            }
        }
    }
} else {
    // All elements of this tier are equipped, pick any random one
    if (array_length(tier_elements) > 0) {
        var random_index = irandom(array_length(tier_elements) - 1);
        new_element = get_gourd_constructor_by_name(tier_elements[random_index]);
        array_push(global.prev_received_elements, new_element.name);
        
        // Find recipe ID for this element
        var recipe_id = undefined;
        for (var i = 0; i < array_length(json_data.recipes); i++) {
            if (json_data.recipes[i].result == tier_elements[random_index]) {
                recipe_id = json_data.recipes[i].id;
                break;
            }
        }
        
        // Mark as discovered using recipe ID (keep crafted status if already crafted)
        if (recipe_id != undefined) {
            var recipe_node = global.recipe_tree[$ recipe_id];
            if (!is_undefined(recipe_node) && recipe_node != noone) {
                recipe_node.discovered = true;
                // Only set crafted to false if it wasn't already true (preserve previously crafted recipes)
                if (!recipe_node.crafted) {
                    recipe_node.crafted = false;
                }
            }
        }
    }
}

show_debug_message("Final new_element: " + (is_struct(new_element) ? new_element.name : "undefined"));

// Glow animation for Elixir
elixir_glow_timer = 0;

// ===== Pause button config =====
pause_button_width = 120;
pause_button_height = 40;
pause_button_x = gui_width - pause_button_width - 16;
pause_button_y = 16;
pause_button_hovered = false;
pause_button_text = "Esc: Pause";

// ===== Tooltip config =====
tooltip_hovered_element = noone;
tooltip_x = 0;
tooltip_y = 0;
tooltip_width = 250;
tooltip_padding = 10;
col_tooltip_bg = make_color_rgb(30, 25, 20);
col_tooltip_border = make_color_rgb(150, 120, 90);
col_tooltip_text = c_white;


tips_array = [
    "Tip: Drag elements to move them! Inventory -> Alchemy. Alchemy -> Inventory",
    "Tip: Elements at the same tree height mix well!",
    "Tip: Must keep synthesizing until I reach the top",
    "Fact: Until I get that Elixir, my quest will never end.",
    "Tip: Elixir. Elixir. Elixir.",
    "Fact: Death cannot stop me. I will get the Elixir.",
    "Tip: Successful synthesis tends to only occur for Elements at the same tree height"
]

current_tip = tips_array[0];

if (recently_crafted) {
    current_tip = tips_array[irandom_range(1, array_length(tips_array) -1)]
}