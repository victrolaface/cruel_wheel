tool
class_name Item extends Resource

export(Resource) var parent setget set_parent, get_parent
export(Resource) var cached setget set_cached, get_cached
export(String) var name setget set_name, get_name
export(int) var parent_id setget , get_parent_id
export(int) var id setget , get_id
export(bool) var has_parent setget , get_has_parent
export(bool) var is_cached setget , get_is_cached
export(bool) var has_name setget , get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var destroyed setget set_destroyed, get_destroyed

var meta_data: Dictionary
var saved_parent: EncodedObjectAsID
var saved_self: EncodedObjectAsID


func _init():
	resource_local_to_scene = true
	meta_data = {"name": "", "state": {"initialized": false, "enabled": false}}
	saved_parent.object_id = 0
	saved_self.object_id = 0


# setters, getters functions
func set_parent(_parent: Object):
	saved_parent.object_id = _on_cache(saved_parent.object_id, self.has_parent, _parent, _parent.get_instance_id())


func get_parent():
	if self.has_parent:
		return instance_from_id(saved_parent.object_id)


func set_cached(_cached: Object):
	saved_self.object_id = _on_cache(saved_self.object_id, self.is_cached, _cached, _cached.get_instance_id())


func get_cached():
	if self.is_cached:
		return instance_from_id(saved_self.object_id)


func set_name(_name: String):
	if not self.has_name && StringUtility.is_valid(_name):
		meta_data.name = _name


func get_name():
	if self.has_name:
		return meta_data.name


func get_parent_id():
	if self.has_parent:
		return saved_parent.object_id


func get_id():
	if self.is_cached:
		return saved_self.object_id


func get_has_parent():
	return IDUtility.is_valid(saved_parent.object_id)


func get_is_cached():
	return IDUtility.is_valid(saved_self.object_id)


func get_has_name():
	return StringUtility.is_valid(meta_data.name)


func set_initialized(_initialized: bool):
	if _initialized && not self.initialized && self.is_cached && self.has_name:
		meta_data.initialized = _initialized


func get_initialized():
	return meta_data.initialized


func set_enabled(_enabled: bool):
	if self.initialized:
		meta_data.enabled = _enabled


func get_enabled():
	return meta_data.enabled


func set_destroyed(_destroyed: bool):
	if _destroyed && not self.destroyed:
		if self.enabled:
			self.enabled = not _destroyed
		meta_data.destroyed = _destroyed


func get_destroyed():
	return meta_data.destroyed


# setters, getters helper functions
func _on_cache(_init_obj_id: int, _has_obj: bool, _obj: Object, _obj_id: int):
	var _id = _init_obj_id
	if not _has_obj && _obj != null && IDUtility.is_valid(_obj_id):
		_id = _obj_id
	return _id
