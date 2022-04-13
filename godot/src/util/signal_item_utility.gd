class_name SignalItemUtility

const INVALID_SIGNAL_TYPE = SignalItem.SignalType.NONE
const INVALID_FLAG_TYPE = SignalItem.SignalType.NONE

const VALID_SIGNAL_TYPES = [
	SignalItem.SignalType.SELF_DEFERRED,
	SignalItem.SignalType.SELF_PERSIST,
	SignalItem.SignalType.SELF_ONESHOT,
	SignalItem.SignalType.SELF_REFERENCE_COUNTED,
	SignalItem.SignalType.NONSELF_DEFERRED,
	SignalItem.SignalType.NONSELF_PERSIST,
	SignalItem.SignalType.NONSELF_ONESHOT,
	SignalItem.SignalType.NONSELF_REFERENCE_COUNTED
]

const VALID_SIGNAL_FLAG_TYPES = [
	SignalItem.SignalFlagType.CONNECT_DEFERRED,
	SignalItem.SignalFlagType.CONNECT_PERSIST,
	SignalItem.SignalFlagType.CONNECT_ONESHOT,
	SignalItem.SignalFlagType.CONNECT_REFERENCE_COUNTED
]


static func is_valid(_signal_item: SignalItem):
	var valid = false
	var name_valid = StringUtility.is_valid(_signal_item.name)
	var method_valid = StringUtility.is_valid(_signal_item.method)
	var obj_valid = _signal_item.object_from != null && _signal_item.object_to != null
	var arg_valid = _signal_item.arguments.get_type() == "Array"
	var type_valid = _is_valid_type(_signal_item.type, INVALID_SIGNAL_TYPE, VALID_SIGNAL_TYPES)
	var flag_valid = _is_valid_type(_signal_item.flags, INVALID_FLAG_TYPE, VALID_SIGNAL_FLAG_TYPES)
	if name_valid && method_valid && obj_valid && arg_valid && type_valid && flag_valid:
		valid = is_connect_valid(_signal_item)
	return valid


static func is_connect_valid(_i: SignalItem):
	var valid = false
	if is_connected_valid(_i):
		valid = true
	elif _i.object_from.connect(_i.name, _i.object_to, _i.method, _i.arguments, _i.connection_flags):
		if is_connected_valid(_i):
			_i.disconnect(_i.name, _i.object_to, _i.method)
			valid = true
	return valid


static func is_connected_valid(_signal_item: SignalItem):
	return _signal_item.object_from.is_connected(_signal_item.name, _signal_item.object_from, _signal_item.method)


static func _is_valid_type(_type: int, _invalid_type: int, _valid_types = []):
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
