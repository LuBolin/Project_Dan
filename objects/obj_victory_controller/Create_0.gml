/// Victory Controller - Create

// Victory sequence states
enum VICTORY_STATE {
    KILL_ENEMIES,      // Kill all remaining enemies
    PLAYER_ASCEND,     // Player ascends with animation
    NARRATION,         // Show victory narration
    WAITING_INPUT      // Wait for player to continue
}

state = VICTORY_STATE.KILL_ENEMIES;
state_timer = 0;

// GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Colors
col_overlay = c_black;
col_panel_bg = make_color_rgb(20, 20, 30);
col_panel_border = make_color_rgb(180, 150, 100); // Golden color for victory
col_title = make_color_rgb(255, 215, 0); // Gold
col_text = c_white;
col_button = make_color_rgb(60, 60, 80);
col_button_hover = make_color_rgb(100, 140, 180);

// Panel layout
panel_width = 700;
panel_height = 400;
panel_x = (gui_width - panel_width) / 2;
panel_y = (gui_height - panel_height) / 2;

// Button
button_width = 200;
button_height = 50;
button_x = panel_x + (panel_width - button_width) / 2;
button_y = panel_y + panel_height - 80;
button_hover = false;

// Narration text
narration_lines = [
    "With mastery over the elemental forces,",
    "you transcend mortal limitations.",
    "",
    "Your legend will echo through eternity.",
    "",
    "You have achieved IMMORTALITY."
];

// Player reference
player = noone;
if (instance_exists(obj_player)) {
    player = obj_player;
}

// Stop the run timer when victory sequence starts
if (instance_exists(obj_run_timer)) {
    obj_run_timer.is_active = false;
}

// Animation control
player_original_sprite = noone;
player_original_blend = c_white;
ascend_animation_complete = false;

// Camera control
camera_original_preferred_ratio = 0.15;
camera_original_smooth = 0.12;
camera_zoom_target = 0.25; // Zoom in for ascension (higher ratio = more zoomed in)
