tool
class_name Item extends Resource

export(Resource) var parent setget set_parent, get_parent
export(Resource) var cached setget set_cached, get_cached
export(String) var name setget set_name, get_name
export(int) var parent_id setget , get_parent_id
export(int) var id setget , get_id
export(bool) var has_parent setget , get_has_parent
export(bool) var has_parent_id setget , get_has_parent_id
export(bool) var has_cached setget , get_has_cached
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var destroyed setget set_destroyed, get_destroyed

var saved_parent: EncodedObjectAsID
var saved_self: EncodedObjectAsID
var meta_data: Dictionary


func _init():
	resource_local_to_scene = true
	meta_data = {
		"parent_id": 0,
		"id": 0,
		"name": "",
		"state":
		{
			"has_parent": false,
			"has_parent_id": false,
			"has_cached": false,
			"has_id": false,
			"has_name": false,
			"initialized": false,
			"enabled": false
		},
		"parent": null,
		"cached": null
	}


# setters, getters functions
func set_parent(_parent: Object):
	if not meta_data.has_parent && not meta_data.has_parent_id && _parent != null:
		saved_parent = _parent
		meta_data.parent = saved_parent
		meta_data.has_parent = true
		meta_data.has_parent_id = true


func get_parent():
	if meta_data.has_parent:
		return meta_data.parent


func get_parent_id():
	if meta_data.has_parent && meta_data.has_parent_id:
		return meta_data.parent.object_id()


func set_cached(_cached: Object):
	if not meta_data.has_cached && not meta_data.has_id && _cached != null:
		saved_self = _cached
		meta_data.cached = saved_self
		meta_data.has_cached = true
		meta_data.has_id = true


func get_cached():
	if meta_data.has_cached:
		return meta_data.cached


func get_id():
	if meta_data.has_cached && meta_data.has_id:
		return meta_data.cached.object_id()


func get_name():
	if meta_data.has_name:
		return meta_data.name


func set_name(_name: String):
	if not meta_data.has_name && StringUtility.is_valid(_name):
		meta_data.name = _name
		meta_data.has_name = true


func get_has_parent():
	return meta_data.has_parent


func get_has_parent_id():
	return meta_data.has_parent_id


func get_has_cached():
	return meta_data.has_cached


func get_has_id():
	return meta_data.has_id


func get_has_name():
	return meta_data.has_name


func set_initialized(_initialized: bool):
	if _initialized && not meta_data.initialized && meta_data.has_cached && meta_data.has_id && meta_data.has_name:
		meta_data.initialized = _initialized


func get_initialized():
	return meta_data.initialized


func set_enabled(_enabled: bool):
	if meta_data.initialized:
		meta_data.enabled = _enabled


func get_enabled():
	return meta_data.enabled


func set_destroyed(_destroyed: bool):
	meta_data.destroyed = _destroyed


func get_destroyed():
	return meta_data.destroyed
