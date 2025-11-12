// TEST: Backdoor to Level 1 with Steam and Creation for testing
// T key (ASCII 84)
global.level_progress = 1;

// Set up player inventory with Steam and Creation
global.next_room_inv_names = ["Steam", "Creation", "Clay"];
global.next_room_sel_slot = 0;

goto_level(Level1, 1);
