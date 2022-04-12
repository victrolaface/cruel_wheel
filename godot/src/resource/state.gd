tool
class_name State extends Resource

export(bool) var has_parent_id setget set_has_parent_id, get_has_parent_id
export(bool) var has_id setget set_has_id, get_has_id
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled


func _init():
	has_parent_id = false
	has_id = false
	has_name = false
	initialized = false
	enabled = false
	resource_local_to_scene = true


# setters, getters functions
func set_has_parent_id(_has_parent_id: bool):
	has_parent_id = _has_parent_id


func get_has_parent_id():
	return has_parent_id


func set_has_id(_has_id: bool):
	has_id = _has_id


func get_has_id():
	return has_id


func set_has_name(_has_name: bool):
	has_name = _has_name


func get_has_name():
	return has_name


func set_initialized(_initialized: bool):
	initialized = _initialized


func get_initialized():
	return initialized


func set_enabled(_enabled: bool):
	enabled = _enabled


func get_enabled():
	return enabled
