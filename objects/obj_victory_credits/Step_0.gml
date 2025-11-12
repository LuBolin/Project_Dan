/// Victory Credits - Step

// Check if any key is being held (for speed up)
var is_holding_key = keyboard_check(vk_anykey) ||
                     keyboard_check(vk_space) ||
                     keyboard_check(vk_enter) ||
                     mouse_check_button(mb_left);

// Set scroll speed based on whether key is held
if (is_holding_key) {
    scroll_speed = scroll_speed_fast;
} else {
    scroll_speed = scroll_speed_normal;
}

// Scroll credits upward
scroll_y -= scroll_speed;

// Check if credits have scrolled completely off screen
if (scroll_y + total_height < 0) {
    credits_complete = true;
}

// If credits complete, go to main menu
if (credits_complete) {
    // Clear input states
    io_clear();

    // Go to main menu
    room_goto(MainMenu);
}

// Allow ESC to skip immediately to main menu
if (keyboard_check_pressed(vk_escape)) {
    // Clear input states
    io_clear();

    // Go to main menu
    room_goto(MainMenu);
}
