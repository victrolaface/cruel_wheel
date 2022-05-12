class_name PoolArrayUtility

# fields
enum _ITEM_TYPE { NONE = 0, BYTE = 1, CLR = 2, INT = 3, REAL = 4, STR = 5, VEC2 = 6, VEC3 = 7 }


# public methods
static func init(_type_str = ""):
	var arr = null
	var type = _type_from_str(_type_str)
	if not type == _ITEM_TYPE.NONE:
		arr = _init_from_type(type)
	return arr


static func to_arr(_from = [], _item_type_str = "", _dedupe = false, _val = null):
	var type = _init_type_from_str_or_val(_from, _val, _item_type_str)
	var arr = _from
	if not type == _ITEM_TYPE.NONE:
		arr = _to_arr(_from, type, _dedupe, _val)
	return arr


static func add(_arr = [], _val = null, _item_type_str = ""):
	return to_arr(_arr, "", false, _val)


static func cast_to(_from = [], _type_to = "", _type_fr = ""):
	var from_type = _type_from_str(_type_fr) if not _type_from_str(_type_fr) == _ITEM_TYPE.NONE else _type_from_arr(_from)
	var arr = _from
	if _has_items(_from) && from_type == _ITEM_TYPE.INT && _type_from_str(_type_to) == _ITEM_TYPE.STR:
		var tmp_int_arr = to_arr(_from, "int")
		var tmp_str_arr = init(_ITEM_TYPE.STR)
		var idx = 0
		tmp_str_arr.resize(tmp_int_arr.size())
		for i in tmp_int_arr:
			tmp_str_arr[idx] = String(i)
			idx = IntUtility.incr(idx)
		arr = to_arr(tmp_str_arr, "str")
	return arr


# private helper methods
static func _has_items(_items = []):
	return _items.size() > 0


static func _init_from_type(_type = _ITEM_TYPE.NONE):
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


static func _init_type_from_str_or_val(_arr = [], _val = null, _item_type_str = ""):
	var val_type = _type_from_val(_val)
	var type_from_str = _type_from_str(_item_type_str)
	var has_val_type = ObjectUtility.is_valid(_val) && not val_type == _ITEM_TYPE.NONE
	var has_type_from_str = StringUtility.is_valid(_item_type_str) && not type_from_str == _ITEM_TYPE.NONE
	var proc_type = true
	var curr_type = _ITEM_TYPE.NONE
	var type = _ITEM_TYPE.NONE
	while proc_type:
		if not has_type_from_str:
			if has_val_type:
				curr_type = val_type
		elif has_val_type:
			proc_type = type_from_str == val_type
			curr_type = type_from_str
		if _has_items(_arr) && not curr_type == _ITEM_TYPE.NONE:  #has_val_type or has_type_from_str:
			proc_type = _type_from_arr(_arr) == curr_type
			type = curr_type
		proc_type = false
	return type


static func _type_from_val(_val = null):
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
				is_type = StringUtility.is_valid(_val)
			_ITEM_TYPE.VEC2:
				is_type = typeof(_val) == TYPE_VECTOR2 or typeof(_val) == TYPE_TRANSFORM2D
			_ITEM_TYPE.VEC3:
				is_type = typeof(_val) == TYPE_VECTOR3 or typeof(_val) == TYPE_TRANSFORM
		if is_type:
			type = t
			break
	return type


static func _type_from_arr(_from = []):
	var type = _ITEM_TYPE.NONE
	if _has_items(_from):
		var first = true
		var type_is_none = false
		var init_type = _ITEM_TYPE.NONE
		var curr_type = _ITEM_TYPE.NONE
		for i in _from:
			if first:
				init_type = _type_from_val(i)
				if not init_type == _ITEM_TYPE.NONE:
					first = not first
					continue
				else:
					type_is_none = true
					break
			curr_type = _type_from_val(i)
			if curr_type == init_type:
				continue
			else:
				type_is_none = true
				break
		type = init_type if not type_is_none else type
	return type


static func _type_from_str(_item_type = ""):
	var type = _ITEM_TYPE.NONE
	if StringUtility.is_valid(_item_type):
		match _item_type:
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


static func _to_arr(_from = [], _type = _ITEM_TYPE.NONE, _dedupe = false, _val = null):
	var idx = 0
	var amt = idx + 1
	var tmp = _init_from_type(_type)
	var arr = _from
	if ObjectUtility.is_valid(_val):
		tmp.resize(amt)
		tmp[idx] = _val
	if _has_items(_from):
		amt = tmp.size() + _from.size()
		tmp.resize(amt)
		for i in _from:
			tmp[idx] = i
			idx = IntUtility.incr(idx)
	if _dedupe:
		var inval_idx = init("int")
		var comp = tmp
		var c_idx = 0
		inval_idx.empty()
		idx = 0
		amt = 0
		for c in comp:
			for t in tmp:
				if c_idx == idx:
					continue
				if c == t:
					amt = IntUtility.incr(amt)
					inval_idx.resize(amt)
					inval_idx[0] = c_idx
				idx = IntUtility.incr(idx)
			c_idx = IntUtility.incr(c_idx)
		if _has_items(inval_idx):
			for i in inval_idx:
				tmp.remove(i)
	if _has_items(tmp):
		arr = _init_from_type(_type)
		amt = tmp.size()
		arr.resize(amt)
		idx = 0
		for i in tmp:
			arr[idx] = i
			idx = IntUtility.incr(idx)
	return arr
