class_name SignalsTable extends Resource

export(Resource) var deferred setget , get_deferred
export(Resource) var persist setget , get_persist
export(Resource) var oneshot setget , get_oneshot
export(Resource) var reference_counted setget , get_reference_counted
export(bool) var has_deferred setget , get_has_deferred
export(bool) var has_persist setget , get_has_persist
export(bool) var has_oneshot setget , get_has_oneshot
export(bool) var has_reference_counted setget , get_has_reference_counted

var data: Dictionary
const BASE_TYPE = "SignalItem"


func _init():
	resource_local_to_scene = true
	data = {
		"deferred": null,
		"persist": null,
		"oneshot": null,
		"reference_counted": null,
		"state": {"has_deferred": false, "has_persist": false, "has_oneshot": false, "has_reference_counted": false}
	}
	data.deferred = ResourceCollection.new()
	data.deferred.resource_local_to_scene = true
	data.deferred.set_base_type(BASE_TYPE)
	data.deferred.set_type_readonly(true)
	data.state.has_deferred = true
	data.persist = ResourceCollection.new()
	data.persist.resource_local_to_scene = true
	data.persist.set_base_type(BASE_TYPE)
	data.persist.set_type_readonly(true)
	data.state.has_persist = true
	data.oneshot = ResourceCollection.new()
	data.oneshot.resource_local_to_scene = true
	data.oneshot.set_base_type(BASE_TYPE)
	data.oneshot.set_type_readonly(true)
	data.state.has_oneshot = true
	data.reference_counted = ResourceCollection.new()
	data.reference_counted.resource_local_to_scene = true
	data.reference_counted.set_base_type(BASE_TYPE)
	data.reference_counted.set_type_readonly(true)
	data.state.has_reference_counted = true


# public methods
func add(_signal_item: SignalItem, _validated = false):
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
		if add_deferred:
			added = _add_deferred(_signal_item)
		elif add_persist:
			added = _add_persist(_signal_item)
		elif add_oneshot:
			added = _add_oneshot(_signal_item)
		elif add_reference_counted:
			added = _add_reference_counted(_signal_item)
	return added


func _add_deferred(_i):
	return true


func _add_persist(_i):
	return true


func _add_oneshot(_i):
	return true


func _add_reference_counted(_i):
	return true

	#signal_item)


"""
func added(_signal_item: SignalItem, _validated = false):
    var added = false
    if not _validated:
        _validated = SignalItemUtility.is_valid(_signal_item)
	if _signal_item.connected && _validated:#on_connected() && _validated:
        match _signal_item.type:
            SignalItemTypes.SELF_DEFERRED || SignalItemTypes.NONSELF_DEFERRED:
                added = true
            _:
                added = false
    return added
"""

#var connected = SignalItemUtility.on_is_connected(_signal_item)
#if not connected:
#	connected = SignalItemUtility.on_connect(_signal_item)
"""
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
func get_deferred():
	return data.deferred


func get_persist():
	return data.persist


func get_oneshot():
	return data.oneshot


func get_reference_counted():
	return data.reference_counted


func get_has_deferred():
	return data.state.has_deferred


func get_has_persist():
	return data.state.has_persist


func get_has_oneshot():
	return data.state.has_oneshot


func get_has_reference_counted():
	return data.state.has_reference_counted
