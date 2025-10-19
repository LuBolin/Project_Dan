// Exit doors keep the default sprite (spr_dungeon_door)
image_blend = c_ltgray; // Exit doors are light gray

//unlocked = true;
to_kill = 0;
open_sfx_fin = false

// Set depth so door renders behind instances but in front of terrain
depth = 190;

function update_exit_kills(_to_kill) {
    
    to_kill = _to_kill;
    if (!open_sfx_fin and to_kill == 0) {
        open_sfx_fin = true
        obj_sfx_manager.play_sound(snd_unlock, false)
    }
}