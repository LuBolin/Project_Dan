function scr_DeltaTime() {
    // Apparently deltatime isnt deltatime and is instead frame time in GameMaker. Why?!?!?!?
    // Currently not used because move_and_collide becomes choppy with this and I'm too lazy to figure out why.
    // Just in case yall need it ig
    
    // Actual Delta -> delta_time / 1000000 convert frame time from microseconds to milliseconds
    // Target delta -> current base framerate is 60fps. Change this to the framerate of the sprites animations when needed
    var _delta_multiplier = (delta_time / 1000000) / (1/60);
    var _time_scale = 1;
    
    return _delta_multiplier * _time_scale;
}