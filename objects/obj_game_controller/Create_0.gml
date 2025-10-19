// Game Controller - Create Event

death_timer = 0;

// Play BGM for levels (looping)
if (!audio_is_playing(snd_dungeon_bgm)) {
    audio_play_sound(snd_dungeon_bgm, 1, true);
}

// Debug settings
global.debug_draw_collisions = true;
