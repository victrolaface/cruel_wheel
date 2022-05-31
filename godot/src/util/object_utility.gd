class_name ObjectUtility


static func is_valid(_obj = null, _func = ""):
	return _obj_valid(_obj) if not StringUtility.is_valid(_func) else _obj_valid(_obj) && _obj.has_method(_func)


static func _obj_valid(_obj = null):
	return not _obj == null && typeof(_obj) == TYPE_OBJECT
