extends Resource
class_name ComponentMetaConnectionsData

export(bool) var enabled
export(bool) var disabled
export(bool) var destroyed
export(bool) var parented
export(bool) var initialized


func _init():
	resource_local_to_scene = true
	enabled = false
	disabled = false
	destroyed = false
	parented = false
	initialized = false


func initialize(
	_is_local = true,
	_enabled = false,
	_disabled = false,
	_destroyed = false,
	_parented = false,
	_initialized = false
):
	resource_local_to_scene = _is_local
	enabled = _enabled
	disabled = _disabled
	destroyed = _destroyed
	parented = _parented
	initialized = _initialized
