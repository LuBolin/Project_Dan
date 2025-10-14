if (target_room != noone && room_exists(target_room) && to_kill <= 0) {
    // Store the room we're leaving so we can return to it
    global.previous_room = room;
    room_goto(target_room);
}