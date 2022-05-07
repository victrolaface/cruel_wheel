class_name StringUtility


static func is_valid(_str = ""):
	return not _str == "" && not _str == null && _str.get_type() == TYPE_STRING


static func from_arr_or_val(_arr = [], _val = "", _idx = 0):
	var _string = ""
	if PoolArrayUtility.has_items(_arr):
		var item = _arr[_idx]
		if is_valid(item):
			_string = item
	elif is_valid(_val):
		_string = _val
	return _string


static func to_str(_item = null):
	return String(_item)


static func on_cond(_cond = true, _str = ""):
	return "" if not _cond else _str


static func append_to_str(_str = "", _items = [], _val = ""):
	var _string = _init_str(_str)
	if PoolArrayUtility.has_items(_items):
		for i in _items:
			_string = _append_on_valid(_string, i)
	_string = _append_on_valid(_string, _val)
	return _string


static func _append_on_valid(_str = "", _val = ""):
	var _string = _init_str(_str)
	if is_valid(_val):
		_string = _string + _val
	return _string


static func _init_str(_str = ""):
	return "" if not is_valid(_str) else _str
