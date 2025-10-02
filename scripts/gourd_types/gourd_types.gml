function GourdNone()  : GourdBase() constructor {
	name = "(Empty)";
	cooldown = 0;
	use=function(_p){};
}


function GourdEarth() : GourdBase() constructor 
{
    name = "Earth";
	color = make_color_rgb(25, 50, 0); // brown-ish
    cooldown = 2;
    
    use = function(p) {
        show_debug_message("Using " + name);
    };
}

function GourdWater() : GourdBase() constructor 
{
    name = "Water";
	color = c_blue;
    cooldown = 3;
    
    use = function(p) {
        show_debug_message("Using " + name);
    };
}

function GourdWind() : GourdBase() constructor 
{
    name = "Wind";
	color = c_gray;
    cooldown = 5;
    
    use = function(p) {
        show_debug_message("Using " + name);
    };
}
