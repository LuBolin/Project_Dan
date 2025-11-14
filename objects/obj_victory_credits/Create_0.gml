/// Victory Credits - Create

// GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Star Wars style scrolling from bottom to top with perspective
scroll_y = gui_height; // Start at bottom of screen
scroll_speed_normal = 0.8; // Normal slow crawl speed
scroll_speed_fast = 3.0; // Fast speed when holding a key
scroll_speed = scroll_speed_normal; // Current speed

// Credits text lines
credits_lines = [
    "",
    "",
    "",
    "DAN 丹",
    "",
    "",
    "A Game About",
    "Mastering the Elements",
    "and Achieving Immortality",
    "",
    "",
    "",
    "GAME DESIGN",
    "Bolin, Ashley, James",
    "",
    "",
    "ARTWORK",
    "Mariyya, Julia",
    "",
    "",
    "PROGRAMMING",
    "James, Ashley, Bolin",
    "",
    "",
    "QUALITY ASSURANCE",
    "Julia, James",
    "",
    "",
    "",
    "MUSIC",
    "China - Asian China Chinese Music",
    "by Aliaksei Yukhnevich",
    "",
    "",
    "",
    "Assets:",
    "Steam Effect Designed by Freepik", 
    "https://www.freepik.com/free-vector/cartoon-smoke-element-animation-frames_13763535.htm",
    "",
    "",
    "",
    "SPECIAL THANKS",
    "To everyone who played",
    "and supported this game",
    "",
    "",
    "",
    "",
    "May your journey",
    "to immortality",
    "be legendary",
    "",
    "",
    "",
    "",
    "© 2025",
    "",
    "",
    "",
    "",
];

// Calculate total height of credits
line_height = 40;
total_height = array_length(credits_lines) * line_height;

// Colors
col_bg = c_black;
col_text = make_color_rgb(255, 215, 100); // Golden color

// Fade effect for text (top and bottom)
fade_distance = 200;

// Track if credits are complete
credits_complete = false;
