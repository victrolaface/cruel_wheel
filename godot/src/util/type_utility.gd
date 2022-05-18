class_name TypeUtility

enum TYPES {
	TYPE_NIL = 0,
	TYPE_BOOL = 1,
	TYPE_INT = 2,
	TYPE_REAL = 3,
	TYPE_STRING = 4,
	TYPE_VECTOR2 = 5,
	TYPE_RECT2 = 6,
	TYPE_VECTOR3 = 7,
	TYPE_TRANSFORM2D = 8,
	TYPE_PLANE = 9,
	TYPE_QUAT = 10,
	TYPE_AABB = 11,
	TYPE_BASIS = 12,
	TYPE_TRANSFORM = 13,
	TYPE_COLOR = 14,
	TYPE_NODE_PATH = 15,
	TYPE_RID = 16,
	TYPE_OBJECT = 17,
	TYPE_DICTIONARY = 18,
	TYPE_ARRAY = 19,
	TYPE_RAW_ARRAY = 20,
	TYPE_INT_ARRAY = 21,
	TYPE_REAL_ARRAY = 22,
	TYPE_STRING_ARRAY = 23,
	TYPE_VECTOR2_ARRAY = 24,
	TYPE_VECTOR3_ARRAY = 25,
	TYPE_COLOR_ARRAY = 26,
	TYPE_MAX = 27,
}


static func is_built_in_type(_val = null):
	var has = false
	for t in TYPES:
		if t == TYPE_NIL or t == TYPE_OBJECT:
			continue
		has = t == typeof(_val)
		if has:
			break
	return has


static func built_in_type(_val):
	var built_in_type = TYPE_NIL
	if is_built_in_type(_val):
		for t in TYPES:
			if t == typeof(_val):
				built_in_type = t
				break
	return built_in_type


static func is_type_object(_val = null):
	return not _val == null && not typeof(_val) == TYPE_NIL && typeof(_val) == TYPE_OBJECT
