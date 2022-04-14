class_name SignalManager extends Resource

export(int) var id setget , get_id
export(String) var name setget , get_name
export(Resource) var self_deferred setget , get_self_deferred
export(Resource) var self_persist setget , get_self_persist
export(Resource) var self_oneshot setget , get_self_oneshot
export(Resource) var self_reference_counted setget , get_self_reference_counted
export(Resource) var nonself_deferred setget , get_nonself_deferred
export(Resource) var nonself_persist setget , get_nonself_persist
export(Resource) var nonself_oneshot setget , get_nonself_oneshot
export(Resource) var nonself_reference_counted setget , get_nonself_reference_counted
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

const BASE_TYPE = "SignalItem"
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
		"self": {"SELF_DEFERRED": null, "SELF_PERSIST": null, "SELF_ONESHOT": null, "SELF_REFERENCE_COUNTED": null},
		"nonself":
		{"NONSELF_DEFERRED": null, "NONSELF_PERSIST": null, "NONSELF_ONESHOT": null, "NONSELF_REFERENCE_COUNTED": null},
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
func added(_signal_item: SignalItem, _valid = false):
	var added = false
	if not _valid:
		_valid = SignalItemUtility.is_valid(_signal_item)
	if _valid:
		var connected = SignalItemUtility.on_is_connected(_signal_item)
		if not connected:
			connected = SignalItemUtility.on_connect(_signal_item)
		if connected:
			match _signal_item.type:
				SignalItemTypes.SELF_DEFERRED:
					if not self.has_self_deferred:  # init
						data.self.SELF_DEFERRED = ResourceCollection.new()
						data.self.SELF_DEFERRED.set_base_type(BASE_TYPE)
						data.self.SELF_DEFERRED.set_type_readonly(true)
					if _deduped(data.self.SELF_DEFERRED, _signal_item):
						data.self.SELF_DEFERRED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_PERSIST:
					if not self.has_self_persist:  # init
						data.self.SELF_PERSIST = ResourceCollection.new()
						data.self.SELF_PERSIST.set_base_type(BASE_TYPE)
						data.self.SELF_PERSIST.set_type_readonly(true)
					if _deduped(data.self.SELF_PERSIST, _signal_item):
						data.self.SELF_PERSIST.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_ONESHOT:
					if not self.has_self_oneshot:  # init
						data.self.SELF_ONESHOT = ResourceCollection.new()
						data.self.SELF_ONESHOT.set_base_type(BASE_TYPE)
						data.self.SELF_ONESHOT.set_type_readonly(true)
					if _deduped(data.self.SELF_ONESHOT, _signal_item):
						data.self.SELF_ONESHOT.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_REFERENCE_COUNTED:
					if not self.has_self_reference_counted:  # init
						data.self.SELF_REFERENCE_COUNTED = ResourceCollection.new()
						data.self.SELF_REFERENCE_COUNTED.set_base_type(BASE_TYPE)
						data.self.SELF_REFERENCE_COUNTED.set_type_readonly(true)
					if _deduped(data.self.SELF_REFERENCE_COUNTED, _signal_item):
						data.self.SELF_REFERENCE_COUNTED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_DEFERRED:
					if not self.has_nonself_deferred:  # init
						data.nonself.NONSELF_DEFERRED = ResourceCollection.new()
						data.nonself.NONSELF_DEFERRED.set_base_type(BASE_TYPE)
						data.nonself.NONSELF_DEFERRED.set_type_readonly(true)
					if _deduped(data.nonself.NONSELF_DEFERRED, _signal_item):
						data.nonself.NONSELF_DEFERRED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_PERSIST:
					if not self.has_self_persist:  # init
						data.nonself.NONSELF_PERSIST = ResourceCollection.new()
						data.nonself.NONSELF_PERSIST.set_base_type(BASE_TYPE)
						data.nonself.NONSELF_PERSIST.set_type_readonly(true)
					if _deduped(data.nonself.NONSELF_PERSIST, _signal_item):
						data.nonself.NONSELF_PERSIST.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_ONESHOT:
					if not self.has_self_oneshot:  # init
						data.nonself.NONSELF_ONESHOT = ResourceCollection.new()
						data.nonself.NONSELF_ONESHOT.set_base_type(BASE_TYPE)
						data.nonself.NONSELF_ONESHOT.set_type_readonly(true)
					if _deduped(data.nonself.NONSELF_ONESHOT, _signal_item):
						data.nonself.NONSELF_ONESHOT.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_REFERENCE_COUNTED:
					if not self.has_self_reference_counted:  # init
						data.nonself.NONSELF_REFERENCE_COUNTED = ResourceCollection.new()
						data.nonself.NONSELF_REFERENCE_COUNTED.set_base_type(BASE_TYPE)
						data.nonself.NONSELF_REFERENCE_COUNTED.set_type_readonly(true)
					if _deduped(data.nonself.NONSELF_REFERENCE_COUNTED, _signal_item):
						data.nonself.NONSELF_REFERENCE_COUNTED.set(_signal_item.signal_name, _signal_item)
						added = true
				_:
					added = false
	return added


func _deduped(_signal_item_col: ResourceCollection, _signal_item: SignalItem):
	var props = _signal_item_col.get_property_list()
	var check_dupes = props.count() > 0
	var add_kvp = not check_dupes
	if check_dupes:
		var is_dupe = false
		while check_dupes:
			for p in props:
				if p == _signal_item.signal_name:
					is_dupe = true
				check_dupes = not is_dupe
			check_dupes = false
		add_kvp = not is_dupe
	return add_kvp


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
func _has(_has_items = false, _items = null, _signal_type = SignalTypes.SignalType.NONE):
	var has = false
	var has_amt_gt = _items != null && _items.get_property_list().count() > 0
	if not _has_items:
		match _signal_type:
			SignalTypes.SignalType.SELF_DEFERRED:
				data.state.has_self_deferred = has_amt_gt
				has = data.state.has_self_deferred
			SignalTypes.SignalType.SELF_PERSIST:
				data.state.has_self_persist = has_amt_gt
				has = data.state.has_self_persist
			SignalTypes.SignalType.SELF_ONESHOT:
				data.state.has_self_oneshot = has_amt_gt
				has = data.state.has_self_oneshot
			SignalTypes.SignalType.SELF_REFERENCE_COUNTED:
				data.state.has_self_reference_counted = has_amt_gt
				has = data.state.has_self_reference_counted
			SignalTypes.SignalType.NONSELF_DEFERRED:
				data.state.has_nonself_deferred = has_amt_gt
				has = data.state.has_nonself_deferred
			SignalTypes.SignalType.NONSELF_PERSIST:
				data.state.has_nonself_persist = has_amt_gt
				has = data.state.has_nonself_persist
			SignalTypes.SignalType.NONSELF_ONESHOT:
				data.state.has_nonself_oneshot = has_amt_gt
				has = data.state.has_nonself_oneshot
			SignalTypes.SignalType.NONSELF_REFERENCE_COUNTED:
				data.state.has_nonself_reference_counted = has_amt_gt
				has = data.state.has_nonself_reference_counted
			_:
				has = false
	else:
		has = true
	return has && self.initialized && self.enabled && not self.destroyed
