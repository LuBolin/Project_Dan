// Exit doors keep the default sprite (spr_dungeon_door)
image_blend = c_ltgray; // Exit doors are light gray

//unlocked = true;
to_kill = 0;

// Set depth so door renders behind instances but in front of terrain
depth = 190;

function update_exit_kills(_to_kill) {
    
    to_kill = _to_kill;
    if (to_kill == 0) {
        obj_sfx_manager.play_sound(snd_unlock, false)
    }
}