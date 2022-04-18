class_name SignalManager extends Resource

#export(int) var id setget , get_id
#export(String) var name setget , get_name
export(Resource) var manager setget , get_manager
export(String) var manager_name setget , get_manager_name
export(int) var manager_id setget , get_manager_id
export(Resource) var self_deferred setget , get_self_deferred
export(Resource) var self_persist setget , get_self_persist
export(Resource) var self_oneshot setget , get_self_oneshot
export(Resource) var self_reference_counted setget , get_self_reference_counted
export(Resource) var nonself_deferred setget , get_nonself_deferred
export(Resource) var nonself_persist setget , get_nonself_persist
export(Resource) var nonself_oneshot setget , get_nonself_oneshot
export(Resource) var nonself_reference_counted setget , get_nonself_reference_counted
#export(bool) var has_id setget , get_has_id
#export(bool) var has_name setget , get_has_name
export(bool) var has_manager setget , get_has_manager
export(bool) var has_manager_name setget , get_has_manager_name
export(bool) var has_manager_id setget , get_has_manager
export(bool) var has_self_deferred setget , get_has_self_deferred
export(bool) var has_self_persist setget , get_has_self_persist
export(bool) var has_self_oneshot setget , get_has_self_oneshot
export(bool) var has_self_reference_counted setget , get_has_self_reference_counted
export(bool) var has_nonself_deferred setget , get_has_nonself_deferred
export(bool) var has_nonself_persist setget , get_has_nonself_persist
export(bool) var has_nonself_oneshot setget , get_has_nonself_oneshot
export(bool) var has_nonself_reference_counted setget , get_has_nonself_reference_counted
#export(bool) var saved setget , get_saved
#export(bool) var initialized setget , get_initialized
#export(bool) var enabled setget , get_enabled
#export(bool) var destroyed setget , get_destroyed

const BASE_TYPE = "SignalItem"
var data: Dictionary
#var cached: EncodedObjectAsID


func _init(_manager: Object, _parent = null):
	resource_local_to_scene = true
	data = {
		"manager": null,
		"manager_name": "",
		"manager_id": 0,
		"self": {"deferred": null, "persist": null, "oneshot": null, "reference_counted": null}
	}

	#if IDUtility.object_is_valid(_manager):
	#	var mgr_id = _manager.get_instance_id()
	#	var mgr_name = _manager.get_class()
	#	data = {
	#		"manager":
	#mgr_name: {
	#}
	#	}

	data = {
		"manager": null,
		"manager_name": "",
		"manager_id": 0,
		"SELF_DEFERRED": null,
		"SELF_PERSIST": null,
		"SELF_ONESHOT": null,
		"SELF_REFERENCE_COUNTED": null,
		"NONSELF_DEFERRED": null,
		"NONSELF_PERSIST": null,
		"NONSELF_ONESHOT": null,
		"NONSELF_REFERENCE_COUNTED": null,
		"state":
		{
			"has_manager": false,
			"has_manager_name": false,
			"has_manager_id": false,
			"has_self_deferred": false,
			"has_self_persist": false,
			"has_self_oneshot": false,
			"has_self_reference_counted": false,
			"has_nonself_deferred": false,
			"has_nonself_persist": false,
			"has_nonself_oneshot": false,
			"has_nonself_reference_counted": false,
		}
	}
	"""
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
	
	"""


