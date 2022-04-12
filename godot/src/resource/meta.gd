tool
class_name Meta extends Resource

export(int) var parent_id setget set_parent_id, get_parent_id
export(int) var id setget set_id, get_id
export(String) var name setget set_name, get_name
export(bool) var has_parent_id setget set_has_parent_id, get_has_parent_id
export(bool) var has_id setget set_has_id, get_has_id
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled

var data: Data
var state: State


func _init():
	data = Data.new()
	state = State.new()
	resource_local_to_scene = true


# setters, getters functions
func set_parent_id(_parent_id: int):
	if not state.has_parent_id && IDUtility.is_valid(_parent_id):
		data.parent_id = _parent_id
		state.has_parent_id = true


func get_parent_id():
	return data.parent_id


func set_id(_id: int):
	if not state.has_id && IDUtility.is_valid(_id):
		data.id = _id
		state.has_id = true


func get_id():
	return data.id


func set_name(_name: String):
	if not state.has_name && StringUtility.is_valid(_name):
		data.name = _name
		state.has_name = true


func get_name():
	return data.name


func set_has_id(_has_id: bool):
	pass


func get_has_id():
	return state.has_id


func set_has_parent_id(_has_parent_id: bool):
	pass


func get_has_parent_id():
	return state.has_parent_id


func set_has_name(_has_name: bool):
	pass


func get_has_name():
	return state.has_name


func set_initialized(_initialized: bool):
	if _initialized && state.has_id && state.has_name && not state.initialized:
		state.initialized = _initialized


func get_initialized():
	return state.initialized


func set_enabled(_enabled: bool):
	if state.initialized:
		state.enabled = _enabled


func get_enabled():
	return state.enabled
