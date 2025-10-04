function player_radius_simple(_p) {
    var pw = sprite_get_width(_p.sprite_index)  * abs(_p.image_xscale);
    var ph = sprite_get_height(_p.sprite_index) * abs(_p.image_yscale);
    return max(pw, ph) * 0.5;
}