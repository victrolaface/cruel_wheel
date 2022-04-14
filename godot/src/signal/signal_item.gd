tool
class_name SignalItem extends Item

export(int) var type setget , get_type
export(String) var signal_name setget , get_signal_name
export(Resource) var object_from setget , get_object_from
export(Resource) var object_to setget , get_object_to
export(String) var method setget , get_method
export(Array) var arguments setget , get_arguments
export(int) var flags setget , get_flags
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
	_type = SignalItemTypes.signal_type_none,
	_obj_from = null,
	_obj_to = null,
	_method = "",
	_args = [],
	_flags = SignalItemTypes.signal_flag_type_none
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
		"state":
		{
			"connected": false,
			"has_type": false,
			"has_name": false,
			"has_object_from": false,
			"has_object_to": false,
			"has_arguments": false,
			"has_arguments_dirty": true,
			"has_flags": false
		}
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
	if not data.state.has_type:
		data.state.has_type = SignalItemUtility.is_valid_type(data.type, true)
	return data.state.has_type


func get_has_signal_name():
	if not data.state.has_signal_name:
		data.state.has_signal_name = StringUtility.is_valid(data.name)
	return data.state.has_signal_name


func get_has_object_from():
	if not data.state.has_object_from:
		data.state.has_object_from = data.object_from != null
	return data.state.has_object_from


func get_has_object_to():
	if not data.state.has_object_to:
		data.state.has_object_to = data.object_to != null
	return data.state.has_object_to


func get_has_method():
	if not data.state.has_method:
		data.state.has_method = StringUtility.is_valid(data.method)
	return data.state.has_method


func get_has_arguments():
	if not data.state.has_arguments && data.state.has_arguments_dirty:
		data.state.has_arguments = data.arguments.count() > 0
		data.state.has_arguments_dirty = false
	return data.state.has_arguments


func get_has_flags():
	if not data.state.has_flags:
		data.state.has_flags = SignalItemUtility.is_valid_type(data.flags, false)
	return data.state.has_flags


func get_connected():
	return data.state.connected
