class_name PathUtility


static func is_valid(_path: String):
	return StringUtility.is_valid(_path) && Directory.new().file_exists(_path)
