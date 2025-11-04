// Scale to match original displayed size (64x80 from 128x128)
// Old sprite: 320x400 * 0.2 = 64x80
// New sprite: 128x128 * scale = 64x80
image_xscale = 0.5    // 64/128
image_yscale = 0.625  // 80/128
// Inherit the parent event
event_inherited();

