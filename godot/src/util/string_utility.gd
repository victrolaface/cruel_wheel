class_name StringUtility


static func is_valid(_str = ""):
	return not _str == null && not _str == "" && typeof(_str) == TYPE_STRING
