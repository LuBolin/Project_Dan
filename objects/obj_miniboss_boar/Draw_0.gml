// Draw the miniboss at 1.5x scale
// Store original scale (in case there's any direction flipping)
var original_xscale = image_xscale;
var original_yscale = image_yscale;

// Apply 1.5x scale while preserving any negative scale for direction
if (original_xscale != 0) {
    image_xscale = 1.5 * sign(original_xscale);
} else {
    image_xscale = 1.5;
}
image_yscale = 1.5;

// Call parent draw event which uses draw_self()
event_inherited()
image_blend = c_purple;
// Note: We don't need to restore scale as it gets reset each frame anyway