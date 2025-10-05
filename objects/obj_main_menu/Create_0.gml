/// Main Menu Controller - Create Event

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Button properties
button_width = 240;
button_height = 50;
button_spacing = 10;

// Calculate center positions
center_x = gui_width / 2;
center_y = gui_height / 2;

// Create button structure
// Row 1: Play (double width and height)
// Row 2: Instructions (left half) | Settings (right half)
// Row 3: Credits (left half) | Exit (right half)
buttons = [
    {
        name: "Play",
        x_offset: 0,
        y_offset: -80,
        width: button_width,
        height: button_height * 2,
        action: function() {
            room_goto(GameSandbox);
        }
    },
    {
        name: "Instructions",
        x_offset: -(button_width / 4 + button_spacing / 2),
        y_offset: 15,
        width: button_width / 2,
        height: button_height,
        action: function() {
            instance_create_depth(0, 0, -1000, obj_instructions_overlay);
        }
    },
    {
        name: "Settings",
        x_offset: (button_width / 4 + button_spacing / 2),
        y_offset: 15,
        width: button_width / 2,
        height: button_height,
        action: function() {
            instance_create_depth(0, 0, -1000, obj_settings_overlay);
        }
    },
    {
        name: "Credits",
        x_offset: -(button_width / 4 + button_spacing / 2),
        y_offset: 75,
        width: button_width / 2,
        height: button_height,
        action: function() {
            instance_create_depth(0, 0, -1000, obj_credits_overlay);
        }
    },
    {
        name: "Exit",
        x_offset: (button_width / 4 + button_spacing / 2),
        y_offset: 75,
        width: button_width / 2,
        height: button_height,
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
