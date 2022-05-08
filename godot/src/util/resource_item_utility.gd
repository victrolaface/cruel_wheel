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


static func _init_str_arr_param(_strs = [], _str = "", _validate_str = false, _validate_path = false, _rids = [], _rid = 0):
	var str_valid = false
	var strs_valid = false
	var valid_strs_arr = []
	var strs_arr = []
	var has_items = false
	var has_rid = valid_id(_rid)
	var has_rids = _rids.size() > 0 or has_rid
	var items = []
	var item = ""
	var idx = 0
	if has_rids:
		var tmp = PoolStringArray()
		tmp.empty()
		tmp.resize(_rids.size())
		for r in _rids:
			if valid_id(r):
				tmp[idx] = String(r)
			idx = IntUtility.incr(idx)
		if tmp.size() > 0:
			items = tmp
			has_items = has_rids
		if has_rid:
			item = String(_rid)
	else:
		has_items = _strs.size() > 0
		items = _strs
		item = _str
	if has_items:
		idx = 0
		var inval_idx = []
		for s in items:
			if _validate_str:
				str_valid = StringUtility.is_valid(s)
			elif _validate_path:
				str_valid = PathUtility.is_valid(s)
			if not str_valid:
				inval_idx.append(idx)
			idx = IntUtility.incr(idx)
		strs_valid = not inval_idx.size() > 0
		if not strs_valid:
			valid_strs_arr = PoolArrayUtility.to_arr(items, "str")
			for i in inval_idx:
				valid_strs_arr.remove(i)
			strs_valid = valid_strs_arr.size() > 0
			if strs_valid:
				items = valid_strs_arr
	if _validate_str:
		str_valid = StringUtility.is_valid(item)
	elif _validate_path:
		str_valid = PathUtility.is_valid(item)
	if strs_valid:
		if str_valid:
			strs_arr = PoolArrayUtility.to_arr(items, "str", true, _str)
		else:
			strs_arr = PoolArrayUtility.to_arr(items, "str", true)
	elif str_valid:
		strs_arr = PoolArrayUtility.to_arr([item], "str")
	return strs_arr
