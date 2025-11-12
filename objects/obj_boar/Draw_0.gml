// Preserve facing while enforcing base scale
var sgn = sign(image_xscale);
if (sgn == 0) sgn = 1;

image_xscale = 1 * sgn;
image_yscale = 1;

event_inherited();