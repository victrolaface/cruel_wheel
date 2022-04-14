class_name Item extends Resource

export(String) var name setget , get_name
export(int) var id setget , get_id
export(int) var instance_id setget , get_instance_id
export(Resource) var ref_self setget set_ref_self, get_ref_self
export(String) var parent_name setget , get_parent_name
export(int) var parent_id setget , get_parent_id
export(int) var parent_instance_id setget , get_parent_instance_id
export(Resource) var ref_parent setget set_ref_parent, get_ref_parent
export(int) var parent_entity_id setget , get_parent_entity_id
export(int) var parent_entity_instance_id setget , get_parent_entity_instance_id
export(Resource) var ref_parent_entity setget set_ref_parent_entity, get_ref_parent_entity
export(bool) var has_id setget , get_has_id
export(bool) var has_instance_id setget , get_has_instance_id
export(bool) var has_name setget , get_has_name
export(bool) var has_parent_id setget , get_has_parent_id
export(bool) var has_parent_instance_id setget , get_has_parent_instance_id
export(bool) var has_parent_name setget , get_has_parent_name
export(bool) var has_parent_entity_id setget , get_has_parent_entity_id
export(bool) var has_parent_entity_instance_id setget , get_has_parent_entity_instance_id
export(bool) var meta_initialized setget , get_meta_initialized
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var destroyed setget set_destroyed, get_destroyed

var meta_data: Dictionary


func _init():
	resource_local_to_scene = true
	meta_data = {
		"ref_self": null,
		"ref_parent_entity": null,
		"id": 0,
		"parent_id": 0,
		"name": "",
		"state":
		{
			"saved": false,
			"saved_parent": false,
			"has_id": false,
			"has_parent_id": false,
			"has_name": false,
			"initialized": false,
			"enabled": false,
			"destroyed": false
		}
	}


# setters, getters functions
func set_ref_self(_ref_self: Object):
	if not self.saved:
		if IDUtility.object_is_valid(_ref_self):
			meta_data.ref_self = _ref_self
			if not self.has_id:
				meta_data.id = meta_data.ref_self.get_instance_id()
				meta_data.state.has_id = true
			if not self.has_name:
				var _name = meta_data.ref_self.get_class()
				if StringUtility.is_valid(_name):
					meta_data.name = _name
					meta_data.state.has_name = true
			meta_data.state.saved = self.has_id && self.has_name
			#if self.saved && self.saved_parent && not self.initialized:
			#	meta_data.state.initialized
			#if self.saved && self.has_name && self.saved_parent:


func get_ref_self():
	if self.saved:
		return meta_data.ref_self


func set_ref_parent(_ref_parent: Object):
	if not self.saved_parent:
		if IDUtility.object_is_valid(_ref_parent):
			meta_data.ref_parent = _ref_parent
			if not self.has_parent_id:
				meta_data.parent_id = meta_data.ref_parent.get_instance_id()
				meta_data.state.has_parent_id = true

			#meta_data.parent_id = meta_data.ref_parent.get_instance_id()
			#meta_data.state.saved_parent = true


func get_ref_parent():
	if self.saved_parent:
		return meta_data.ref_parent


func get_id():
	if self.saved:
		return meta_data.id


func get_parent_id():
	if self.saved_parent:
		return meta_data.parent_id


func get_name():
	if self.has_name:
		return meta_data.name


func get_saved():
	if not meta_data.state.saved:
		meta_data.state.saved = IDUtility.object_is_valid(meta_data.ref_self)
	return meta_data.state.saved


func get_saved_parent():
	if not meta_data.state.saved_parent:
		meta_data.state.saved_parent = IDUtility.object_is_valid(meta_data.ref_parent)
	return meta_data.state.saved_parent


func get_has_id():
	if not meta_data.state.has_id:
		meta_data.state.has_id = IDUtility.is_valid(meta_data.id)
	return meta_data.state.has_id


func get_has_parent_id():
	if not meta_data.state.has_parent_id:
		meta_data.state.has_parent_id = IDUtility.is_valid(meta_data.parent_id)
	return meta_data.state.has_parent_id


func get_has_name():
	if not meta_data.state.has_name:
		meta_data.state.has_name = StringUtility.is_valid(meta_data.name)
	return meta_data.state.has_name


func set_initialized(_initialized: bool):
	if _initialized && not self.initialized && self.is_saved && self.has_name:
		meta_data.state.initialized = _initialized


func get_initialized():
	return meta_data.state.initialized


func set_enabled(_enabled: bool):
	if self.initialized:
		meta_data.state.enabled = _enabled


func get_enabled():
	return meta_data.state.enabled


func set_destroyed(_destroyed: bool):
	if _destroyed && not self.destroyed:
		if self.enabled:
			self.enabled = not _destroyed
		meta_data.state.destroyed = _destroyed


func get_destroyed():
	return meta_data.state.destroyed
