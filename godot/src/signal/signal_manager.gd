tool
class_name SignalManager extends Resource

var db = {}
var init_self_oneshot: bool
var init_self_deferred: bool
var init_nonself_oneshot: bool
var init_nonself_deferred: bool
#var is_valid: bool setget get_is_valid, set_is_valid

#func get_is_valid():

#func set_is_valid():
#	pass

"""
func _init():
	db = {
		"self": {"oneshot": null, "deferred": null}, "nonself": {"oneshot": null, "deferred": null}
	}
	init_self_oneshot = false
	init_self_deferred = false
	init_nonself_oneshot = false
	init_nonself_deferred = false
"""
"""
func add(_validate = true, _signal_item=null):#_c, _o_f, _n, _o_t, _m, _a, _f, _t):
	var added = false
	if _validate:
		if _signal_item.get_class() == "SignalItem":
			if _is_valid(_signal_item):
"""
	#if added:
	#	pass
	# validation
"""
	if is_valid(_c, _o_f, _n, _o_t, _m, _a, _f, _t, _o_f.resource_local_to_scene):
		#var i = SignalItem.new(_c, _o_f, _n, _o_t, _m, _a, _f, _t, _o_f.resource_local_to_scene)
		if _t == "SELF_ONESHOT":
			if not init_self_oneshot:
				db.self.oneshot = ResourceCollection.new()
				db.self.oneshot.set_base_type(SignalItem)
				db.self.oneshot.set_type_readonly(true)
				init_self_oneshot = true
			db.self.oneshot.set(_n, i)
		elif _t == "SELF_DEFERRED":
			if not init_self_deferred:
				db.self.deferred = ResourceCollection.new()
				db.self.deferred.set_base_type(SignalItem)
				db.self.deferred.set_type_readonly(true)
				init_self_deferred = true
			db.self.deferred.set(_n, i)
		elif _t == "NONSELF_ONESHOT":
			if not init_nonnonself_oneshot:
				db.nonself.oneshot = ResourceCollection.new()
				db.nonself.oneshot.set_base_type(SignalItem)
				db.nonself.oneshot.set_type_readonly(true)
				init_nonself_oneshot = true
			db.nonself.oneshot.set(_n, i)
		elif _t == "NONSELF_DEFERRED":
			if not init_nonself_deferred:
				db.nonself.deferred = ResourceCollection.new()
				db.nonself.deferred.set_base_type(SignalItem)
				db.nonself.deferred.set_type_readonly(true)
				init_nonself_deferred = true
			db.nonself.deferred.set(_n, i)
"""

"""
static func is_valid():
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
"""