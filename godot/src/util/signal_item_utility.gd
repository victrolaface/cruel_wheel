class_name SignalItemUtility


static func is_valid(_signal_item: SignalItem):
	return (
		_is_class_valid(_signal_item)
		&& is_params_valid(
			_signal_item.signal_name,
			_signal_item.type,
			_signal_item.object_from,
			_signal_item.object_to,
			_signal_item.method,
			_signal_item.arguments,
			_signal_item.flags
		)
	)


static func is_params_valid(
	_signal_name = "",
	_type = SignalItemTypes.signal_type_none,
	_obj_from = null,
	_obj_to = null,
	_method = "",
	_arguments = [],
	_flags = SignalItemTypes.signal_flag_type_none
):
	var valid = false
	var name_valid = StringUtility.is_valid(_signal_name)
	var type_valid = is_valid_type(_type)
	var objs_valid = IDUtility.object_is_valid(_obj_from) && IDUtility.object_is_valid(_obj_to)
	var flags_valid = is_valid_flags(_flags)
	var can_connect = name_valid && type_valid && objs_valid && flags_valid
	if can_connect:
		valid = _obj_from.is_connected(_signal_name, _obj_to, _method)
		if not valid:
			valid = _obj_from.connect(_signal_name, _obj_to, _method, _arguments, _flags)
		if valid:
			_obj_from.disconnect(_signal_name, _obj_to, _method)
	return valid


static func _is_class_valid(_i):
	return _i.get_class() == "SignalItem" && IDUtility.object_is_valid(_i)


static func is_valid_type(_type):
	var valid = SignalItemTypes.valid_signal_types()
	var invalid = SignalItemTypes.invalid_signal_type()
	return _is_valid_type_or_flag(_type, valid, invalid)


static func is_valid_flags(_flags):
	var valid = SignalItemTypes.valid_signal_flag_types()
	var invalid = SignalItemTypes.invalid_signal_flag_type()
	return _is_valid_type_or_flag(_flags, valid, invalid)


static func _is_valid_type_or_flag(_i, _valid, _invalid):
	var valid = _i != _invalid  #false
	if valid:
		var amt = _valid.count()
		if amt > 0:
			for v in _valid:
				valid = _i == v
				if valid:
					break
	return valid
