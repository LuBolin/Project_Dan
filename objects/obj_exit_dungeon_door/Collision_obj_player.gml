if (to_kill <= 0) {
    // After completing a level, always go to AlchemyRoom
    global.previous_room = room;
    room_goto(AlchemyRoom);
}