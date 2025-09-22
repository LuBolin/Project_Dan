move_speed = 3;

aim_arrow = instance_create_layer(x, y, layer, obj_aim_arrow);
aim_arrow.player = id;
// more positive draws on below, we want indicator below player
aim_arrow.depth = self.depth + 1;


// spawn or adopt a camera
var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
if (cam_inst == noone) cam_inst = instance_create_layer(x, y, layer, obj_camera);

// assign self
cam_inst.follow = id;

// tweak camera settings
cam_inst.smooth = 0.12;
cam_inst.preferred_ratio = 0.2; // e.g. 20% of screen height
