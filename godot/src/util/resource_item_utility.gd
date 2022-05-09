class_name ResourceItemUtility

# fields
const _SEPERATOR = "-"
const _GLOBAL_ID = "global"


# public methods
static func init_params(
	_class_names = [],
	_class_name = "",
	_rids = [],
	_rid = 0,
	_id = 0,
	_local = true,
	_res_loc_to_scene = true,
	_paths = [],
	_path = ""
):
	var params = {
		"paths": PoolStringArray(),
		"class_names": PoolStringArray(),
		"rids": PoolStringArray(),
		"local": true,
		"id": 0,
		"name": "",
		"can_enable": false,
	}

	params.paths = _init_str_arr_param(_paths, _path, false, true)
	params.class_names = _init_str_arr_param(_class_names, _class_name, true)
	params.rids = _init_str_arr_param([], "", true, false, _rids, _rid)
	params.local = _local if _local && valid_id(_id) && _res_loc_to_scene else false
	params.id = _id if params.local else 0
	if params.class_names.size() > 0 && params.rids.size() > 0:
		params.name = params.class_names[0] + _SEPERATOR + params.rids[0] + _SEPERATOR
		var id = ""
		if params.local:
			id = String(params.id)
		else:
			id = _GLOBAL_ID
		params.name = params.name + id
	var local_id_valid = valid_id(params.id) && params.local
	if not local_id_valid:
		local_id_valid = params.id == 0 && not params.local
	params.can_enable = (
		params.class_names.size() > 0
		&& params.class_names.size() > 0
		&& params.rids.size() > 0
		&& local_id_valid
	)
	params = params if params.can_enable else {}
	return params


static func init_parent(_class_names = [], _class_name = "", _rids = [], _rid = 0, _id = 0, _paths = [], _path = ""):
	var params = {
		"class_names": PoolStringArray(),
		"paths": PoolStringArray(),
		"rids": PoolIntArray(),
	}
	params.class_names = _init_str_arr_param(_class_names, _class_name, true)
	params.paths = _init_str_arr_param(_paths, _path, false, true)
	var tmp = PoolArrayUtility.to_arr(_rids, "int", true, _rid)
	if tmp.size() > 0:
		params.rids = tmp
	return params


static func valid_id(_id = 0):
	return _id > 0


static func is_valid(_res_itm = null):
	var name_valid = false
	var local_valid = false
	var path_valid = false
	var class_valid = false
	if not _res_itm == null && _res_itm.enabled:
		if _res_itm.has_path:
			var path = _res_itm.path
			path_valid = PathUtility.is_valid(path) && _res_itm.resource_path == path
		var class_name_str = _res_itm.get_class()
		class_valid = StringUtility.is_valid(class_name_str) && _res_itm.is_class("ResourceItem")
		if class_valid && _res_itm.has_name:
			var rid_str = String(_res_itm.get_rid())
			var name = class_name_str + _SEPERATOR + rid_str + _SEPERATOR
			if _res_itm.local && _res_itm.has_id:
				var id_str = String(_res_itm.id)
				name = name + id_str
				local_valid = _res_itm.resource_local_to_scene
			elif not _res_itm.local:
				name = name + _GLOBAL_ID
				local_valid = not _res_itm.resource_local_to_scene
			name_valid = _res_itm.name == name && _res_itm.resource_name == name
	return path_valid && class_valid && local_valid && name_valid


# private helper methods
static func _init_str_arr_param(_strs = [], _str = "", _validate_str = false, _validate_path = false, _rids = [], _rid = 0):
	var has_items = false
	var items = PoolArrayUtility.init_arr("str")
	var inval_idx = PoolArrayUtility.init_arr("int")
	var has_rid = valid_id(_rid)
	var has_rids_arr = _rids.size() > 0
	var idx = 0
	var amt = 0
	if has_rids_arr or has_rid:
		var can_cast_rids_to_str = false
		var tmp = PoolArrayUtility.init_arr("int")
		if has_rid && has_rids_arr:
			tmp = PoolArrayUtility.to_arr(_rids, "int", true, _rid)
		elif has_rid && not has_rids_arr:
			tmp = PoolArrayUtility.to_arr([], "int", false, _rid)
		elif not has_rid && has_rids_arr:
			tmp = PoolArrayUtility.to_arr(_rids, "int", true)
		if tmp.size() > 0:
			if tmp.size() == 1:
				can_cast_rids_to_str = valid_id(tmp[0])
			elif tmp.size() > 1:
				var comp = tmp
				var c_idx = 0
				for c in comp:
					for t in tmp:
						if c_idx == idx:
							continue
						elif c == t or not valid_id(c):
							amt = IntUtility.incr(amt)
							inval_idx.resize(amt)
							inval_idx[0] = c_idx
						idx = IntUtility.incr(idx)
					c_idx = IntUtility.incr(c_idx)
				if amt > 0:
					for i in inval_idx:
						tmp.remove(i)
				can_cast_rids_to_str = tmp.size() > 0
		if can_cast_rids_to_str:
			tmp = PoolArrayUtility.cast_to(tmp, "str", "int")
			has_items = tmp.size() > 0
			if has_items:
				items = tmp
	else:
		var tmp = PoolArrayUtility.init_arr("str")
		var tmp_is_valid = false
		var has_str = StringUtility.is_valid(_str)
		var has_strs_arr = _strs.size() > 0
		if has_str && has_strs_arr:
			tmp = PoolArrayUtility.to_arr(_strs, "str", true, _str)
		elif has_str && not has_strs_arr:
			tmp = PoolArrayUtility.to_arr([], "str", false, _str)
		elif not has_str && has_strs_arr:
			tmp = PoolArrayUtility.to_arr(_strs, "str", true)
		amt = tmp.size()
		if amt > 0:
			if amt == 1:
				if _validate_str:
					tmp_is_valid = StringUtility.is_valid(tmp[0])
				elif _validate_path:
					tmp_is_valid = PathUtility.is_valid(tmp[0])
			else:
				amt = 0
				idx = 0
				for i in tmp:
					if _validate_str:
						tmp_is_valid = StringUtility.is_valid(i)
					elif _validate_path:
						tmp_is_valid = PathUtility.is_valid(i)
					if not tmp_is_valid:
						amt = IntUtility.incr(amt)
						inval_idx.resize(amt)
						inval_idx[0] = idx
					idx = IntUtility.incr(idx)
				tmp_is_valid = amt == 0
				if not tmp_is_valid:
					for i in inval_idx:
						tmp.remove(i)
					tmp_is_valid = tmp.size() > 0
				has_items = tmp_is_valid
				if has_items:
					items = tmp
	return items
