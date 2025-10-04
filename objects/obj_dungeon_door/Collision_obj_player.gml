/// Dungeon Door - Collision with Player

// Only exit doors can be used to transition rooms
if (door_type == "exit") {
    if (target_room != noone && room_exists(target_room)) {
        room_goto(target_room);
    }
}
