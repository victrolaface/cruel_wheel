class_name ClassNameUtility


# public methods
static func is_class_name(_class_name = "", _class_names = []):
	var has_class_name = false
	for n in _class_names:
		has_class_name = n == _class_name
		if has_class_name:
			break
	return has_class_name
