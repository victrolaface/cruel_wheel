class_name ResourceItemUtility


# public methods
static func init_paths_param(_paths = [], _path = ""):
	return _init_str_arr_param(_paths, _path, false, true)


static func init_class_names_param(_class_names = [], _class_name = ""):
	return _init_str_arr_param(_class_names, _class_name, true)


static func init_local_param(_local = true, _id = 0, _resource_local_to_scene = true):
	return true


static func init_id_param(_local = true, _id = 0):
	return 0


static func init_editor_only_param(_editor_only = false):
	return false


# private methods
static func _init_str_arr_param(_strs = [], _str = "", _validate_str = false, _validate_path = false):
	var str_valid = false
	var strs_valid = false
	var valid_strs_arr = []
	var strs_arr = []
	if PoolArrayUtility.has_items(_strs):
		var inval_idx = []
		var idx = 0
		for s in _strs:
			if _validate_str:
				str_valid = StringUtility.is_valid(s)
			elif _validate_path:
				str_valid = PathUtility.is_valid(s)
			if not str_valid:
				inval_idx.append(idx)
			idx = IntUtility.incr(idx)
		strs_valid = not PoolArrayUtility.has_items(inval_idx)
		if not strs_valid:
			valid_strs_arr = PoolArrayUtility.to_arr(_strs, "str")
			for i in inval_idx:
				valid_strs_arr.remove(i)
			strs_valid = PoolArrayUtility.has_items(valid_strs_arr)
			if strs_valid:
				_strs = valid_strs_arr
	if _validate_str:
		str_valid = StringUtility.is_valid(_str)
	elif _validate_path:
		str_valid = PathUtility.is_valid(_str)
	if strs_valid:
		if str_valid:
			strs_arr = PoolArrayUtility.to_arr(_strs, "str", true, _str)
		else:
			strs_arr = PoolArrayUtility.to_arr(_strs, "str", true)
	elif str_valid:
		strs_arr = PoolArrayUtility.to_arr([_str], "str")
	return strs_arr
