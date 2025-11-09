// If the cutscene animation is playing, draw it and skip drawing the player
if (play_player_anim && sprite_exists(player_cutscene_sprite)) {
    var px = 0, py = 0, sx = 1, sy = 1;
    if (!is_undefined(player_snapshot)) {
        px = player_snapshot.x;
        py = player_snapshot.y;
        sx = sign(player_snapshot.image_xscale);
        sy = player_snapshot.image_yscale;
    }
    var frame = floor(player_cutscene_sprite_index);
    draw_sprite_ext(player_cutscene_sprite, frame, px, py, sx, sy, 0, c_white, 1);
    exit; // Do not draw the player or snapshot underneath
}

// Fallback if animation not started: draw snapshot only (player deactivated)
if (!is_undefined(player_snapshot)) {
    var snap = player_snapshot;
    var draw_scale_x = (snap.image_xscale == 0) ? 1 : snap.image_xscale;
    draw_sprite_ext(snap.sprite, snap.image_index, snap.x, snap.y, draw_scale_x, snap.image_yscale, snap.image_angle, snap.image_blend, snap.image_alpha);
}