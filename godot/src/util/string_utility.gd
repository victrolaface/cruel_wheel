class_name StringUtility


static func is_valid(_str = ""):
	return not _str == null && not _str == "" && _str.get_type() == TYPE_STRING
