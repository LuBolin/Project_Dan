// TEST: Backdoor to Level 1 with elements for testing 70% validation
// T key (ASCII 84)
global.level_progress = 1;

// Set up player inventory with Water + Clay + Hurricane
// Water is tier 0, Clay and Hurricane are tier 2
// This tests if system can find tier 1 elements that craft with Water
// (e.g., Steam = Fire + Water, Mud = Earth + Water, Current = Water + Air)
global.next_room_inv_names = ["Air", "Clay", "Eruption"];
global.next_room_sel_slot = 0;

goto_level(Level1, 1);
