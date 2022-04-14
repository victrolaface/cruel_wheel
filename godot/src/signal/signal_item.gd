tool
class_name SignalItem extends Item

export(String) var signal_name setget , get_signal_name
export(int) var type setget , get_type
export(Resource) var object_from setget , get_object_from
export(Resource) var object_to setget , get_object_to
export(int) var object_from_id setget , get_object_from_id
export(int) var object_to_id setget , get_object_to_id
export(String) var method setget , get_method
export(Array) var arguments setget , get_arguments
export(int) var flags setget , get_flags
export(bool) var has_signal_name setget , get_has_signal_name
export(bool) var has_type setget , get_has_type
export(bool) var has_object_from setget , get_has_object_from
export(bool) var has_object_to setget , get_has_object_to
export(bool) var has_object_from_id setget , get_has_object_from_id
export(bool) var has_object_to_id setget , get_has_object_to_id
export(bool) var has_method setget , get_has_method
export(bool) var has_arguments setget , get_has_arguments
export(bool) var has_flags setget , get_has_flags
export(bool) var connected setget , get_connected

var data: Dictionary


func _init(
	_parent = null,
	_signal_name = "",
	_type = SignalItemTypes.signal_type_none,
	_obj_from = null,
	_obj_to = null,
	_method = "",
	_arguments = [],
	_flags = SignalItemTypes.signal_flag_type_none
):
	resource_local_to_scene = true
	data = {
		"signal_name": "",
		"type": SignalItemTypes.signal_type_none,
		"object_from": null,
		"object_to": null,
		"object_from_id": 0,
		"object_to_id": 0,
		"method": "",
		"arguments": [],
		"flags": SignalItemTypes.signal_flag_type_none,
		"state":
		{
			"has_signal_name": false,
			"has_type": false,
			"has_object_from": false,
			"has_object_to": false,
			"has_object_from_id": false,
			"has_object_to_id": false,
			"has_method": false,
			"has_arguments": false,
			"has_flags": false,
			"connected": false,
		}
	}
	var valid = SignalItemUtility.is_params_valid(_signal_name, _type, _obj_from, _obj_to, _method, _arguments, _flags)
	if valid:
		data.signal_name = _signal_name
		data.type = _type
		data.object_from = _obj_from
		data.object_to = _obj_to
		data.object_from_id = data.object_from.get_instance_id()
		data.object_to_id = data.object_to.get_instance_id()
		data.method = _method
		data.arguments = _arguments
		data.flags = _flags
		data.state.has_signal_name = valid
		data.state.has_type = valid
		data.state.has_object_from = valid
		data.state.has_object_to = valid
		data.state.has_object_from_id = valid
		data.state.has_object_to_id = valid
		data.state.has_method = valid
		data.state.has_arguments = valid && data.arguments.count() > 0
		data.state.has_flags = valid
		on_connected()
		valid = data.state.connected
	ref_self = self
	ref_parent = _parent
	initialized = valid
	enabled = valid
	destroyed = not valid


# public methods
func on_connected():
	data.state.connected = data.object_from.is_connected(data.signal_name, data.object_to, data.method)
	if not data.state.connected:
		data.state.connected = data.object_from.connect(
			data.signal_name, data.object_to, data.method, data.arguments, data.flags
		)


# setters, getters functions
func get_signal_name():
	if self.has_signal_name:
		return data.signal_name


func get_type():
	if self.has_type:
		return data.type


func get_object_from():
	if self.has_object_from:
		return data.object_from


func get_object_to():
	if self.has_object_to:
		return data.object_to


func get_object_from_id():
	if self.has_object_from_id:
		return data.object_from_id


func get_object_to_id():
	if self.has_object_to_id:
		return data.object_to_id


func get_method():
	if self.has_method:
		return data.method


func get_arguments():
	return data.arguments


func get_flags():
	if self.has_flags:
		return data.flags


func get_has_signal_name():
	return data.state.has_signal_name


func get_has_type():
	return data.state.has_type


func get_has_object_from():
	return data.state.has_object_from


func get_has_object_to():
	return data.state.has_object_to


func get_has_object_from_id():
	return data.state.has_object_from_id


func get_has_object_to_id():
	return data.state.has_object_to_id


func get_has_method():
	return data.state.has_method


func get_has_arguments():
	return data.state.has_arguments


func get_has_flags():
	return data.state.has_flags


func get_connected():
	if not data.state.connected:
		on_connected()
	return data.state.connected
