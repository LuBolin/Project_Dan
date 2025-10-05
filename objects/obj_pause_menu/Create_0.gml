/// Pause Menu Controller - Create Event

// Destroy duplicate instances (only one pause menu should exist)
if (instance_number(obj_pause_menu) > 1) {
    instance_destroy();
    exit;
}

// Pause state
is_paused = false;

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Menu panel dimensions
panel_width = 600;
panel_height = 500;
panel_x = (gui_width - panel_width) / 2;
panel_y = (gui_height - panel_height) / 2;

// Button properties
button_width = 200;
button_height = 60;
button_spacing = 20;

// Calculate center positions for buttons
center_x = gui_width / 2;
button_start_y = panel_y + panel_height - 150;

// Create button structure
buttons = [
    {
        name: "Continue",
        y_offset: 0,
        action: function() {
            other.is_paused = false;
            instance_activate_all();
        }
    },
    {
        name: "Quit to Menu",
        y_offset: 80,
        action: function() {
            instance_activate_all();
            other.is_paused = false;
            room_goto(MainMenu);
        }
    }
];

// Colors
col_overlay = c_black;
col_panel_bg = make_color_rgb(40, 30, 25);
col_panel_border = make_color_rgb(150, 120, 90);
col_button_normal = make_color_rgb(60, 40, 30);
col_button_hover = make_color_rgb(100, 70, 50);
col_button_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);

// Hover state
hovered_button = -1;

// Instructions text (placeholder, can be changed per room)
instructions_text = "Use arrow keys or WASD to move.\nClick to attack.\nPress ESC to pause.";
