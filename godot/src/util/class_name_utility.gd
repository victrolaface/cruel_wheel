class_name ClassNameUtility


static func is_class_name(_class = "", _name = "", _base_class_names = []):
	return _class == _name && _is_base_class(_class, _base_class_names)


static func init_base_class_names(_has_name = false, _name = "", _base_class_names = []):
	if _has_name:
		var is_base_class = _is_base_class(_name, _base_class_names)
		if not is_base_class:
			_base_class_names.append(_name)
	return _base_class_names


static func _is_base_class(_name = "", _base_class_names = []):
	var is_base_class = false
	for n in _base_class_names:
		is_base_class = _name == n
		if is_base_class:
			break
	return is_base_class
