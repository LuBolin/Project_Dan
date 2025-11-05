// Backdoor to final boss with Creation, Clay, and Lightning
global.level_progress = 5;

// Set up player inventory with the three elements using the existing inventory override system
global.next_room_inv_names = ["Creation", "Clay", "Lightning"];
global.next_room_sel_slot = 0;

goto_level(Level_FinalBoss, 5);
