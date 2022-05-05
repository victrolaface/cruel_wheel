class_name ResourceItemUtility


# public methods
static func init_paths_param(_paths = [], _path = ""):
	var path_valid = _path_valid(_path)
	var paths_arr = []
	var valid_paths_arr = []
	var paths_valid = false
	if PoolArrayUtility.has_items(_paths):
		var inval_idx = []
		var idx = 0
		for p in _paths:
			paths_valid = PathUtility.is_valid(p)
			if not paths_valid:
				inval_idx.append(idx)
			idx = IntUtility.incr(idx)
		paths_valid = not PoolArrayUtility.has_items(inval_idx)
		if not paths_valid:
			valid_paths_arr = PoolArrayUtility.to_arr(_paths, "str")
			for i in inval_idx:
				valid_paths_arr.remove(i)
			if PoolArrayUtility.has_items(valid_paths_arr):
				_paths = valid_paths_arr
	if PoolArrayUtility.has_items(_paths):
		if path_valid:
			paths_arr = PoolArrayUtility.to_arr(_paths, "str", true, _path)
		else:
			paths_arr = PoolArrayUtility.to_arr(_paths, "str", true)
	elif path_valid:
		paths_arr = PoolArrayUtility.to_arr([_path], "str")
	return paths_arr


static func init_class_names_param(_init_class_name = "", _class_names = []):
	return []


static func init_local_param(_local = true, _id = 0):
	return true


static func init_id_param(_local = true, _id = 0):
	return 0


static func init_editor_only_param(_editor_only = false):
	return false


# private methods
static func _path_valid(_path = ""):
	return PathUtility.is_valid(_path)

#var has_init_name = _has_str(_init_class_name)#_has_items(_init_class_names)
#var has_names = _has_items(_class_names)
#var has_both_names = has_init_name && has_names# && #_has_items(_init_class_names)
#var names = _init_arr("str", not has_init_name, _init_class_name)#PoolStringArray([]) if not has_init_name else PoolStringArray(_init_class_name)
#if has_class_names:
#	if has_names:
#	if PoolArrayUtility.has_duplicates(_init_class_names, _class_names):
#		pass
#_has_duplicates(_init_class_names, _class_names):

#	if has_init_names:
#var duplicate_idx = PoolIntArray()
#return names

#static func _has_str(_str=""):
#	return StringUtility.is_valid(_str)

#static func _init_arr(_type="", _cond=false, _default_val=[])
#	var type = PoolArray

#s#tatic func _has_items(_items = []):
#	return PoolArrayUtility.has_items(_items)

#static func _add_item(_arr = [], _val = null, _type = ""):
#	return PoolArrayUtility.add_item(_arr, _val, _type)#type)

#static func _incr(_amt = 0):
#	return IntUtility.incr(_amt)

#func init_class_names(_class_names = [], _init_class_names = []):
#	if _class_names.size() > 0 && _init_class_names.size() > 0:
#		var amt = 0
#		var idx = 0
#		var inval_idx = PoolIntArray()
#		inval_idx.clear()
#		for c in _class_names:
#			for i in _init_class_names:
#				if c == i:
#					var tmp = PoolIntArray(inval_idx)
#					amt = amt + 1
#					tmp.resize(amt)
#					tmp.set(0, idx)
#					inval_idx = PoolIntArray(tmp)
#			idx = idx + 1
#		if inval_idx.size() > 0:
#			for i in inval_idx:
#				var tmp = PoolStringArray(_class_names)
#				tmp.remove(i)
#				_class_names = PoolStringArray(tmp)
#		if _class_names.size() > 0:
#			var tmp = PoolStringArray()
#			tmp.clear()
#			amt = _init_class_names.size() + amt
#			tmp.resize(amt)
#			idx = 0
#			for c in _class_names:
#				tmp.set(idx, c)
#				idx = idx + 1
#			for i in _init_class_names:
#				tmp.set(idx, i)
#				idx = idx + 1
#			_init_class_names.clear()
#			amt = tmp.size()
#			_init_class_names.resize(amt)
#			_init_class_names = PoolStringArray(tmp)
#	return _init_class_names

#static func _has_items(_items = []):
#	return _items.size() > 0

#static func _add_item(_arr = [], _val = null, _type = _ITEM_TYPE):
#	var tmp = _arr
#	var amt = tmp.size()
#	amt = IntUtility.incr(amt)
#	tmp.resize(amt)
#	tmp.set(0, _val)
#	match _type:
#		_ITEM_TYPE.STR:
#			tmp = PoolStringArray(tmp)
#		_ITEM_TYPE.INT:
#			tmp = PoolIntArray(tmp)
#	return tmp

#static func _valid_path(_path = ""):
#	return PathUtility.is_valid(_path)
