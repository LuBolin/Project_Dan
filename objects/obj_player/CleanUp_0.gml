if (instance_exists(obj_aim_arrow)) with (obj_aim_arrow) instance_destroy();

var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
if (instance_exists(cam_inst) && cam_inst.follow == id) {
    cam_inst.follow = noone;
}