tool
class_name SignalItem extends Resource

enum SignalItemType {
	SELF_ONESHOT = 0,
	SELF_DEFERRED = 1,
	NONSELF_ONESHOT = 2,
	NONSELF_DEFERRED = 3
}

export(bool) var connected
export(Resource) var obj_from
export(String) var name
export(Resource) var obj_to
export(String) var method
export(Array) var args
export(int) var flags
export(SignalItemType) var type


func _init(_connected, _obj_from, _name, _obj_to, _method, _args, _flags, _type, _is_local):
	if is_valid(_connected, _obj_from, _name, _obj_to, _method, _args, _flags, _type, _is_local):
		connected = _connected
		obj_from = _obj_from
		name = _name
		obj_to = _obj_to
		method = _method
		args = _args
		flags = _flags
		type = _type
		resource_local_to_scene = _is_local
	else:
		connected = false
		obj_from = null
		name = ""
		obj_to = null
		method = ""
		args = []
		flags = "CONNECT_DEFERRED"
		type = "SELF_DEFERRED"
		resource_local_to_scene = true


# static util functions
static func is_valid(_c, _o_f, _n, _o_t, _m, _a, _f, _t, _l):
	var valid = false
	if _valid_str(_n) && _valid_str(_m):
		if _o_f != null && _o_t != null:
			if _a.get_type() == "Array":
				if _t == "SELF_ONESHOT" || _t == "SELF_DEFERRED":
					valid = _valid_connect(true, _c, _l, _o_f, _n, _o_t, _m, _a, _f)
				elif _t == "NONSELF_ONESHOT" || _t == "NONSELF_DEFERRED":
					valid = _valid_connect(false, _c, _l, _o_f, _n, _o_t, _m, _a, _f)
	if valid:
		_o_f.disconnect(_n)
	return valid


static func _valid_connect(_self, _c, _l, _o_f, _n, _o_t, _m, _a, _f):
	var valid = false
	if _valid_objs(_self, _l, _o_f, _o_t):
		var is_conn = _o_f.is_connected(_n, _o_t, _m)
		if _c == is_conn:
			if not is_conn:
				valid = _o_f.connect(_n, _o_t, _m, _a, _f)
			else:
				valid = true
	return valid


static func _valid_str(_str = null):
	return _str != null && _str != ""


static func _is_type(_t = null, _t1 = null, _t2 = null):
	return _t == _t1 || _t == _t2


static func _valid_objs(_is_self: bool, _is_loc: bool, _obj_from: Object, _obj_to: Object):
	var is_eq_ids = _is_self && _obj_from.get_instance_id() == _obj_to.get_instance_id()
	var is_eq_rids = _is_self && _obj_from.get_rid() == _obj_to.get_rid()
	var is_self_eq_ids = _valid_ids(_is_loc && is_eq_ids, not _is_loc && is_eq_rids)
	var not_self_not_eq_ids = _valid_ids(not _is_loc && not is_eq_rids, not is_eq_ids && _is_loc)
	return is_self_eq_ids || not_self_not_eq_ids


static func _valid_ids(_is: bool, _is_not: bool):
	return _is || _is_not
