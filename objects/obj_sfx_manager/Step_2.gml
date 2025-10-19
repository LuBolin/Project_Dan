for (var i = 0; i < array_length(sfxs_queue); i += 1) {
    var _snd_pitch_pair = sfxs_queue[i];
    if (_snd_pitch_pair[2] or !audio_is_playing(_snd_pitch_pair[0])) {
        audio_play_sound(_snd_pitch_pair[0], 8, false, 1, 0, _snd_pitch_pair[1]);
    }
    
}
sfxs_queue = []