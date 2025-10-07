global.player = id;

invuln = false

self.inv = [
    gourd_create(GourdEarth),
    gourd_create(GourdWater),
    gourd_create(GourdWind)
];

self.sel_slot = 0;

var aim_arrow = instance_create_layer(x, y, layer, obj_aim_arrow);
aim_arrow.player = id;
aim_arrow.depth = self.depth + 1;

var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
if (cam_inst == noone) cam_inst = instance_create_layer(x, y, layer, obj_camera);
cam_inst.follow = id;
cam_inst.smooth = 0.12;
cam_inst.preferred_ratio = 0.2;

self.shoot_delay = 15;
self.shoot_cooldown = 0;

colliders = [layer_tilemap_get_id("Tile_Collision")]