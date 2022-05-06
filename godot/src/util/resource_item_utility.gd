class_name ResourceItemUtility


# public methods
static func init_paths_param(_paths = [], _path = ""):
	return _init_str_arr_param(_paths, _path, false, true)


static func init_class_names_param(_class_names = [], _class_name = ""):
	return _init_str_arr_param(_class_names, _class_name, true)


static func init_local_param(_local = true, _id = 0, _res_loc_to_scene = true):
	return false if _valid_global(_local, _id, _res_loc_to_scene) else _valid_local(_local, _id, _res_loc_to_scene)


static func init_id_param(_local = true, _id = 0, _res_loc_to_scene = true):
	var id = 0
	if _valid_local(_local, _id, _res_loc_to_scene):
		id = _id
	elif _valid_global(_local, _id, _res_loc_to_scene):
		id = id
	return id


static func init_name_param(_local = true, _id = 0, _res_loc_to_scene = true, _rid = 0, _class_names = [], _class_item_name = ""):
	var name = ""
	if PoolArrayUtility.has_items(_class_names):
		var first_class_name = _class_names[0]
		if StringUtility.is_valid(first_class_name):
			name = first_class_name
	elif StringUtility.is_valid(_class_item_name):
		name = _class_item_name
	name = name + "-"
	if _valid_id(_rid):
		name = name + String(_rid) + "-"
	if _valid_local(_local, _id, _res_loc_to_scene):
		name = name + String(_id)
	elif _valid_global(_local, _id, _res_loc_to_scene):
		name = name + "global"
	return name


static func can_enable(_res_itm = null, _paths = [], _class_names = [], _local = true, _id = 0, _name = ""):
	var init_valid = false
	return init_valid && is_valid(_res_itm)


static func is_valid(_res_itm = null):
	return false


# private helper methods
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


static func _valid_global(_local = true, _id = 0, _res_loc_to_scene = true):
	return not _local && _id == 0 && not _res_loc_to_scene


static func _valid_local(_local = true, _id = 0, _res_loc_to_scene = true):
	return _local && _valid_id(_id) && _res_loc_to_scene


static func _valid_id(_id = 0):
	return _id > 0

#static func _init_name(_class_names = [], _class_item_name = ""):
#	var name = ""
#
#	return name
