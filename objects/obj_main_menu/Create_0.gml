/// Main Menu Controller - Create Event

// Play BGM for main menu (looping) at 50% volume
if (!audio_is_playing(snd_dungeon_bgm)) {
    var bgm_instance = audio_play_sound(snd_dungeon_bgm, 1, true);
    audio_sound_gain(bgm_instance, 0.5, 0); // Set volume to 50%
}

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
// Row 3: Recipes (left half) | Credits (middle) | Exit (right)
buttons = [
    {
        name: "Play",
        x_offset: 0,
        y_offset: -80,
        width: button_width + button_spacing,
        height: button_height * 2,
        action: function() {
            // Reset level progress
            global.level_progress = 1;
            //goto_level(Level0, 1); // Start at Level0 with difficulty level 1
			goto_level(MiniBoss_Tree, 5);
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
        name: "Recipes",
        x_offset: -((button_width - button_spacing) / 3 + button_spacing),
        y_offset: 75,
        width: (button_width - button_spacing) / 3,
        height: button_height,
        action: function() {
            instance_create_depth(0, 0, -1000, obj_recipes_overlay);
        }
    },
    {
        name: "Credits",
        x_offset: 0,
        y_offset: 75,
        width: (button_width - button_spacing) / 3,
        height: button_height,
        action: function() {
            instance_create_depth(0, 0, -1000, obj_credits_overlay);
        }
    },
    {
        name: "Exit",
        x_offset: ((button_width - button_spacing) / 3 + button_spacing),
        y_offset: 75,
        width: (button_width - button_spacing) / 3,
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

// Check if this is the first launch (splash screen only on first launch)
if (!variable_global_exists("game_launched")) {
    global.game_launched = false;
}

// Title position animation
title_y_target = gui_height * 0.2; // Final position (top)
title_y_center = gui_height * 0.5; // Center position for splash

// Determine if this is first launch or re-entrance
var is_first_launch = !global.game_launched;

// Always show splash animation
show_buttons = false;

// Fade effect for title
title_alpha = 0;
title_fade_speed = 0.01;

// Title starts at center during splash
title_y_current = title_y_center;

// Button fade-in effect
buttons_alpha = 0;

if (is_first_launch) {
    // First launch: Show "Press Space" prompt, wait for user input
    global.game_launched = true; // Mark as launched

    // Fade effect for prompt (slower fade)
    prompt_alpha = 0;
    prompt_fade_direction = 1; // 1 = fading in, -1 = fading out
    prompt_fade_speed = 0.005;

    // Animation state
    transitioning = false; // Will be true when space is pressed
    auto_transition = false; // Manual transition
    auto_transition_delay = 0;
    
    randomize()
} else {
    // Re-entrance: No prompt, immediate auto-transition
    prompt_alpha = 0; // Don't show prompt

    // Animation state
    transitioning = true; // Start immediately
    auto_transition = true; // Auto transition enabled
    auto_transition_delay = 0; // No delay
}
