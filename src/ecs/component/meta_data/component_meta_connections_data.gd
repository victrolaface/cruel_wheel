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
