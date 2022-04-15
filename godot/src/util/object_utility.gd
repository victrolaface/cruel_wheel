class_name ObjectUtility


static func is_valid(_obj: Object):
	var id = _obj.get_instance_id()
	var name = _obj.get_class()
	return not _obj == null && EntityUtility.is_id_valid(id) && StringUtility.is_valid(name)
