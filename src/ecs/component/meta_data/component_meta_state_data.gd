extends Resource
class_name ComponentMetaStateData

export(bool) var enabled
export(bool) var destroyed
export(bool) var parented
export(bool) var initialized


func _init():
	resource_local_to_scene = true
	enabled = false
	destroyed = false
	parented = false
	initialized = false


func initialize(
	_local = true, _enable = false, _destroy = false, _parent = false, _initialized = false
):
	resource_local_to_scene = _local
	enabled = _enable
	destroyed = _destroy
	parented = _parent
	initialized = _initialized
