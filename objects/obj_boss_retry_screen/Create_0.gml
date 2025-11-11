/// Boss Retry Screen - Create

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

// Panel layout
panel_width = 500;
panel_height = 300;
panel_x = (gui_width - panel_width) / 2;
panel_y = (gui_height - panel_height) / 2;

// Store player's inventory (to keep for retry)
player_inventory = [];
player_sel_slot = 0;
if (variable_global_exists("player_death_inventory")) {
    player_inventory = global.player_death_inventory;
}
if (variable_global_exists("player_death_sel_slot")) {
    player_sel_slot = global.player_death_sel_slot;
}

// Buttons
button_width = 180;
button_height = 50;
button_spacing = 20;

// "Retry" button (left side)
retry_button_x = panel_x + panel_width / 2 - button_width - button_spacing / 2;
retry_button_y = panel_y + panel_height - 80;
retry_button_hover = false;

// "Give Up" button (right side)
giveup_button_x = panel_x + panel_width / 2 + button_spacing / 2;
giveup_button_y = retry_button_y;
giveup_button_hover = false;
