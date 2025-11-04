// Scale to match original displayed size (128x160 from 128x128)
// Old sprite: 320x400 * 0.4 = 128x160
// New sprite: 128x128 * scale = 128x160
image_xscale = 1.0   // 128/128
image_yscale = 1.25  // 160/128
// Inherit the parent event
event_inherited();

