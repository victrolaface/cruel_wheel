class_name SignalItemUtility

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
	var objs_valid = not _obj_from == null && not _obj_to == null
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
	return _i != null && _i.get_class() == "SignalItem"

static func is_valid_type(_type):
	var valid = SignalItemTypes.valid_signal_types()
	var invalid = SignalItemTypes.invalid_signal_type()
	return _is_valid_type_or_flag(_type, valid,invalid)

static func is_valid_flags(_flags):
	var valid = SignalItemTypes.valid_signal_flag_types()
	var invalid = SignalItemTypes.invalid_signal_flag_type()
	return _is_valid_type_or_flag(_flags,valid,invalid)

static func _is_valid_type_or_flag(_i,_valid, _invalid):
	var valid = _i != _invalid#false
	if valid:
		var amt = _valid.count()
		if amt > 0:
			for v in _valid:
				valid = _i == v
				if valid:
					break
	return valid

"""
"""
	#l#is_valid_obj()
#static func is_valid(_signal_item, valid = false):
#	if _can_validate(_signal_item, valid):
#		var name_valid = StringUtility.is_valid(_signal_item.name)
#		var method_valid = StringUtility.is_valid(_signal_item.method)
#		var obj_valid = _signal_item.object_from != null && _signal_item.object_to != null
#		var arg_valid = _signal_item.arguments.get_type() == "Array"
#		var type_valid = is_valid_type(_signal_item.type, true)
#		var flag_valid = is_valid_type(_signal_item.flags, false)
#		if name_valid && method_valid && obj_valid && arg_valid && type_valid && flag_valid:
#			valid = is_connect_valid(_signal_item)
#	return valid

"""
static func is_connect_valid(_i, valid = false):
	if _can_validate(_i, valid):
		if on_is_connected(_i):
			valid = true
		elif on_connect(_i):
			if on_is_connected(_i):
				_i.disconnect(_i.name, _i.object_to, _i.method)
				valid = true
	return valid


static func on_is_connected(_i):
	return _i.object_from.is_connected(_i.name, _i.object_from, _i.method)


static func on_connect(_i):
	return _i.object_from.connect(_i.name, _i.object_to, _i.method, _i.arguments, _i.connection_flags)



"""

#static func _can_validate(_i, _validated):
#	return not _validated && _is_class_valid(_i)

