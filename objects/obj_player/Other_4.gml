// Use "Instances" layer if it exists, otherwise use any available layer
var target_layer = layer_exists("Instances") ? layer_get_id("Instances") : layer;
var aim_arrow = instance_create_layer(x, y, target_layer, obj_aim_arrow);

aim_arrow.player = id;
aim_arrow.depth = self.depth + 1;

var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
if (cam_inst == noone) cam_inst = instance_create_layer(x, y, target_layer, obj_camera);
cam_inst.follow = id;
cam_inst.smooth = 0.12;
cam_inst.preferred_ratio = 0.2;
