/// Main Menu Controller - Create Event

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Button properties
button_width = 200;
button_height = 60;
button_spacing = 20;

// Calculate center positions
center_x = gui_width / 2;
center_y = gui_height / 2;

// Create button structure
buttons = [
    {
        name: "Play",
        y_offset: -80,
        action: function() {
            room_goto(GameSandbox);
        }
    },
    {
        name: "Instructions",
        y_offset: 0,
        action: function() {
            // TODO: Add instructions screen
            show_debug_message("Instructions clicked");
        }
    },
    {
        name: "Exit",
        y_offset: 80,
        action: function() {
            game_end();
        }
    }
];

// Button colors
col_button_normal = make_color_rgb(60, 40, 30);
col_button_hover = make_color_rgb(100, 70, 50);
col_button_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);

// Hover state
hovered_button = -1;
