class_name ClassNameUtility


# public methods
static func is_class_name(_class_name = "", _class_names = []):
	var has_class_name = false
	for n in _class_names:
		has_class_name = n == _class_name
		if has_class_name:
			break
	return has_class_name


static func class_names(_new_class_names = [], _class_names = []):
	var new_class_names_amt = _class_names.size()
	if _new_class_names.size() > 0 && new_class_names_amt > 0:
		var amt = 0
		var idx = 0
		var tmp_idx = 0
		var inval_indexes = PoolIntArray()
		inval_indexes.clear()
		for n in _new_class_names:
			for b in _class_names:
				if n == b:
					var tmp = PoolIntArray(inval_indexes)
					amt = amt + 1
					tmp.resize(amt)
					tmp.set(tmp_idx, idx)
					tmp_idx = tmp_idx + 1
					inval_indexes = PoolIntArray(tmp)
			idx = idx + 1
		if inval_indexes.size() > 0:
			for index in inval_indexes:
				var tmp = PoolStringArray(_new_class_names)
				tmp.remove(index)
				_new_class_names = PoolStringArray(tmp)
		amt = _new_class_names.size()
		if amt > 0:
			idx = 0
			var tmp = _class_names
			amt = new_class_names_amt + amt
			tmp.resize(amt)
			for n in _new_class_names:
				tmp.set(idx, n)
				idx = idx + 1
			_class_names = tmp
	return _class_names
