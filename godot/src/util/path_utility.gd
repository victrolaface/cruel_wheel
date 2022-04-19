class_name PathUtility


static func is_valid(_path: String):
	return StringUtility.is_valid(_path) && Directory.new().file_exists(_path)


static func is_valid_copy(_path, _path_compare):
	return is_valid(_path) && is_valid(_path_compare) && _path == _path_compare
