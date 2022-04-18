"""
class_name SignalsTable extends Item

export(Resource) var deferred setget , get_deferred
export(Resource) var persist setget , get_persist
export(Resource) var oneshot setget , get_oneshot
export(Resource) var reference_counted setget , get_reference_counted
export(Resource) var ref_manager setget , get_ref_manager
export(int) var manager_id setget , get_manager_id
export(bool) var has_manager setget , get_has_manager
export(bool) var has_manager_id setget , get_has_manager_id
export(bool) var has_deferred setget , get_has_deferred
export(bool) var has_persist setget , get_has_persist
export(bool) var has_oneshot setget , get_has_oneshot
export(bool) var has_reference_counted setget , get_has_reference_counted

var data: Dictionary
const BASE_TYPE = "SignalItem"


func _init(_manager: Object, _parent: Object):
	resource_local_to_scene = true
	data = {
		"ref_manager": null,
		"manager_id": 0,
		"deferred": null,
		"persist": null,
		"oneshot": null,
		"reference_counted": null,
		"deferred_amt": 0,
		"persist_amt": 0,
		"oneshot_amt": 0,
		"reference_counted_amount": 0,
		"state":
		{
			"has_manager": false,
			"has_manager_id": false,
			"has_deferred": false,
			"has_persist": false,
			"has_oneshot": false,
			"has_reference_counted": false
		}
	}
	data.has_manager = IDUtility.object_is_valid(_manager)
	if data.has_manager:
		data.ref_manager = _manager
		data.manager_id = _manager.get_instance_id()
		data.has_manager_id = data.has_manager
	ref_self = self
	ref_parent = _parent
	initialized = data.has_manager

# public methods
func add(_signal_item, _validated = false):
	var added = false
	if not _validated:
		_validated = SignalItemUtility.is_valid(_signal_item)
	if _validated && _signal_item.connected:
		var add_deferred = (
			_signal_item.type == SignalItemTypes.SignalType.SELF_DEFERRED
			|| _signal_item.type == SignalItemTypes.SignalType.NONSELF_DEFERRED
		)
		var add_persist = (
			_signal_item.type == SignalItemTypes.SignalType.SELF_PERSIST
			|| _signal_item.type == SignalItemTypes.SignalType.NONSELF_PERSIST
		)
		var add_oneshot = (
			_signal_item.type == SignalItemTypes.SignalType.SELF_ONESHOT
			|| _signal_item.type == SignalItemTypes.SignalType.NONSELF_ONESHOT
		)
		var add_reference_counted = (
			_signal_item.type == SignalItemTypes.SignalType.SELF_REFERENCE_COUNTED
			|| _signal_item.type == SignalItemTypes.SignalType.NONSELF_REFERENCE_COUNTED
		)
		var replace_duplicate = false
		var props = []
		if add_deferred:
			if not self.has_deferred:
				data.deferred = ResourceCollection.new()
				data.deferred.resource_local_to_scene = true
				data.deferred.set_base_type(BASE_TYPE)
				data.deferred.set_type_readonly(true)
				data.state.has_deferred = true
			props = data.deferred.get_property_list()
			if props.count() > 0:
				for p in props:
					replace_duplicate = _signal_item.signal_name == p
					if replace_duplicate:
						data.deferred.set(p, _signal_item)
						added = true
						break
			if not replace_duplicate:
				data.deferred.set(_signal_item.signal_name, _signal_item)
				added = true
		elif add_persist:
			if not self.has_persist:
				data.persist = ResourceCollection.new()
				data.persist.resource_local_to_scene = true
				data.persist.set_base_type(BASE_TYPE)
				data.persist.set_type_readonly(true)
				data.state.has_persist = true
			props = data.persist.get_property_list()
			if props.count() > 0:
				for p in props:
					replace_duplicate = _signal_item.signal_name == p
					if replace_duplicate:
						data.persist.set(p, _signal_item)
						added = true
						break
			if not replace_duplicate:
				data.persist.set(_signal_item.signal_name, _signal_item)
				added = true
		elif add_oneshot:
			if not self.has_oneshot:
				data.oneshot = ResourceCollection.new()
				data.oneshot.resource_local_to_scene = true
				data.oneshot.set_base_type(BASE_TYPE)
				data.oneshot.set_type_readonly(true)
				data.state.has_oneshot = true
			props = data.oneshot.get_property_list()
			if props.count() > 0:
				for p in props:
					replace_duplicate = _signal_item.signal_name == p
					if replace_duplicate:
						data.oneshot.set(p, _signal_item)
						added = true
						break
			if not replace_duplicate:
				data.oneshot.set(_signal_item.signal_name, _signal_item)
				added = true
		elif add_reference_counted:
			if not self.has_reference_counted:
				data.reference_counted = ResourceCollection.new()
				data.reference_counted.resource_local_to_scene = true
				data.reference_counted.set_base_type(BASE_TYPE)
				data.reference_counted.set_type_readonly(true)
				data.state.has_reference_counted = true
			props = data.reference_counted.get_property_list()
			if props.count() > 0:
				for p in props:
					replace_duplicate = _signal_item.signal_name == p
					if replace_duplicate:
						data.reference_counted.set(p, _signal_item)
						added = true
						break
			if not replace_duplicate:
				data.reference_counted.set(_signal_item.signal_name, _signal_item)
				added = true
	return added


# setters, getters functions
func get_ref_manager():
	if self.has_manager:
		return data.manager


func get_manager_id():
	if self.has_manager_id:
		return data.manager_id


func get_deferred():
	return data.deferred


func get_persist():
	return data.persist


func get_oneshot():
	return data.oneshot


func get_reference_counted():
	return data.reference_counted


func get_has_manager():
	return data.state.has_manager


func get_has_manager_id():
	return data.state.has_manager_id


func get_has_deferred():
	return data.state.has_deferred


func get_has_persist():
	return data.state.has_persist


func get_has_oneshot():
	return data.state.has_oneshot


func get_has_reference_counted():
	return data.state.has_reference_counted
"""
