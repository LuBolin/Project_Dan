// Start timer when entering a gameplay room (not main menu or alchemy)
if (room != MainMenu && room != AlchemyRoom) {
    is_active = true;
} else {
    is_active = false;
}