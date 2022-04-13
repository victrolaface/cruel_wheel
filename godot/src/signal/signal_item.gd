tool
class_name SignalItem extends Item

enum SignalType {
	NONE = 0,
	SELF_DEFERRED = 1,
	SELF_PERSIST = 2,
	SELF_ONESHOT = 3,
	SELF_REFERENCE_COUNTED = 4,
	NONSELF_DEFERRED = 5,
	NONSELF_PERSIST = 6,
	NONSELF_ONESHOT = 7,
	NONSELF_REFERENCE_COUNTED = 8
}

enum SignalFlagType {
	NONE = 0,
	CONNECT_DEFERRED = 1,
	CONNECT_PERSIST = 2,
	CONNECT_ONESHOT = 4,
	CONNECT_REFERENCE_COUNTED = 8
}

export(SignalType) var type setget , get_type
export(String) var signal_name setget , get_signal_name
export(Resource) var object_from setget , get_object_from
export(Resource) var object_to setget , get_object_to
export(String) var method setget , get_method
export(Array) var arguments setget , get_arguments
export(SignalFlagType) var flags setget , get_flags
export(bool) var connected setget , get_connected
export(bool) var has_type setget , get_has_type
export(bool) var has_signal_name setget , get_has_signal_name
export(bool) var has_object_from setget , get_has_object_from
export(bool) var has_object_to setget , get_has_object_to
export(bool) var has_method setget , get_has_method
export(bool) var has_arguments setget , get_has_arguments
export(bool) var has_flags setget , get_has_flags

var data: Dictionary


func _init(
	_signal_name = "",
	_type = SignalType.NONE,
	_obj_from = null,
	_obj_to = null,
	_method = "",
	_args = [],
	_flags = SignalFlagType.NONE
):
	resource_local_to_scene = true
	data = {
		"name": _signal_name,
		"type": _type,
		"object_from": _obj_from,
		"object_to": _obj_to,
		"method": _method,
		"arguments": _args,
		"flags": _flags,
		"state": {"connected": false}
	}
	var _connected = false
	var _name = "SignalItem"
	if self.has_signal_name:
		_name = _name + "-" + data.name
		if self.has_type && self.has_object_from && self.has_object_to && self.has_method && self.has_flags:
			_connected = SignalItemUtility.is_connect_valid(self)
	data.connected = _connected
	name = _name
	cached = self
	initialized = self.connected
	enabled = initialized
	destroyed = not enabled && not initialized


# setters, getters functions
func get_type():
	if self.has_type:
		return data.type


func get_signal_name():
	if self.has_signal_name:
		return data.signal_name


func get_object_from():
	if self.has_object_from:
		return data.object_from


func get_object_to():
	if self.has_object_to:
		return data.object_to


func get_method():
	if self.has_method:
		return data.method


func get_arguments():
	if self.has_arguments:
		return data.arguments


func get_flags():
	if self.has_flags:
		return data.flags


func get_has_type():
	return true
	#return _is_valid_type(data.type, SignalType.NONE, VALID_SIGNAL_TYPES)


func get_has_signal_name():
	return StringUtility.is_valid(data.name)


func get_has_object_from():
	return data.object_from != null


func get_has_object_to():
	return data.object_to != null


func get_has_method():
	return StringUtility.is_valid(data.method)


func get_has_arguments():
	return data.arguments.count() > 0


func get_has_flags():
	return true
	#return _is_valid_type(data.flags, SignalFlagType.NONE, VALID_SIGNAL_FLAG_TYPES)


func get_exists():
	return data.state.exists


func get_connected():
	return data.state.connected
