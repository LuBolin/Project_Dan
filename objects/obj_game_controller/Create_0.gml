// Game Controller - Create Event

death_timer = 0;

// Play BGM for levels (looping) at 50% volume
if (!audio_is_playing(snd_dungeon_bgm)) {
    var bgm_instance = audio_play_sound(snd_dungeon_bgm, 1, true);
    audio_sound_gain(bgm_instance, 0.5, 0); // Set volume to 50%
}

// Debug settings
global.debug_draw_collisions = true;
