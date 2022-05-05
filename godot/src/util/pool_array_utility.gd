class_name PoolArrayUtility

# fields
enum _ITEM_TYPE { NONE = 0, BYTE = 1, CLR = 2, INT = 3, REAL = 4, STR = 5, VEC2 = 6, VEC3 = 7 }


# public methods
static func to_arr(_from = [], _item_type_str = "", _dedupe = false, _val = null):
	var tmp = []
	var arr = []
	var idx = 0
	var amt = 0
	var has_from_arr = has_items(_from)
	var from_arr_type = _ITEM_TYPE.NONE
	var val_type = _type(_val)
	var has_val = not _val == null && not val_type == _ITEM_TYPE.NONE
	var has_item_type_str = not _type_from_str(_item_type_str) == _ITEM_TYPE.NONE
	var can_init = true
	var init_type = _ITEM_TYPE.NONE
	var type = _ITEM_TYPE.NONE
	var init_not_type = false
	if has_from_arr:
		for i in _from:
			if init_type == _ITEM_TYPE.NONE:
				init_type = _type(i)
				var init_type_is_none = init_type == _ITEM_TYPE.NONE
				has_from_arr = _has_or_init(init_type_is_none)
				can_init = _has_or_init(init_type_is_none)
				if _cannot_init(has_from_arr, can_init):
					break
				else:
					from_arr_type = init_type
			else:
				type = _type(i)
				init_not_type = _init_not_type(init_type, type)
				has_from_arr = _has_or_init(init_not_type)
				can_init = _has_or_init(init_not_type)
				if _cannot_init(has_from_arr, can_init):
					break
		if has_val:
			init_type = _type(_val)
			init_not_type = _init_not_type(init_type, type)
			has_from_arr = _has_or_init(init_not_type)
			has_val = _has_or_init(init_not_type)
			can_init = _has_or_init(init_not_type)
		if has_item_type_str:
			init_type = _type_from_str(_item_type_str)
			init_not_type = _init_not_type(init_type, type)
			has_from_arr = _has_or_init(init_not_type)
			can_init = _has_or_init(init_not_type)
	if has_val && not has_from_arr:
		if has_item_type_str:
			init_type = _type(_val)
			type = _type_from_str(_item_type_str)
			init_not_type = _init_not_type(init_type, type)
			has_val = _has_or_init(init_not_type)
			can_init = _has_or_init(init_not_type)
	if can_init:
		type = _ITEM_TYPE.NONE
		if has_from_arr:
			type = from_arr_type
		if not has_from_arr && has_val:
			type = val_type
		tmp = _init_tmp_arr(type)
		if _can_set_arr(tmp):
			if has_val:
				amt = tmp.size() + 1
				tmp.resize(amt)
				tmp[idx] = _val
			if has_from_arr:
				amt = tmp.size() + _from.size()
				tmp.resize(amt)
				for i in _from:
					tmp[idx] = i
					idx = IntUtility.incr(idx)
			arr = tmp
			if _dedupe:
				tmp = arr
				idx = 0
				var tmp_idx = idx
				var inval_idx = []
				for i in arr:
					for t in tmp:
						if not idx == tmp_idx && i == t:
							inval_idx.append(idx)
						tmp_idx = IntUtility.incr(tmp_idx)
					idx = IntUtility.incr(idx)
				if has_items(inval_idx):
					for i in inval_idx:
						arr.remove(i)
					if has_items(arr):
						amt = arr.size()
						tmp = _init_tmp_arr(type)
						if _can_set_arr(tmp):
							tmp.resize(amt)
							idx = 0
							for i in arr:
								tmp[idx] = i
								idx = IntUtility.incr(idx)
							arr = tmp
	return arr


static func has_items(_items = []):
	return _items.size() > 0


static func has_duplicates(_init_items = [], _items = []):
	var has = false
	if has_items(_init_items) && has_items(_items):
		for ini in _init_items:
			for i in _items:
				has = i == ini
				if has:
					break
	return has


static func int_incr_array(_size = 0, _starting_val = 0):
	var arr = []
	if _size > 0:
		var idx = 0
		var val = _starting_val if not _starting_val == 0 else 0
		var incrm = true
		while incrm:
			arr[idx] = val
			val = IntUtility.incr(val)
			idx = IntUtility.incr(idx)
			incrm = false if idx + 1 == _size else incrm
		if has_items(arr):
			var tmp = PoolIntArray()
			tmp.empty()
			tmp.resize(_size)
			idx = 0
			for i in arr:
				tmp[idx] = i
				idx = IntUtility.incr(idx)
			arr = tmp
	return arr


