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
    cooldown = 1.5;
	projectile = ProjectileRock;
}

function GourdWater() : GourdBase() constructor
{
    name = "Water";
	color = c_blue;
    cooldown = 1; // was 3
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
    cooldown = 6;
    projectile = ProjectileLava;
}

function GourdSteam() : GourdBase() constructor
{
    name = "Steam";
	color = make_color_rgb(200, 220, 255);
    cooldown = 8;
	projectile = undefined; // Steam doesn't use projectiles
    
    use = function(_p) {
        if (can_use()) {
            // Check if steam cloud already exists
            if (!instance_exists(obj_steam)) {
                // Create steam cloud at player position
                var steam = instance_create_layer(_p.x, _p.y, "Instances", obj_steam);
                steam.owner = _p;
                trigger_cd();
            } else {
                // Refresh existing steam cloud duration
                with (obj_steam) {
                    life_timer = life_duration;
                }
                trigger_cd();
            }
        }
    }
}

function GourdMud() : GourdBase() constructor
{
    name = "Mud";
	color = make_color_rgb(101, 67, 33);
    cooldown = 4;
	projectile = ProjectileMudBall;
}

function GourdCurrent() : GourdBase() constructor
{
    name = "Current";
	color = make_color_rgb(100, 150, 200);
    cooldown = 5;
	projectile = ProjectileCurrent;
}

// ========================================
// TIER 2 - ADVANCED COMBINATIONS
// ========================================

function GourdEruption() : GourdBase() constructor
{
    name = "Eruption";
	color = make_color_rgb(255, 50, 0);
    cooldown = 7;
	projectile = ProjectileEruption;
}

function GourdHurricane() : GourdBase() constructor
{
    name = "Hurricane";
	color = make_color_rgb(70, 130, 180);
    cooldown = 6;
	projectile = ProjectileHurricane;
}

function GourdClay() : GourdBase() constructor
{
    name = "Clay";
	color = make_color_rgb(178, 118, 88);
    cooldown = 5;
	projectile = ProjectileClay;
}

function GourdPlant() : GourdBase() constructor
{
    name = "Plant";
	color = make_color_rgb(50, 200, 50);
    cooldown = 4;
	projectile = ProjectilePlant;
}

// ========================================
// TIER 3 - POWERFUL ELEMENTS
// ========================================

function GourdDestruction() : GourdBase() constructor
{
    name = "Destruction";
	color = make_color_rgb(150, 0, 0);
    cooldown = 8;
	projectile = ProjectileDestruction;
}

function GourdCreation() : GourdBase() constructor
{
    name = "Creation";
	color = make_color_rgb(255, 255, 200);
    cooldown = 8;
	projectile = ProjectileCreation;
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
        case "Fire": return GourdFire;
        case "Air": return GourdAir;
        case "Mud": return GourdMud;
        case "Lava": return GourdLava;
        case "Steam": return GourdSteam;
        case "Current": return GourdCurrent;
        case "Eruption": return GourdEruption;
        case "Hurricane": return GourdHurricane;
        case "Clay": return GourdClay;
        case "Plant": return GourdPlant;
        case "Destruction": return GourdDestruction;
        case "Creation": return GourdCreation;
        case "Elixir": return GourdElixir;
        default: return undefined;
    }
}
