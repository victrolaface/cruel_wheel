class_name ResourceItemUtility


# public methods
static func item_is_valid(_item = null):
	return not _item == null


static func init_class_names(_new_class_names = [], _class_names = []):
	if _new_class_names.size() > 0 && _class_names.size() > 0:
		var amt = 0
		var idx = 0
		var inval_idx = PoolIntArray()
		inval_idx.clear()
		for n in _new_class_names:
			for c in _class_names:
				if n == c:
					var tmp = PoolIntArray(inval_idx)
					amt = amt + 1
					tmp.resize(amt)
					tmp.set(0, idx)
					inval_idx = PoolIntArray(tmp)
			idx = idx + 1
		if inval_idx.size() > 0:
			for i in inval_idx:
				var tmp = PoolStringArray(_new_class_names)
				tmp.remove(i)
				_new_class_names = PoolStringArray(tmp)
		if _new_class_names.size() > 0:
			var tmp = PoolStringArray()
			tmp.clear()
			amt = _class_names.size() + amt
			tmp.resize(amt)
			idx = 0
			for n in _new_class_names:
				tmp.set(idx, n)
				idx = idx + 1
			for c in _class_names:
				tmp.set(idx, c)
				idx = idx + 1
			_class_names.clear()
			amt = tmp.size()
			_class_names.resize(amt)
			_class_names = PoolStringArray(tmp)
	return _class_names


static func init_editor_only(_new_editor_only = false, _editor_only = false):
	var dif_new = _dif_ltr(_new_editor_only, _editor_only)
	var dif_init = _dif_fmr(_new_editor_only, _editor_only)
	return _new_editor_only if dif_new or dif_init else _editor_only


static func init_res_local(_local = true, _res_local = true):
	var dif_loc = _dif_ltr(_local, _res_local)
	var dif_res = _dif_fmr(_local, _res_local)
	return _local if dif_loc or dif_res else _res_local


static func init_res_path(_path = "", _res_path = "", _init_path = ""):
	var p_valid = _path_val(_path)
	var rp_valid = _path_val(_res_path)
	var ip_valid = _path_val(_init_path)
	var dif_path_val = _dif_ltr(p_valid, rp_valid)
	var dif_res_val = _dif_fmr(p_valid, rp_valid)
	var dif_init_val = not p_valid && not rp_valid && ip_valid
	var path = ""
	if dif_init_val or ip_valid:
		path = _init_path
	elif dif_path_val:
		path = _path
	elif dif_res_val:
		path = _res_path
	else:
		path = _init_path
	return path


static func init_path(_path = "", _init_path = ""):
	var p_valid = _path_val(_path)
	var ip_valid = _path_val(_init_path)
	var dif_init_val = _dif_fmr(p_valid, ip_valid)
	var path = ""
	if p_valid:
		path = _path
	if dif_init_val:
		path = _init_path
	elif p_valid:
		path = _path
	else:
		path = _init_path
	return path


# private helper methods
static func _dif_fmr(_fmr = false, _ltr = false):
	return not _fmr && _ltr


static func _dif_ltr(_fmr = false, _ltr = false):
	return _fmr && not _ltr


static func _path_val(_path = ""):
	return PathUtility.is_valid(_path)
