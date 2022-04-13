class_name SignalManager extends Resource

export(int) var id setget , get_id
export(String) var name setget , get_name
export(Array, Resource) var self_deferred setget , get_self_deferred
export(Array, Resource) var self_persist setget , get_self_persist
export(Array, Resource) var self_oneshot setget , get_self_oneshot
export(Array, Resource) var self_reference_counted setget , get_self_reference_counted
export(Array, Resource) var nonself_deferred setget , get_nonself_deferred
export(Array, Resource) var nonself_persist setget , get_nonself_persist
export(Array, Resource) var nonself_oneshot setget , get_nonself_oneshot
export(Array, Resource) var nonself_reference_counted setget , get_nonself_reference_counted
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var has_self_deferred setget , get_has_self_deferred
export(bool) var has_self_persist setget , get_has_self_persist
export(bool) var has_self_oneshot setget , get_has_self_oneshot
export(bool) var has_self_reference_counted setget , get_has_self_reference_counted
export(bool) var has_nonself_deferred setget , get_has_nonself_deferred
export(bool) var has_nonself_persist setget , get_has_nonself_persist
export(bool) var has_nonself_oneshot setget , get_has_nonself_oneshot
export(bool) var has_nonself_reference_counted setget , get_has_nonself_reference_counted
export(bool) var saved setget , get_saved
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed

var data: Dictionary
var cached: EncodedObjectAsID


func _init():
	resource_local_to_scene = true
	var _id = get_instance_id()
	var valid_id = IDUtility.is_valid(_id)
	var save = false
	if valid_id:
		cached.object_id = _id
	else:
		_id = 0
	var _name = get_class()
	var valid_name = StringUtility.is_valid(_name)
	if not valid_name:
		_name = ""
	if valid_id && valid_name:
		_name = _name + "-" + _id
		save = true
	var _destroyed = not save
	data = {
		"name": _name,
		"self": {"SELF_DEFERRED": [], "SELF_PERSIST": [], "SELF_ONESHOT": [], "SELF_REFERENCED_COUNTED": []},
		"nonself": {"NONSELF_DEFERRED": [], "NONSELF_PERSIST": [], "NONSELF_ONESHOT": [], "NONSELF_REFERENCE_COUNTED": []},
		"state":
		{
			"has_id": false,
			"has_name": false,
			"has_self_deferred": false,
			"has_self_persist": false,
			"has_self_oneshot": false,
			"has_self_reference_counted": false,
			"has_nonself_deferred": false,
			"has_nonself_persist": false,
			"has_nonself_oneshot": false,
			"has_nonself_reference_counted": false,
			"saved": save,
			"initialized": save,
			"enabled": save,
			"destroyed": _destroyed
		}
	}


# public methods
func added(_signal_item: SignalItem):
	return true


# setters, getters functions
func get_id():
	if self.has_id:
		return saved.object_id


func get_name():
	if self.has_name:
		return data.name


func get_self_deferred():
	if self.has_self_deferred:
		return data.self.SELF_DEFERRED


func get_self_persist():
	if self.has_self_persist:
		return data.self.SELF_PERSIST


func get_self_oneshot():
	if self.has_self_oneshot:
		return data.self.SELF_ONESHOT


func get_self_reference_counted():
	if self.has_self_reference_counted:
		return data.self.SELF_REFERENCE_COUNTED


func get_nonself_deferred():
	if self.has_nonself_deferred:
		return data.nonself.NONSELF_DEFERRED


func get_nonself_persist():
	if self.has_nonself_persist:
		return data.nonself.NONSELF_PERSIST


func get_nonself_oneshot():
	if self.has_nonself_oneshot:
		return data.nonself.NONSELF_ONESHOT


func get_nonself_reference_counted():
	if self.has_nonself_reference_counted:
		return data.nonself.NONSELF_REFERENCE_COUNTED


func get_has_id():
	if not data.state.has_id && self.saved:
		data.state.has_id = IDUtility.is_valid(saved.object_id)
	return data.state.has_id


func get_has_name():
	if not data.state.has_name:
		data.state.has_name = StringUtility.is_valid(data.name)
	return data.state.has_name


func get_has_self_deferred():
	return _has(data.state.has_self_deferred, data.self.SELF_DEFERRED, SignalTypes.SignalType.SELF_DEFERRED)


func get_has_self_persist():
	return _has(data.state.has_self_persist, data.self.SELF_PERSIST, SignalTypes.SignalType.SELF_PERSIST)


func get_has_self_oneshot():
	return _has(data.state.has_self_oneshot, data.self.SELF_ONESHOT, SignalTypes.SignalType.SELF_ONESHOT)


func get_has_self_reference_counted():
	return _has(
		data.state.has_self_reference_counted,
		data.self.SELF_REFERENCE_COUNTED,
		SignalTypes.SignalType.SELF_REFERENCE_COUNTED
	)


func get_has_nonself_deferred():
	return _has(data.state.has_nonself_deferred, data.nonself.NONSELF_DEFERRED, SignalTypes.SignalType.NONSELF_DEFERRED)


func get_has_nonself_persist():
	return _has(data.state.has_nonself_persist, data.nonself.NONSELF_PERSIST, SignalTypes.SignalType.NONSELF_PERSIST)


func get_has_nonself_oneshot():
	return _has(data.state.has_nonself_oneshot, data.nonself.NONSELF_ONESHOT, SignalTypes.SignalType.NONSELF_ONESHOT)


func get_has_nonself_reference_counted():
	return _has(
		data.state.has_nonself_reference_counted,
		data.nonself.NONSELF_REFERENCE_COUNTED,
		SignalTypes.SignalType.NONSELF_REFERENCE_COUNTED
	)


func get_saved():
	return data.state.saved


func get_initialized():
	return data.state.initialized


func get_enabled():
	return data.state.enabled


func get_destroyed():
	return data.state.destroyed


# setters, getters helper functions
func _has(_has_items = false, _items = [], _signal_type = SignalTypes.SignalType.NONE):
	var has = false
	if not _has_items:
		match _signal_type:
			SignalTypes.SignalType.SELF_DEFERRED:
				data.state.has_self_deferred = _items.count() > 0
				has = data.state.has_self_deferred
			SignalTypes.SignalType.SELF_PERSIST:
				data.state.has_self_persist = _items.count() > 0
				has = data.state.has_self_persist
			SignalTypes.SignalType.SELF_ONESHOT:
				data.state.has_self_oneshot = _items.count() > 0
				has = data.state.has_self_oneshot
			SignalTypes.SignalType.SELF_REFERENCE_COUNTED:
				data.state.has_self_reference_counted = _items.count() > 0
				has = data.state.has_self_reference_counted
			SignalTypes.SignalType.NONSELF_DEFERRED:
				data.state.has_nonself_deferred = _items.count() > 0
				has = data.state.has_nonself_deferred
			SignalTypes.SignalType.NONSELF_PERSIST:
				data.state.has_nonself_persist = _items.count() > 0
				has = data.state.has_nonself_persist
			SignalTypes.SignalType.NONSELF_ONESHOT:
				data.state.has_nonself_oneshot = _items.count() > 0
				has = data.state.has_nonself_oneshot
			SignalTypes.SignalType.NONSELF_REFERENCE_COUNTED:
				data.state.has_nonself_reference_counted = _items.count() > 0
				has = data.state.has_nonself_reference_counted
			_:
				has = false
	else:
		has = true
	return has && self.initialized && self.enabled && not self.destroyed
