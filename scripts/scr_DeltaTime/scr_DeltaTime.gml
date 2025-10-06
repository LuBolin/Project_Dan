function scr_DeltaTime() {
    var _delta_multiplier = (delta_time / 1000000) / (1/60);
    var _time_scale = 1;

    return _delta_multiplier * _time_scale;
}