"""
tool
class_name PhysicsInterpolationData extends Resource

# properties
export(bool) var interpolating setget , get_interpolating

# fields
const _BASE_CLASS_NAME = "PhysicsInterpolationData"
var _interp: bool


# setters, getters functions
func get_interpolating():
	return _interp


# public methods
func update(_do_interpolate: bool):
	if _interp:
		_update()
	_interp = _do_interpolate


func snap_to_target():
	pass


# inherited methods
func is_class(_class: String):
	return _class == _BASE_CLASS_NAME


func get_class():
	return _BASE_CLASS_NAME


func _init():
	resource_local_to_scene = true
	_interp = false


# private methods
func _update():
	pass
"""
