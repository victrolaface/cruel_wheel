tool
class_name PhysicsInterpolationData2D extends PhysicsInterpolationData

#properties
enum FLAGS { FI_NONE = 0, FI_TRANSLATION = 1, FI_ORIENTATION = 2, FI_SCALE = 4, FI_ALL = 1 | 2 | 4 }
export(FLAGS) var flags setget set_flags, get_flags

# fields
const _CLASS_NAME = "PhysicsInterpolationData2D"
var _data = {"enabled": false, "from": null, "to": null, "target": Node2D, "mask": FLAGS.FI_NONE}


# public methods
func interpolate():  #_mask: int):
	var alpha = Engine.get_physics_interpolation_fraction()
	var interp_transform: Transform2D
	var to_interp_transform = _to_interp(alpha)
	match _data.mask:
		FLAGS.FI_NONE:
			interp_transform = _data.to
		FLAGS.FI_ALL:
			interp_transform = to_interp_transform
		_:
			if _data.mask & FLAGS.FI_TRANSITION:
				interp_transform.origin = to_interp_transform.origin
			else:
				interp_transform.origin = _data.to.origin
			var scale = to_interp_transform.get_scale() if (_data.mask & FLAGS.FI_SCALE) else _data.to.get_scale()
			var rot = to_interp_transform.get_rotation() if (_data.mask & FLAGS.FI_ORIENTATION) else _data.to.get_rotation()
			var cos_rot = cos(rot)
			var sin_rot = sin(rot)
			interp_transform.x = Vector2(cos_rot, sin_rot) * scale.x
			interp_transform.y = Vector2(-sin_rot, cos_rot) * scale.y
	return interp_transform


func snap_to_target():
	if _data.target:
		_on_snap_to_target()


func change_target(_target_node: Node2D):
	if _target_node:
		_data.target = _target_node
		_on_snap_to_target()


# inherited methods, public
func is_class(_class: String):
	return _class == _CLASS_NAME or .is_class(_class)


func get_class():
	return _CLASS_NAME


# inherited methods, private
func _init(_target_node: Node2D).():
	_data.target = _target_node
	snap_to_target()


# private methods
func _to_interp(_alpha: float):
	return _data.from.interpolate_with(_data.to, _alpha)


func _update():
	_data.from = _data.to
	_data.to = _data.target.global_transform


func _on_snap_to_target():
	_data.from = _data.target.global_transform
	_data.to = _data.target.global_transform


# properties, setters, getters functions
func set_flags(_flags: int):
	_data.mask = _flags


func get_flags():
	return _data.mask
