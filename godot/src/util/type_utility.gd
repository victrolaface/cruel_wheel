class_name TypeUtility


# public methods
static func is_built_in_type(_val = null):
	var val_type = typeof(_val)
	var is_type = false
	if not _val == null:
		for t in _types():
			if _cont_built_in_type_check(t, val_type):
				continue
			elif _stop_built_in_type_check(t, val_type):
				break
	return is_type


static func is_class_type(_val = null, _class_name = ""):
	var _is_class = false
	if not _val == null && StringUtility.is_valid(_class_name):
		_is_class = _val.is_class(_class_name)
	return _is_class


static func built_in_type(_val = null):
	var type = TYPE_NIL
	var val_type = typeof(_val)
	if is_built_in_type(_val):
		for t in _types():
			if _cont_built_in_type_check(t, val_type):
				continue
			elif _stop_built_in_type_check(t, val_type):
				if not val_type == TYPE_NIL:
					type = t
	return type


static func is_type_object(_val = null):
	return typeof(_val) == TYPE_OBJECT


# private helper methods
static func _types():
	return [
		TYPE_NIL,
		TYPE_BOOL,
		TYPE_INT,
		TYPE_REAL,
		TYPE_STRING,
		TYPE_VECTOR2,
		TYPE_RECT2,
		TYPE_VECTOR3,
		TYPE_TRANSFORM2D,
		TYPE_PLANE,
		TYPE_QUAT,
		TYPE_AABB,
		TYPE_BASIS,
		TYPE_TRANSFORM,
		TYPE_COLOR,
		TYPE_NODE_PATH,
		TYPE_RID,
		TYPE_OBJECT,
		TYPE_DICTIONARY,
		TYPE_ARRAY,
		TYPE_RAW_ARRAY,
		TYPE_INT_ARRAY,
		TYPE_REAL_ARRAY,
		TYPE_STRING_ARRAY,
		TYPE_VECTOR2_ARRAY,
		TYPE_VECTOR3_ARRAY,
		TYPE_COLOR_ARRAY,
		TYPE_MAX
	]


static func _stop_built_in_type_check(_type = TYPE_NIL, _val_type = TYPE_NIL):
	return _type == TYPE_NIL or _type == _val_type


static func _cont_built_in_type_check(_type = TYPE_NIL, _val_type = TYPE_NIL):
	return _type == TYPE_OBJECT or not _type == _val_type
