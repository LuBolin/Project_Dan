// ===== Gourd HUD config =====
ui_x = 100;
ui_y = 144;

// ring geometry
ring_R = 56;     // radius where nodes sit
ring_r = 22;     // inner hole radius (visual only)

// node visuals
node_r        = 10;
node_r_select = 14;

// fixed logical slots: bottom, top-left, top-right
base_angles = [270, 150, 30];

// rotate so the *selected slot* is always at bottom (270°)
angle_offset  = 0;   // current visual offset
rot_speed_deg = 12;  // how fast the ring turns towards target (deg/step)

// colors
col_ring    = make_color_rgb(60,60,60);
col_hole    = make_color_rgb(10,10,10);
col_outline = c_black;
col_text    = c_white;

// gourd icon
spr_gourd_icon = spr_gourd;
node_px = 40; // normal diameter (pixels)
node_px_sel = 64; // selected diameter