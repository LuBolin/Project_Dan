/// Alchemy Controller - Step

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// === DRAG & DROP SYSTEM ===

// Start dragging
if (mouse_check_button_pressed(mb_left) && !dragging) {
    // Check if clicking on any draggable item
    for (var i = 0; i < array_length(draggable_items); i++) {
        var item = draggable_items[i];

        if (point_in_rectangle(mx, my, item.x, item.y, item.x + item.w, item.y + item.h)) {
            dragging = true;
            drag_item = i;
            drag_offset_x = mx - item.x;
            drag_offset_y = my - item.y;
            break;
        }
    }
}

// Stop dragging
if (mouse_check_button_released(mb_left) && dragging) {
    var item = draggable_items[drag_item];
    var drop_x = mx - drag_offset_x;
    var drop_y = my - drag_offset_y;

    var dropped_in_zone = false;

    // Check if item is already unlocked (not a basic element)
    var is_already_unlocked = false;
    var keys = variable_struct_get_names(global.recipe_tree);
    for (var i = 0; i < array_length(keys); i++) {
        var node = global.recipe_tree[$ keys[i]];
        if (node.name == item.name && node.tier > 0 && node.discovered) {
            is_already_unlocked = true;
            break;
        }
    }

    // Check if dropped in craft zone 1
    if (point_in_rectangle(mx, my, craft_zone_1.x, craft_zone_1.y,
                          craft_zone_1.x + craft_zone_1.w, craft_zone_1.y + craft_zone_1.h)) {
        if (is_already_unlocked) {
            // Reject - show small red cross
            craft_feedback = "already_unlocked";
            craft_feedback_timer = craft_feedback_duration;
        } else {
            craft_zone_1.item = item.name;
            dropped_in_zone = true;
        }
    }

    // Check if dropped in craft zone 2
    if (point_in_rectangle(mx, my, craft_zone_2.x, craft_zone_2.y,
                          craft_zone_2.x + craft_zone_2.w, craft_zone_2.y + craft_zone_2.h)) {
        if (is_already_unlocked) {
            // Reject - show small red cross
            craft_feedback = "already_unlocked";
            craft_feedback_timer = craft_feedback_duration;
        } else {
            craft_zone_2.item = item.name;
            dropped_in_zone = true;
        }
    }

    // If both zones have items, try to craft
    if (craft_zone_1.item != noone && craft_zone_2.item != noone) {
        var result = try_craft(craft_zone_1.item, craft_zone_2.item, global.recipe_tree);

        if (result != noone) {
            // Recipe discovered!
            result.discovered = true;
            craft_feedback = "success";
            craft_feedback_timer = craft_feedback_duration;
        } else {
            // Invalid recipe - reject both items
            craft_feedback = "fail";
            craft_feedback_timer = craft_feedback_duration;
        }

        // Clear craft zones (whether success or failure)
        craft_zone_1.item = noone;
        craft_zone_2.item = noone;
    }

    // If not dropped in zone, return to original position or stay where dropped
    if (!dropped_in_zone && !is_already_unlocked) {
        item.x = drop_x;
        item.y = drop_y;

        // Clamp to main panel bounds
        item.x = clamp(item.x, main_panel_x, main_panel_x + main_panel_w - item.w);
        item.y = clamp(item.y, main_panel_y, main_panel_y + main_panel_h - item.h);
    }

    dragging = false;
    drag_item = noone;
}

// === SCROLLING SYSTEM ===

// Check if mouse is in scroll area
var tree_start_y = side_panel_y + 60;
var tree_end_y = button_y - 20;

if (point_in_rectangle(mx, my, side_panel_x, tree_start_y, side_panel_x + side_panel_w, tree_end_y)) {
    var wheel = mouse_wheel_down() - mouse_wheel_up();
    scroll_offset += wheel * scroll_speed;
    scroll_offset = clamp(scroll_offset, 0, scroll_max);
}

// === CRAFT FEEDBACK TIMER ===
if (craft_feedback_timer > 0) {
    craft_feedback_timer--;
    if (craft_feedback_timer <= 0) {
        craft_feedback = "none";
    }
}

// === CONTINUE BUTTON ===
// Check hover state
button_hover = point_in_rectangle(mx, my, button_x, button_y, button_x + button_w, button_y + button_h);

// Check click
if (button_hover && mouse_check_button_pressed(mb_left)) {
    // Clear mouse button state to prevent click carrying over to next room
    io_clear();
    room_goto(GameSandbox);
}
