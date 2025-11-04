/// Death Screen - Create

if (variable_global_exists("cutscene_complete_flag") && global.cutscene_complete_flag) {
    global.cutscene_complete_flag = false;
}

// GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Colors
col_overlay = c_black;
col_panel_bg = make_color_rgb(20, 20, 30);
col_panel_border = make_color_rgb(100, 100, 120);
col_title = c_red;
col_text = c_white;
col_button = make_color_rgb(60, 60, 80);
col_button_hover = make_color_rgb(80, 100, 120);
col_button_selected = make_color_rgb(100, 140, 180);

// Panel layout
panel_width = 600;
panel_height = 500;
panel_x = (gui_width - panel_width) / 2;
panel_y = (gui_height - panel_height) / 2;

// Store player's inventory (passed from player death)
player_elements = [];
if (variable_global_exists("player_death_inventory")) {
    player_elements = global.player_death_inventory;
}

// Element selection (including "Bring nothing" as 4th option)
selected_element_index = -1; // -1 means nothing selected yet
element_slot_size = 100;
element_slot_spacing = 15;
element_start_y = panel_y + 150;

// Calculate element positions for 4 buttons in a row (3 elements + "Bring nothing")
var total_slots = 4;
var total_width = total_slots * element_slot_size + (total_slots - 1) * element_slot_spacing;
element_start_x = panel_x + (panel_width - total_width) / 2;

// The 4th slot (index 3) is the "Bring nothing" option
bring_nothing_index = 3;

// Buttons
button_width = 180;
button_height = 50;
button_spacing = 20;

// "Start New Run" button (left side, below element slots)
start_button_x = panel_x + panel_width / 2 - button_width - button_spacing / 2;
start_button_y = panel_y + panel_height - 80;
start_button_hover = false;

// "Main Menu" button (right side, same row as Start button)
menu_button_x = panel_x + panel_width / 2 + button_spacing / 2;
menu_button_y = start_button_y;
menu_button_hover = false;
