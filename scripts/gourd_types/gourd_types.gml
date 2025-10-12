function GourdNone()  : GourdBase() constructor {
	name = "(Empty)";
	cooldown = 0;
	use=function(_p){};
}

// ========================================
// TIER 0 - BASE ELEMENTS
// ========================================

function GourdFire() : GourdBase() constructor
{
    name = "Fire";
	color = c_red;
    cooldown = 3;
	projectile = ProjectileFire;
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

function GourdAir() : GourdBase() constructor
{
    name = "Air";
	color = c_white;
    cooldown = 3;
	projectile = ProjectileAir;
}

// ========================================
// TIER 1 - BASIC COMBINATIONS
// ========================================

function GourdLava() : GourdBase() constructor
{
    name = "Lava";
	color = c_orange;
    cooldown = 5;
	projectile = ProjectileLava;
}

function GourdSteam() : GourdBase() constructor
{
    name = "Steam";
	color = make_color_rgb(200, 220, 255);
    cooldown = 4;
	projectile = ProjectileSteam;
}

function GourdMud() : GourdBase() constructor
{
    name = "Mud";
	color = make_color_rgb(101, 67, 33);
    cooldown = 4;
	projectile = ProjectileMudBall;
}

function GourdWind() : GourdBase() constructor
{
    name = "Wind";
	color = c_gray;
    cooldown = 5;
	projectile = ProjectileWindGust;
}

// ========================================
// TIER 2 - ADVANCED COMBINATIONS
// ========================================

function GourdObsidian() : GourdBase() constructor
{
    name = "Obsidian";
	color = make_color_rgb(20, 10, 30);
    cooldown = 7;
	projectile = ProjectileObsidian;
}

function GourdFog() : GourdBase() constructor
{
    name = "Fog";
	color = make_color_rgb(180, 180, 200);
    cooldown = 6;
	projectile = ProjectileFog;
}

function GourdClay() : GourdBase() constructor
{
    name = "Clay";
	color = make_color_rgb(178, 118, 88);
    cooldown = 5;
	projectile = ProjectileClay;
}

function GourdHurricane() : GourdBase() constructor
{
    name = "Hurricane";
	color = make_color_rgb(70, 130, 180);
    cooldown = 6;
	projectile = ProjectileHurricane;
}

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function GourdGolem() : GourdBase() constructor
{
    name = "Golem";
	color = make_color_rgb(139, 137, 137);
    cooldown = 8;
	projectile = ProjectileGolem;
}

function GourdSoulMist() : GourdBase() constructor
{
    name = "Soul-Mist";
	color = make_color_rgb(230, 230, 255);
    cooldown = 8;
	projectile = ProjectileSoulMist;
}

// ========================================
// TIER 4 - FINAL ELEMENT
// ========================================

function GourdElixir() : GourdBase() constructor
{
    name = "Elixir";
	color = make_color_rgb(255, 215, 0);
    cooldown = 10;
	projectile = undefined; // Final element - no projectile
}

// Helper function to get gourd type constructor by element name
function get_gourd_type_by_name(element_name) {
    switch (element_name) {
        case "Earth": return GourdEarth;
        case "Water": return GourdWater;
        case "Wind": return GourdWind;
        case "Fire": return GourdFire;
        case "Air": return GourdAir;
        case "Mud": return GourdMud;
        case "Lava": return GourdLava;
        case "Steam": return GourdSteam;
        case "Hurricane": return GourdHurricane;
        case "Obsidian": return GourdObsidian;
        case "Fog": return GourdFog;
        case "Clay": return GourdClay;
        case "Golem": return GourdGolem;
        case "Soul-Mist": return GourdSoulMist;
        case "Elixir": return GourdElixir;
        default: return undefined;
    }
}