# private helper methods
static func _has_or_init(_cond = false):
	var has_or_init = true
	if _cond:
		has_or_init = false
	return has_or_init


static func _cannot_init(_has_from_arr = true, _can_init = true):
	return not _has_from_arr && not _can_init


static func _init_not_type(_init_type = _ITEM_TYPE.NONE, _type = _ITEM_TYPE.NONE):
	return not _init_type == _type


static func _init_tmp_arr(_type = _ITEM_TYPE.NONE):
	var tmp = null
	match _type:
		_ITEM_TYPE.BYTE:
			tmp = PoolByteArray()
		_ITEM_TYPE.CLR:
			tmp = PoolColorArray()
		_ITEM_TYPE.INT:
			tmp = PoolIntArray()
		_ITEM_TYPE.REAL:
			tmp = PoolRealArray()
		_ITEM_TYPE.STR:
			tmp = PoolStringArray()
		_ITEM_TYPE.VEC2:
			tmp = PoolVector2Array()
		_ITEM_TYPE.VEC3:
			tmp = PoolVector3Array()
	if not tmp == null:
		tmp.empty()
	return tmp


static func _can_set_arr(_tmp = null):
	return not _tmp == null


static func _type(_val = null):
	var type = _ITEM_TYPE.NONE
	var is_type = false
	for t in _ITEM_TYPE:
		if t == _ITEM_TYPE.NONE:
			continue
		match t:
			_ITEM_TYPE.BYTE:
				is_type = (typeof(_val) == TYPE_INT && _val == 0 or _val == 1) or typeof(_val) == TYPE_BOOL
			_ITEM_TYPE.CLR:
				is_type = typeof(_val) == TYPE_COLOR
			_ITEM_TYPE.INT:
				is_type = typeof(_val) == TYPE_INT
			_ITEM_TYPE.REAL:
				is_type = typeof(_val) == TYPE_REAL
			_ITEM_TYPE.STR:
				is_type = StringUtility.is_valid(_val) && typeof(_val) == TYPE_STRING
			_ITEM_TYPE.VEC2:
				is_type = typeof(_val) == TYPE_VECTOR2 or typeof(_val) == TYPE_TRANSFORM2D
			_ITEM_TYPE.VEC3:
				is_type = typeof(_val) == TYPE_VECTOR3 or typeof(_val) == TYPE_TRANSFORM
		if is_type:
			type = t
			break
	return type


static func _type_from_str(_item_type_str = ""):
	var type = _ITEM_TYPE.NONE
	if StringUtility.is_valid(_item_type_str):
		match _item_type_str:
			"byt":
				type = _ITEM_TYPE.BYTE
			"byte":
				type = _ITEM_TYPE.BYTE
			"clr":
				type = _ITEM_TYPE.CLR
			"color":
				type = _ITEM_TYPE.CLR
			"int":
				type = _ITEM_TYPE.INT
			"flt":
				type = _ITEM_TYPE.REAL
			"flt32":
				type = _ITEM_TYPE.REAL
			"float":
				type = _ITEM_TYPE.REAL
			"float32":
				type = _ITEM_TYPE.REAL
			"rl":
				type = _ITEM_TYPE.REAL
			"rl32":
				type = _ITEM_TYPE.REAL
			"real":
				type = _ITEM_TYPE.REAL
			"real32":
				type = _ITEM_TYPE.REAL
			"str":
				type = _ITEM_TYPE.STR
			"string":
				type = _ITEM_TYPE.STR
			"vec2":
				type = _ITEM_TYPE.VEC2
			"vector2":
				type = _ITEM_TYPE.VEC2
			"vector2D":
				type = _ITEM_TYPE.VEC2
			"transform2D":
				type = _ITEM_TYPE.VEC2
			"vec":
				type = _ITEM_TYPE.VEC3
			"vec3":
				type = _ITEM_TYPE.VEC3
			"vector3":
				type = _ITEM_TYPE.VEC3
			"vector3D":
				type = _ITEM_TYPE.VEC3
			"transform":
				type = _ITEM_TYPE.VEC3
			"transform3D":
				type = _ITEM_TYPE.VEC3
			_:
				type = _ITEM_TYPE.NONE
	return type
