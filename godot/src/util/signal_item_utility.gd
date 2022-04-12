tool
class_name SignalItemUtility extends Resource


static func is_valid(_i: SignalItem):
	var valid = false
	var str_valid = StringUtility.is_valid(_i.name) && StringUtility.is_valid(_i.method)
	var obj_valid = _i.object_from != null && _i.object_to != null
	var arg_valid = _i.arguments.get_type() == "Array"
	var flag_valid = _i.connection_flags == Object.CONNECT_ONESHOT || _i.connection_flags == Object.CONNECT_DEFERRED
	var self_type = _i.type == "SELF_ONESHOT" || _i.type == "SELF_DEFERRED"
	var nonself_type = _i.type == "NONSELF_ONESHOT" || _i.type == "NONSELF_DEFERRED"
	var type_valid = self_type || nonself_type
	if str_valid && obj_valid && arg_valid && flag_valid && type_valid:
		if not _is_connected(_i):
			if _i.object_from.connect(_i.name, _i.object_to, _i.method, _i.arguments, _i.connection_flags):
				if _is_connected(_i):
					_i.object_from.disconnect(_i.name, _i.object_to, _i.method)
					valid = true
		else:
			valid = true
	return valid


static func _is_connected(_i: SignalItem):
	return _i.object_from.is_connected(_i.name, _i.object_from, _i.method)
