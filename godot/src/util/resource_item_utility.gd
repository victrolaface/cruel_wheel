class_name ResourceItemUtility


# public methods
static func local_to_scene(_local = false, _res_local = false):
	var local = _local && not _res_local
	var not_local = not local && _res_local
	return _local if local or not_local else not _local


static func name(_name = "", _res_name = ""):
	var name = _name_is_valid(_name)
	var res_name = _name_is_valid(_res_name)
	var ret = ""
	if name && not res_name:
		ret = _name
	elif not name && res_name:
		ret = _res_name
	return ret


static func path(_path = "", _res_path = "", _res_name = ""):
	var res_name = _name_is_valid(_res_name)
	var ret = ""
	if res_name && _path_is_valid(_res_path):
		ret = _res_path
	elif not res_name && _path_is_valid(_path):
		ret = _path
	return ret


static func item_is_valid(_item = null):
	return not _item == null


# private helper methods
static func _name_is_valid(_name = ""):
	return StringUtility.is_valid(_name)


static func _path_is_valid(_path = ""):
	return PathUtility.is_valid(_path)
