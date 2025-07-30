class_name Camera3DTexelSnapped
extends Camera3D

@export var snap := true

@onready var _prev_rotation := global_rotation
@onready var _snap_space := global_transform
func _process(delta):
	if global_rotation != _prev_rotation:
		_prev_rotation = global_rotation
		_snap_space = global_transform
	#1/s
	var texel_size := size/180.0
	#p1
	var snap_space_position := global_position * _snap_space
	#p2
	var snapped_snap_space_position := snap_space_position.snapped(Vector3.ONE * texel_size)
	#r
	var snap_error := snapped_snap_space_position - snap_space_position
	if snap:
		h_offset = snap_error.x
		v_offset = snap_error.y
