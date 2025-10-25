/// Death Screen - Create

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

// Element selection
selected_element_index = -1; // -1 means "Start Fresh" (no element carried over)
element_slot_size = 80;
element_slot_spacing = 20;
element_start_y = panel_y + 120;

// Calculate element positions centered in panel
var total_elements = array_length(player_elements);
var total_width = total_elements * element_slot_size + (total_elements - 1) * element_slot_spacing;
element_start_x = panel_x + (panel_width - total_width) / 2;

// Buttons
button_width = 180;
button_height = 50;
button_spacing = 20;

// "Start New Run" button
start_button_x = panel_x + panel_width / 2 - button_width - button_spacing / 2;
start_button_y = panel_y + panel_height - 100;
start_button_hover = false;

// "Main Menu" button
menu_button_x = panel_x + panel_width / 2 + button_spacing / 2;
menu_button_y = panel_y + panel_height - 100;
menu_button_hover = false;

// "Start Fresh" button (no element carried over)
fresh_button_width = 120;
fresh_button_x = panel_x + (panel_width - fresh_button_width) / 2;
fresh_button_y = element_start_y + element_slot_size + 40;
fresh_button_hover = false;
