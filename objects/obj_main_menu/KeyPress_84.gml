// TEST: Backdoor to Level 1 with Creation for testing clone behavior
// T key (ASCII 84)
global.level_progress = 1;

// Set up player inventory with Creation + other elements
global.next_room_inv_names = ["Creation", "Clay", "Hurricane"];
global.next_room_sel_slot = 0;

goto_level(Level1, 1);
