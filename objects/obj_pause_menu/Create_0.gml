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

// Menu panel dimensions (80% of screen, consistent with other overlays)
panel_width = gui_width * 0.8;
panel_height = gui_height * 0.8;
panel_x = (gui_width - panel_width) / 2;
panel_y = (gui_height - panel_height) / 2;

// Button properties (smaller than before)
button_width = 180;
button_height = 50;
button_spacing = 20;

// Calculate center positions for buttons
center_x = gui_width / 2;
center_y = gui_height / 2;
button_start_y = panel_y + 150; // Start buttons below title with gap

// Create button structure
buttons = [
    {
        name: "Continue",
        y_offset: 0,
        action: function() {
            other.is_paused = false;
            instance_activate_all();

            // In alchemy room, player should remain deactivated
            if (room == AlchemyRoom && instance_exists(obj_player)) {
                instance_deactivate_object(obj_player);
            }
        }
    },
    {
        name: "Instructions",
        y_offset: 70,
        action: function() {
            // Create instructions overlay
            instance_create_depth(0, 0, -1000, obj_instructions_overlay);
        }
    },
    {
        name: "Settings",
        y_offset: 140,
        action: function() {
            // Create settings overlay
            instance_create_depth(0, 0, -1000, obj_settings_overlay);
        }
    },
    {
        name: "Quit to Menu",
        y_offset: 210,
        action: function() {
            instance_activate_all();
            other.is_paused = false;

            // Reset run timer
            if (instance_exists(obj_run_timer)) {
                obj_run_timer.run_time_seconds = 0;
                obj_run_timer.is_active = false;
            }

            // Destroy player and related objects before returning to menu
            if (instance_exists(obj_player)) {
                instance_destroy(obj_player);
            }
            if (instance_exists(obj_aim_arrow)) {
                instance_destroy(obj_aim_arrow);
            }
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
