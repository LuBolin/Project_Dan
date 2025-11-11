persistent = true;
global.MASTER_VOL = 1;
global.SFX_VOL = 1;

//https://www.youtube.com/watch?v=Tovh3LwZS9w

sfxs_queue = []

function play_sound(_snd, _play_if_alrdy_playing, _base_pitch = 1) {
    if (!array_contains(sfxs_queue, _snd)) {
        array_push(sfxs_queue, [_snd, _base_pitch + random_range(-0.1, 0.1), _play_if_alrdy_playing])
    }
}

// Initialize global master volume setting if it doesn't exist
if (!variable_global_exists("master_volume")) {
    global.master_volume = 0.25; // 0.0 to 1.0 (starts at 25%)
}

// Apply the master volume setting on startup
audio_master_gain(global.master_volume);