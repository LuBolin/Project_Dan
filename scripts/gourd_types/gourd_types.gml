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

    use = function(p) {
        shoot_projectile(p, obj_rock_bullet);
    };
}

function GourdWater() : GourdBase() constructor
{
    name = "Water";
	color = c_blue;
    cooldown = 5;

    use = function(p) {
        shoot_projectile(p, obj_water_bullet);
    };
}

function GourdWind() : GourdBase() constructor
{
    name = "Wind";
	color = c_gray;
    cooldown = 5;

    use = function(p) {
    };
}

function GourdMud() : GourdBase() constructor
{
    name = "Mud";
	color = make_color_rgb(101, 67, 33);
    cooldown = 4;

    use = function(p) {
    };
}

function GourdHurricane() : GourdBase() constructor
{
    name = "Hurricane";
	color = make_color_rgb(70, 130, 180);
    cooldown = 6;

    use = function(p) {
    };
}
