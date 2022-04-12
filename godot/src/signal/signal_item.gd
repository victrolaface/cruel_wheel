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

const VALID_SIGNAL_TYPES = [
	SignalType.SELF_DEFERRED,
	SignalType.SELF_PERSIST,
	SignalType.SELF_ONESHOT,
	SignalType.SELF_REFERENCE_COUNTED,
	SignalType.NONSELF_DEFERRED,
	SignalType.NONSELF_ONESHOT,
	SignalType.NONSELF_ONESHOT,
	SignalType.NONSELF_REFERENCE_COUNTED
]

const VALID_TYPES = [
	SignalFlagType.CONNECT_DEFERRED,
	SignalFlagType.CONNECT_PERSIST,
	SignalFlagType.CONNECT_ONESHOT,
	SignalFlagType.CONNECT_REFERENCE_COUNTED
]

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
			_connected = data.object_from.is_connected(data.name, data.object_to, data.method)
			if not _connected:
				_connected = data.object_from.connect(data.name, data.object_to, data.method, data.args, data.flags)
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
	return _is_type(data.type, SignalType.NONE, VALID_SIGNAL_TYPES)


func get_has_signal_name():
	return StringUtility.is_valid(data.name)


func get_has_object_from():
	return data.object_from != null


func get_has_object_to():
	return data.object_to != null


func get_has_method():
	return StringUtility.is_valid(data.method)


func get_has_arguments():
	return data.arguments.count() > 0 || data.arguments.get_class() == "Array"


func get_has_flags():
	return _is_type(data.flags, SignalFlagType.NONE, VALID_TYPES)


func get_exists():
	return data.state.exists


func get_connected():
	return data.state.connected


# setters, getters helper functions
func _is_type(_type: int, _invalid_type: int, _valid_types = []):
	var is_type = false
	if _type != _invalid_type:
		var amt = _valid_types.count()
		if amt > 0:
			var proc_type = true
			var idx = 0
			while proc_type:
				if _type == _valid_types[idx]:
					is_type = true
					proc_type = false
				if idx == amt - 1:
					proc_type = false
				idx = idx + 1
	return is_type
