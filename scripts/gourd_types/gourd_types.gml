function GourdNone()  : GourdBase() constructor {
	name = "(Empty)";
	cooldown = 0;
	use=function(_p){};
}


function GourdEarth() : GourdBase() constructor
{
    name = "Earth";
	color = make_color_rgb(25, 50, 0);
    cooldown = 2;
	projectile = ProjectileRock;
}

function GourdWater() : GourdBase() constructor
{
    name = "Water";
	color = c_blue;
    cooldown = 5;
	projectile = ProjectileWaterBall;
}

function GourdWind() : GourdBase() constructor
{
    name = "Wind";
	color = c_gray;
    cooldown = 5;
	projectile = ProjectileWindGust;
}

function GourdMud() : GourdBase() constructor
{
    name = "Mud";
	color = make_color_rgb(101, 67, 33);
    cooldown = 4;
	projectile = ProjectileMudBall;
}

function GourdHurricane() : GourdBase() constructor
{
    name = "Hurricane";
	color = make_color_rgb(70, 130, 180);
    cooldown = 6;
	projectile = ProjectileHurricane;
}
