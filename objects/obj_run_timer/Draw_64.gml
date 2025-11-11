// Don't draw in main menu
if (room == MainMenu) exit;

var gui_w = display_get_gui_width();

// Format time as MM:SS.DD (minutes, seconds with 2 decimals)
var minutes = floor(run_time_seconds / 60);
var seconds = run_time_seconds mod 60;

// Format with proper padding: MM (2 digits) : SS.DD (2 digits + 2 decimals)
var minutes_str = string_format(minutes, 2, 0);  // 2 digits, no decimals
var seconds_str = string_format(seconds, 2, 2);  // 2 digits before decimal, 2 after

// Replace spaces with zeros for cleaner display
minutes_str = string_replace_all(minutes_str, " ", "0");
seconds_str = string_replace_all(seconds_str, " ", "0");

var time_string = minutes_str + ":" + seconds_str;

// Use smaller font scale for timer
var font_scale = 0.85;

// Calculate position (left of pause button)
// Get base text dimensions then scale them
var base_text_w = string_width(time_string);
var base_text_h = string_height(time_string);
var text_w = base_text_w * font_scale;
var text_h = base_text_h * font_scale;
var box_w = text_w + padding * 2;
var box_h = text_h + padding * 2;

// Position: top-right, with gap before pause button
// Align top edge with pause button (Y=16)
var pause_button_left = gui_w - 120 - 16; // Pause button is 120px wide + 16px margin
display_x = pause_button_left - box_w - 10; // 10px gap between timer and pause button
display_y = 16; // Same Y as pause button (top edge aligned)

// Draw background
draw_set_alpha(0.8);
draw_set_color(col_bg);
draw_rectangle(display_x, display_y, display_x + box_w, display_y + box_h, false);

// Draw border
draw_set_alpha(1);
draw_set_color(col_border);
draw_rectangle(display_x, display_y, display_x + box_w, display_y + box_h, true);

// Draw time text with reduced font size
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(display_x + box_w / 2, display_y + box_h / 2, time_string, font_scale, font_scale, 0);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);