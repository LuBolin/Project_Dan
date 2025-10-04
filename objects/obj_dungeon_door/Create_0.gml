/// Dungeon Door - Create

// door_type and target_room are set via object properties in the room editor
// door_type: "entry" or "exit"
// target_room: which room to go to when player collides (for exit doors)

// Visual indicator for entry vs exit
if (door_type == "entry") {
    image_blend = c_green; // Entry doors are greenish
} else {
    image_blend = c_ltgray; // Exit doors are light gray
}
