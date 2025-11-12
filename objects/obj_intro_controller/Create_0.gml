// GUI dims
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Skip if intro already shown this launch (optional)
if (variable_global_exists("intro_shown") && global.intro_shown) {
    room_goto(MainMenu);
    exit;
}

// Sprites to show
spr_idle = spr_intro_idle;
spr_anim = spr_intro_anim;

// Animation speeds
idle_fps = 6;                      // loop idle ~6 FPS
idle_speed = idle_fps / game_get_speed(gamespeed_fps);

// Typewriter settings
type_chars_per_sec = 30;           // typing speed
type_chars_per_step = type_chars_per_sec / game_get_speed(gamespeed_fps);
visible_chars_fp = 0;
visible_chars = 0;
post_text_hold_seconds = 2.5;      // hold after finished typing
post_text_hold_timer = 0;

// Timing (tweak as needed)
narration_seconds = 4.5;           // time to read the one-line narration
fade_seconds = 1.0;                // fade-to-black time
anim_speed = 0.25;                 // frame advance per step in anim phase

// State machine
enum INTRO_STATE { SHOW_TEXT, PLAY_ANIM, FADE_OUT, DONE }
state = INTRO_STATE.SHOW_TEXT;
timer = 0;
fade_alpha = 0;

// Animated sprite state
current_sprite = spr_idle;
image_index = 0;
image_speed = idle_speed;

// Colors (match miniboss cutscene style)
col_dialog_bg = make_color_rgb(20, 20, 30);
col_dialog_border = make_color_rgb(150, 120, 90);
col_name_plate_bg = make_color_rgb(40, 30, 25);
col_text = c_white;

// Narration (single line)
narration_text = "The young taoist prepares to go on his journey to master elements and find the Eternal Elixir.";

// Mark shown at end to avoid re-showing when returning to menu later
will_mark_intro_shown = true;