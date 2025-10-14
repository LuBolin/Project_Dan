image_alpha = lerp(image_alpha, 1, 0.2);
image_yscale = lerp(image_yscale, 1, 0.2)


// Decrease lifetime
life_time -= 1;
if (life_time <= 0) instance_destroy();