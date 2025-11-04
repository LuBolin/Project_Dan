/// Instructions Overlay - Create Event

// Get GUI dimensions
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Overlay properties (80% of screen)
overlay_width = gui_width * 0.8;
overlay_height = gui_height * 0.8;
overlay_x = (gui_width - overlay_width) / 2;
overlay_y = (gui_height - overlay_height) / 2;

// Close button properties
close_button_size = 40;
close_button_x = overlay_x + overlay_width - close_button_size - 10;
close_button_y = overlay_y + 10;
close_button_hovered = false;

// Colors
col_overlay_bg = c_black;
col_panel_bg = make_color_rgb(40, 30, 25);
col_panel_border = make_color_rgb(150, 120, 90);
col_text = c_white;
col_title = make_color_rgb(255, 215, 150);
col_close_normal = make_color_rgb(80, 50, 40);
col_close_hover = make_color_rgb(120, 80, 60);

// Instructions content - organized into sections
overarching_text = @"Venture through dungeons and biomes, surviving waves of enemies.
Discover new elements along the way and synthesize higher tier elements.
Is the Elixir real, or is it just a myth?";

exploration_text = @"WASD - Move your character
Mouse - Aim
Left Click - Activate active element
Q/E or Mouse Wheel - Cycle active element

Defeat enemies to gather their Chi
Unlock the door to access Alchemy Room";

alchemy_text = @"Drag synthesized element and
new element into inventory to equip and
swap with equipped element

Drag elements from your inventory or new
elements into the crafting area to synthesize

You can carry at most 3 elements in
your inventory";
