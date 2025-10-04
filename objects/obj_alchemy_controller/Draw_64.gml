/// Alchemy Controller - Draw GUI

// === DRAW MAIN PANEL (75% LEFT) ===
draw_set_color(col_main_bg);
draw_rectangle(main_panel_x, main_panel_y, main_panel_x + main_panel_w, main_panel_y + main_panel_h, false);

// Main panel border
draw_set_color(col_border);
draw_rectangle(main_panel_x, main_panel_y, main_panel_x + main_panel_w, main_panel_y + main_panel_h, true);

// Main panel title
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(main_panel_x + 20, main_panel_y + 20, "Alchemy Workshop");

// === DRAW DRAGGABLE ITEMS ===
for (var i = 0; i < array_length(draggable_items); i++) {
    var item = draggable_items[i];

    // Skip if this item is being dragged (we'll draw it on top later)
    if (dragging && drag_item == i) continue;

    // Draw item box
    draw_set_color(item.color);
    draw_rectangle(item.x, item.y, item.x + item.w, item.y + item.h, false);

    // Draw item border
    draw_set_color(col_border);
    draw_rectangle(item.x, item.y, item.x + item.w, item.y + item.h, true);

    // Draw item name
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(item.x + item.w/2, item.y + item.h/2, item.name);
}

// Draw dragged item on top
if (dragging && drag_item != noone) {
    var item = draggable_items[drag_item];
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var draw_x = mx - drag_offset_x;
    var draw_y = my - drag_offset_y;

    // Semi-transparent while dragging
    draw_set_alpha(0.7);
    draw_set_color(item.color);
    draw_rectangle(draw_x, draw_y, draw_x + item.w, draw_y + item.h, false);

    draw_set_color(col_border);
    draw_rectangle(draw_x, draw_y, draw_x + item.w, draw_y + item.h, true);

    draw_set_alpha(1);
    draw_set_color(col_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(draw_x + item.w/2, draw_y + item.h/2, item.name);
}

draw_set_alpha(1);

// === DRAW SIDE PANEL (25% RIGHT) ===
// Draw side panel but leave space for button at bottom
draw_set_color(col_side_bg);
draw_rectangle(side_panel_x, side_panel_y, side_panel_x + side_panel_w, button_y - 10, false);

// Side panel border - also stop before button area
draw_set_color(col_border);
draw_rectangle(side_panel_x, side_panel_y, side_panel_x + side_panel_w, button_y - 10, true);

// Side panel title
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(side_panel_x + 10, side_panel_y + 20, "Recipes");

// === DRAW SCROLLABLE RECIPE TREE ===
var tree_start_y = side_panel_y + 60;
var tree_end_y = button_y - 20;
var tree_height = tree_end_y - tree_start_y;
var line_height = 35;

// Get all discovered recipes
var discovered = get_discovered_recipes(global.recipe_tree);

// Enable scissor (clipping) for scroll area
var clip_x = side_panel_x + 5;
var clip_y = tree_start_y;
var clip_w = side_panel_w - 10;
var clip_h = tree_height;

// Calculate total content height
var total_content_height = array_length(discovered) * line_height;
scroll_max = max(0, total_content_height - tree_height);

gpu_set_scissor(clip_x, clip_y, clip_w, clip_h);

// Draw discovered recipes
draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

for (var i = 0; i < array_length(discovered); i++) {
    var recipe = discovered[i];
    var item_y = tree_start_y + (i * line_height) - scroll_offset;

    // Only draw if visible in scroll area
    if (item_y + line_height >= tree_start_y && item_y <= tree_end_y) {
        // Draw recipe name
        draw_set_color(recipe.tier == 0 ? c_yellow : c_white);
        draw_text(side_panel_x + 15, item_y, recipe.name);

        // Draw ingredients if not basic element
        if (recipe.tier > 0) {
            draw_set_color(c_gray);
            var ingredients_text = recipe.ingredients[0] + " + " + recipe.ingredients[1];
            draw_text(side_panel_x + 20, item_y + 15, ingredients_text);
        }
    }
}

// Disable scissor - reset to full screen
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// Draw scrollbar if needed
if (scroll_max > 0) {
    var scrollbar_x = side_panel_x + side_panel_w - 15;
    var scrollbar_h = tree_height * (tree_height / total_content_height);
    var scrollbar_y = tree_start_y + (scroll_offset / scroll_max) * (tree_height - scrollbar_h);

    draw_set_color(col_border);
    draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + 8, scrollbar_y + scrollbar_h, false);
}



// === DRAW CONTINUE BUTTON - LAST SO IT'S ON TOP ===

// Draw button background
draw_set_color(button_hover ? col_button_hover : col_button);
draw_rectangle(button_x, button_y, button_x + button_w, button_y + button_h, false);

// Draw button border
draw_set_color(col_border);
draw_rectangle(button_x, button_y, button_x + button_w, button_y + button_h, true);

// Draw button text (no transformation to avoid pixelation)
draw_set_color(col_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(button_x + button_w/2, button_y + button_h/2, "Continue");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