# public methods
"""
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
						data.SELF_DEFERRED = ResourceCollection.new()
						data.SELF_DEFERRED.set_base_type(BASE_TYPE)
						data.SELF_DEFERRED.set_type_readonly(true)
					if _deduped(data.SELF_DEFERRED, _signal_item):
						data.SELF_DEFERRED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_PERSIST:
					if not self.has_self_persist:  # init
						data.SELF_PERSIST = ResourceCollection.new()
						data.SELF_PERSIST.set_base_type(BASE_TYPE)
						data.SELF_PERSIST.set_type_readonly(true)
					if _deduped(data.SELF_PERSIST, _signal_item):
						data.SELF_PERSIST.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_ONESHOT:
					if not self.has_self_oneshot:  # init
						data.SELF_ONESHOT = ResourceCollection.new()
						data.SELF_ONESHOT.set_base_type(BASE_TYPE)
						data.SELF_ONESHOT.set_type_readonly(true)
					if _deduped(data.SELF_ONESHOT, _signal_item):
						data.SELF_ONESHOT.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.SELF_REFERENCE_COUNTED:
					if not self.has_self_reference_counted:  # init
						data.SELF_REFERENCE_COUNTED = ResourceCollection.new()
						data.SELF_REFERENCE_COUNTED.set_base_type(BASE_TYPE)
						data.SELF_REFERENCE_COUNTED.set_type_readonly(true)
					if _deduped(data.SELF_REFERENCE_COUNTED, _signal_item):
						data.SELF_REFERENCE_COUNTED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_DEFERRED:
					if not self.has_nonself_deferred:  # init
						data.NONSELF_DEFERRED = ResourceCollection.new()
						data.NONSELF_DEFERRED.set_base_type(BASE_TYPE)
						data.NONSELF_DEFERRED.set_type_readonly(true)
					if _deduped(data.NONSELF_DEFERRED, _signal_item):
						data.NONSELF_DEFERRED.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_PERSIST:
					if not self.has_self_persist:  # init
						data.NONSELF_PERSIST = ResourceCollection.new()
						data.NONSELF_PERSIST.set_base_type(BASE_TYPE)
						data.NONSELF_PERSIST.set_type_readonly(true)
					if _deduped(data.NONSELF_PERSIST, _signal_item):
						data.NONSELF_PERSIST.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_ONESHOT:
					if not self.has_self_oneshot:  # init
						data.NONSELF_ONESHOT = ResourceCollection.new()
						data.NONSELF_ONESHOT.set_base_type(BASE_TYPE)
						data.NONSELF_ONESHOT.set_type_readonly(true)
					if _deduped(data.NONSELF_ONESHOT, _signal_item):
						data.NONSELF_ONESHOT.set(_signal_item.signal_name, _signal_item)
						added = true
				SignalItemTypes.NONSELF_REFERENCE_COUNTED:
					if not self.has_self_reference_counted:  # init
						data.NONSELF_REFERENCE_COUNTED = ResourceCollection.new()
						data.NONSELF_REFERENCE_COUNTED.set_base_type(BASE_TYPE)
						data.NONSELF_REFERENCE_COUNTED.set_type_readonly(true)
					if _deduped(data.NONSELF_REFERENCE_COUNTED, _signal_item):
						data.NONSELF_REFERENCE_COUNTED.set(_signal_item.signal_name, _signal_item)
						added = true
				_:
					added = false
	return added
"""


# setters, getters functions
func get_manager():
	if self.has_manager:
		return data.manager


func get_manager_name():
	if self.has_manager_name:
		return data.manager_name


func get_manager_id():
	if self.has_manager_id:
		return data.manager_id


func get_has_manager():
	return data.state.has_manager


func get_has_manager_name():
	return data.state.has_manager_name


func get_has_manager_id():
	return data.state.has_manager_id


#func get_id():
#	if self.has_id:
#		return saved.object_id

#func get_name():
#	if self.has_name:
#		return data.name


func get_self_deferred():
	if self.has_self_deferred:
		return data.SELF_DEFERRED


func get_self_persist():
	if self.has_self_persist:
		return data.SELF_PERSIST


func get_self_oneshot():
	if self.has_self_oneshot:
		return data.SELF_ONESHOT


func get_self_reference_counted():
	if self.has_self_reference_counted:
		return data.SELF_REFERENCE_COUNTED


func get_nonself_deferred():
	if self.has_nonself_deferred:
		return data.NONSELF_DEFERRED


func get_nonself_persist():
	if self.has_nonself_persist:
		return data.NONSELF_PERSIST


func get_nonself_oneshot():
	if self.has_nonself_oneshot:
		return data.NONSELF_ONESHOT


