global.player = id;

// Invuln timer for player to escape if they get hit
invuln = false

// Randomly select 3 of the 4 base elements (Fire, Earth, Water, Air)
var base_elements = [GourdFire, GourdEarth, GourdWater, GourdAir];

// Shuffle the array using Fisher-Yates algorithm
for (var i = array_length(base_elements) - 1; i > 0; i--) {
    var j = irandom(i);
    var temp = base_elements[i];
    base_elements[i] = base_elements[j];
    base_elements[j] = temp;
}

// Take the first 3 elements after shuffling
self.inv = [
    gourd_create(base_elements[0]),
    gourd_create(base_elements[1]),
    gourd_create(base_elements[2])
];

self.sel_slot = 0;
self.equipped_element = inv[sel_slot]

alarm[0] = 10
//var aim_arrow = instance_create_layer(x, y, layer, obj_aim_arrow);
//aim_arrow.player = id;
//aim_arrow.depth = self.depth + 1;

//var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
//if (cam_inst == noone) cam_inst = instance_create_layer(x, y, layer, obj_camera);
//cam_inst.follow = id;
//cam_inst.smooth = 0.12;
//cam_inst.preferred_ratio = 0.2;

// Entities that the player will physically collide with, such as walls
colliders = [layer_tilemap_get_id("Tile_Collision")]

// gourd icon
spr_gourd_icon = spr_gourd;
