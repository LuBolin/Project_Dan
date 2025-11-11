/// Boss Retry Screen - Draw GUI

// Helper function to draw text with black outline
function draw_text_outlined(_x, _y, _text) {
    // Draw black outline
    draw_set_color(c_black);
    for (var ox = -1; ox <= 1; ox++) {
        for (var oy = -1; oy <= 1; oy++) {
            if (ox != 0 || oy != 0) {
                draw_text(_x + ox, _y + oy, _text);
            }
        }
    }
    // Draw white text on top
    draw_set_color(c_white);
    draw_text(_x, _y, _text);
}

// Draw semi-transparent overlay
draw_set_alpha(0.8);
draw_set_color(col_overlay);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Draw panel background
draw_set_color(col_panel_bg);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);

// Draw panel border
draw_set_color(col_panel_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);

// Draw title "YOU DIED"
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(col_title);
draw_text_transformed(panel_x + panel_width / 2, panel_y + 30, "YOU DIED", 2, 2, 0);

// Draw instruction text
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var instruction_y = panel_y + 100;
draw_text(panel_x + panel_width / 2, instruction_y, "Do you want to re-attempt the final boss?");

// Draw current inventory info
var inventory_y = instruction_y + 40;
draw_set_color(make_color_rgb(180, 180, 200));
var inv_text = "Current inventory: ";
for (var i = 0; i < array_length(player_inventory); i++) {
    if (i > 0) inv_text += ", ";
    inv_text += player_inventory[i].name;
}
draw_text(panel_x + panel_width / 2, inventory_y, inv_text);

// Draw "Retry" button
var retry_col = retry_button_hover ? col_button_hover : col_button;
draw_set_color(retry_col);
draw_rectangle(retry_button_x, retry_button_y, retry_button_x + button_width, retry_button_y + button_height, false);
draw_set_color(col_panel_border);
draw_rectangle(retry_button_x, retry_button_y, retry_button_x + button_width, retry_button_y + button_height, true);

draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(retry_button_x + button_width / 2, retry_button_y + button_height / 2, "Retry");

// Draw "Give Up" button
var giveup_col = giveup_button_hover ? col_button_hover : col_button;
draw_set_color(giveup_col);
draw_rectangle(giveup_button_x, giveup_button_y, giveup_button_x + button_width, giveup_button_y + button_height, false);
draw_set_color(col_panel_border);
draw_rectangle(giveup_button_x, giveup_button_y, giveup_button_x + button_width, giveup_button_y + button_height, true);

draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(giveup_button_x + button_width / 2, giveup_button_y + button_height / 2, "Give Up");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
