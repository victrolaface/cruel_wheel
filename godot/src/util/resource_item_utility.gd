class_name ResourceItemUtility

# fields
const _SEPERATOR = "-"
const _GLOBAL_ID = "global"


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


static func init_name_param(_local = true, _id = 0, _res_loc_to_scene = true, _rid = 0, _cl_names = [], _cl_name = ""):
	var name = StringUtility.from_arr_or_default(_cl_names, _cl_name)
	name = StringUtility.append_to_str(name, [_SEPERATOR])
	if _valid_id(_rid):
		var rid_str = StringUtility.to_str(_rid)
		name = StringUtility.append_to_str(name, [rid_str, _SEPERATOR])
	if _valid_local(_local, _id, _res_loc_to_scene):
		var id_str = StringUtility.to_str(_id)
		name = StringUtility.append_to_str(name, [id_str])
	elif _valid_global(_local, _id, _res_loc_to_scene):
		name = StringUtility.append_to_str(name, [_GLOBAL_ID])
	return name


static func can_enable(_res_itm = null, _paths = [], _path = "", _cl_names = [], _cl_name = "", _loc = true, _id = 0, _name = ""):
	var name_str = ""
	var path_valid = false
	var name_valid = false
	var local_valid = false
	var id_valid = false
	if not _res_itm == null:
		var rid_str = StringUtility.to_str(_res_itm.get_rid())
		var path_str = StringUtility.from_arr_or_default(_paths, _path)
		var class_name_str = StringUtility.from_arr_or_default(_cl_names, _cl_name)
		path_valid = _res_itm.resource_path == path_str
		local_valid = _res_itm.resource_local_to_scene == _loc
		name_str = StringUtility.append_to_str(name_str, [class_name_str, _SEPERATOR, rid_str])
		if _loc && local_valid:
			id_valid = _valid_id(_id)
			if id_valid:
				var id_str = StringUtility.to_str(_id)
				name_str = StringUtility.append_to_str(name_str, [_SEPERATOR, id_str])
		else:
			id_valid = _valid_global_id(_id)
		var res_name = _res_itm.resource_name
		name_valid = res_name == name_str && res_name == _name && name_str == _name
	return path_valid && name_valid && id_valid && local_valid


static func is_valid(_res_itm = null):
	var name_valid = false
	var local_valid = false
	var path_valid = false
	var class_valid = false  #not _res_itm == null
	if not _res_itm == null && _res_itm.enabled:
		if _res_itm.has_path:
			var path = _res_itm.path
			path_valid = PathUtility.is_valid(path) && _res_itm.resource_path == path
		var class_name_str = _res_itm.get_class()
		class_valid = StringUtility.is_valid(class_name_str) && _res_itm.is_class("ResourceItem")
		if class_valid && _res_itm.has_name:
			var rid_str = StringUtility.to_str(_res_itm.get_rid())
			var name = StringUtility.append_to_str(class_name_str, [_SEPERATOR, rid_str, _SEPERATOR])
			if _res_itm.local && _res_itm.has_id:
				var id_str = StringUtility.to_str(_res_itm.id)
				name = StringUtility.append_to_str(name, [id_str])
				local_valid = _res_itm.resource_local_to_scene
			elif not _res_itm.local:
				name = StringUtility.append_to_str(name, [_GLOBAL_ID])
				local_valid = not _res_itm.resource_local_to_scene
			name_valid = StringUtility.is_valid(name) && _res_itm.name == name && _res_itm.resource_name == name
	return path_valid && class_valid && local_valid && name_valid


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
	return not _local && _valid_global_id(_id) && not _res_loc_to_scene


static func _valid_global_id(_id):
	return _id == 0


static func _valid_local(_local = true, _id = 0, _res_loc_to_scene = true):
	return _local && _valid_id(_id) && _res_loc_to_scene


static func _valid_id(_id = 0):
	return _id > 0
