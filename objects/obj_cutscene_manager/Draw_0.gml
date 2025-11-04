if (instance_exists(obj_player)) {
    with (obj_player) {
        event_perform(ev_draw, 0);
    }
}

if (player_snapshot != undefined) {
    var snap = player_snapshot;
    var draw_scale_x = snap.image_xscale;
    if (draw_scale_x == 0) draw_scale_x = 1;

    draw_sprite_ext(snap.sprite, snap.image_index, snap.x, snap.y, draw_scale_x, snap.image_yscale, snap.image_angle, snap.image_blend, snap.image_alpha);

    // draw a small gourd icon near the player (use a known sprite resource, not obj_player.spr_gourd_icon)
    if (sprite_exists(player_icon_sprite)) {
        var sw = max(1, sprite_get_width(player_icon_sprite));
        var sh = max(1, sprite_get_height(player_icon_sprite));
        var scale = 20 / max(sw, sh);
        var facing = sign(draw_scale_x);
        if (facing == 0) facing = 1;
        draw_sprite_ext(player_icon_sprite, 0, snap.x - 10 * facing, snap.y + 20, scale, scale, 0, player_active_gourd_color, 1);
    }
}