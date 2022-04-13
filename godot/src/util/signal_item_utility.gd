class_name SignalItemUtility


static func is_valid(_signal_item, valid = false):
	if _is_class_valid(_signal_item):
		var name_valid = StringUtility.is_valid(_signal_item.name)
		var method_valid = StringUtility.is_valid(_signal_item.method)
		var obj_valid = _signal_item.object_from != null && _signal_item.object_to != null
		var arg_valid = _signal_item.arguments.get_type() == "Array"
		var type_valid = is_valid_type(_signal_item.type, true)
		var flag_valid = is_valid_type(_signal_item.flags, false)
		if name_valid && method_valid && obj_valid && arg_valid && type_valid && flag_valid:
			valid = is_connect_valid(_signal_item)
	return valid


static func is_connect_valid(_i, valid = false):
	if _is_class_valid(_i):
		if is_connected_valid(_i):
			valid = true
		elif _i.object_from.connect(_i.name, _i.object_to, _i.method, _i.arguments, _i.connection_flags):
			if is_connected_valid(_i):
				_i.disconnect(_i.name, _i.object_to, _i.method)
				valid = true
	return valid


static func is_connected_valid(_i):
	return _i.get_class() == "SignalItem" && _i.object_from.is_connected(_i.name, _i.object_from, _i.method)


static func is_valid_type(_type, _is_signal_type, valid = false):
	var invalid_type = SignalTypes.invalid_signal_type()
	var valid_types = SignalTypes.valid_signal_types()
	if not _is_signal_type:
		invalid_type = SignalTypes.invalid_signal_flag_type()
		valid_types = SignalTypes.valid_signal_flag_types()
	if _type != invalid_type:
		var amt = valid_types.count()
		if amt > 0:
			var proc_type = true
			var idx = 0
			while proc_type:
				if _type == valid_types[idx]:
					valid = true
					proc_type = false
				if idx == amt - 1:
					proc_type = false
				idx = idx + 1
	return valid


static func _is_class_valid(_i):
	return _i.get_class() == "SignalItem"
