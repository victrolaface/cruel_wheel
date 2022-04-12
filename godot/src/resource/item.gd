tool
class_name Item extends Resource

export(int) var parent_id setget set_parent_id, get_parent_id
export(int) var id setget set_id, get_id
export(String) var name setget set_name, get_name
export(bool) var has_parent_id setget set_has_parent_id, get_has_parent_id
export(bool) var has_id setget set_has_id, get_has_id
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled

var meta_data: Meta


func _init():
	meta_data = Meta.new()
	resource_local_to_scene = true
	meta_data.id = get_instance_id()


# setters, getters functions
func set_parent_id(_parent_id: int):
	pass


func get_parent_id():
	return meta_data.parent_id


func set_id(_id):
	pass


func get_id():
	return meta_data.id


func set_name(_name: String):
	meta_data.name = _name


func get_name():
	return meta_data.name


func set_has_parent_id(_has_parent_id: bool):
	pass


func get_has_parent_id():
	return meta_data.has_parent_id


func set_has_id(_has_id: bool):
	pass


func get_has_id():
	return meta_data.has_id


func set_has_name(_has_name: bool):
	pass


func get_has_name():
	return meta_data.has_name


func set_initialized(_initialized: bool):
	meta_data.initialized = _initialized


func get_initialized():
	return meta_data.initialized


func set_enabled(_enabled: bool):
	meta_data.enabled = _enabled


func get_enabled():
	return meta_data.enabled
