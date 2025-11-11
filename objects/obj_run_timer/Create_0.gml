// Timer in seconds (decimal for precision)
run_time_seconds = variable_global_exists("run_time_seconds_saved") && is_real(global.run_time_seconds_saved)
    ? global.run_time_seconds_saved
    : 0;

// Flag to track if timer is active
is_active = false;

// Make persistent so it survives room changes
persistent = true;

// Position for display (top right, left of pause button)
display_x = 0;
display_y = 0;

// Colors
col_bg = make_color_rgb(40, 30, 25);
col_border = make_color_rgb(150, 120, 90);
col_text = c_white;

// Padding
padding = 6;