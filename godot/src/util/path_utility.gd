class_name PathUtility


static func is_valid(_path: String):
	return Directory.new().file_exists(_path)
