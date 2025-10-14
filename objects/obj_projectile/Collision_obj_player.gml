// TEMPORARY TO ALLOW GHOST PROJECTILE TO HIT PLAYER
// THIS MEANS THAT PLAYER CAN GET HIT BY THEIR OWN HURRICANE
if (variable_struct_exists(proj_data, "on_hit")) {
	proj_data.on_hit(self, other);
}