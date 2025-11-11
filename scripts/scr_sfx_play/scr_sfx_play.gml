/// @function sfx_play(_snd, [_allow_overlap=false])
/// Safe sound playback that survives missing/disabled SFX manager.
function sfx_play(_snd, _allow_overlap = false, base_pitch = 1) {
    if (_snd == undefined) return;
    if (instance_exists(obj_sfx_manager)) {
        with (obj_sfx_manager) play_sound(_snd, _allow_overlap, base_pitch);
    } else {
        var m = instance_create_depth(0, 0, -100000, obj_sfx_manager);
        if (m != noone) {
            m.persistent = true;
            with (m) play_sound(_snd, _allow_overlap, base_pitch);
        } else {
            audio_play_sound(_snd, 8, false);
        }
    }
}