func get_nonself_reference_counted():
	if self.has_nonself_reference_counted:
		return data.NONSELF_REFERENCE_COUNTED


#func get_has_id():
#	if not data.state.has_id && self.saved:
#		data.state.has_id = IDUtility.is_valid(saved.object_id)
#	return data.state.has_id

#func get_has_name():
#	if not data.state.has_name:
#		data.state.has_name = StringUtility.is_valid(data.name)
#	return data.state.has_name


func get_has_self_deferred():
	return _has(data.state.has_self_deferred, data.SELF_DEFERRED, SignalItemTypes.SignalType.SELF_DEFERRED)


func get_has_self_persist():
	return _has(data.state.has_self_persist, data.SELF_PERSIST, SignalItemTypes.SignalType.SELF_PERSIST)


func get_has_self_oneshot():
	return _has(data.state.has_self_oneshot, data.SELF_ONESHOT, SignalItemTypes.SignalType.SELF_ONESHOT)


func get_has_self_reference_counted():
	return _has(
		data.state.has_self_reference_counted, data.SELF_REFERENCE_COUNTED, SignalItemTypes.SignalType.SELF_REFERENCE_COUNTED
	)


func get_has_nonself_deferred():
	return _has(data.state.has_nonself_deferred, data.NONSELF_DEFERRED, SignalItemTypes.SignalType.NONSELF_DEFERRED)


func get_has_nonself_persist():
	return _has(data.state.has_nonself_persist, data.NONSELF_PERSIST, SignalItemTypes.SignalType.NONSELF_PERSIST)


func get_has_nonself_oneshot():
	return _has(data.state.has_nonself_oneshot, data.NONSELF_ONESHOT, SignalItemTypes.SignalType.NONSELF_ONESHOT)


func get_has_nonself_reference_counted():
	return _has(
		data.state.has_nonself_reference_counted,
		data.NONSELF_REFERENCE_COUNTED,
		SignalItemTypes.SignalType.NONSELF_REFERENCE_COUNTED
	)


#func get_saved():
#	return data.state.saved

#func get_initialized():
#	return data.state.initialized

#func get_enabled():
#	return data.state.enabled

#func get_destroyed():
#	return data.state.destroyed


# setters, getters helper functions
func _has(_has_items = false, _items = null, _signal_type = SignalItemTypes.SignalType.NONE):
	var has = false
	var has_amt_gt = _items != null && _items.get_property_list().count() > 0
	if not _has_items:
		match _signal_type:
			SignalItemTypes.SignalType.SELF_DEFERRED:
				data.state.has_self_deferred = has_amt_gt
				has = data.state.has_self_deferred
			SignalItemTypes.SignalType.SELF_PERSIST:
				data.state.has_self_persist = has_amt_gt
				has = data.state.has_self_persist
			SignalItemTypes.SignalType.SELF_ONESHOT:
				data.state.has_self_oneshot = has_amt_gt
				has = data.state.has_self_oneshot
			SignalItemTypes.SignalType.SELF_REFERENCE_COUNTED:
				data.state.has_self_reference_counted = has_amt_gt
				has = data.state.has_self_reference_counted
			SignalItemTypes.SignalType.NONSELF_DEFERRED:
				data.state.has_nonself_deferred = has_amt_gt
				has = data.state.has_nonself_deferred
			SignalItemTypes.SignalType.NONSELF_PERSIST:
				data.state.has_nonself_persist = has_amt_gt
				has = data.state.has_nonself_persist
			SignalItemTypes.SignalType.NONSELF_ONESHOT:
				data.state.has_nonself_oneshot = has_amt_gt
				has = data.state.has_nonself_oneshot
			SignalItemTypes.SignalType.NONSELF_REFERENCE_COUNTED:
				data.state.has_nonself_reference_counted = has_amt_gt
				has = data.state.has_nonself_reference_counted
			_:
				has = false
	else:
		has = true
	return has && self.initialized && self.enabled && not self.destroyed
