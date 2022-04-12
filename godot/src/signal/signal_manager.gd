tool
class_name SignalManager extends Item

# data
export(Dictionary) var db setget set_db, get_db
export(Resource) var self_oneshot setget set_self_oneshot, get_self_oneshot
export(Resource) var self_deferred setget set_self_deferred, get_self_deferred
export(Resource) var nonself_oneshot setget set_nonself_oneshot, get_nonself_oneshot
export(Resource) var nonself_deferred setget set_nonself_deferred, get_nonself_deferred

# state
export(bool) var has_self_oneshot setget set_has_self_oneshot, get_has_self_oneshot
export(bool) var has_self_deferred setget set_has_self_deferred, get_has_self_deferred
export(bool) var has_nonself_oneshot setget set_has_nonself_oneshot, get_has_nonself_oneshot
export(bool) var has_nonself_deferred setget set_has_nonself_deferred, get_has_nonself_deferred
export(bool) var initialized_self_oneshot setget set_initialized_self_oneshot, get_initialized_self_oneshot
export(bool) var initialized_self_deferred setget set_initialized_self_deferred, get_initialized_self_deferred
export(bool) var initialized_nonself_oneshot setget set_initialized_nonself_oneshot, get_initialized_nonself_oneshot
export(bool) var initialized_nonself_deferred setget set_initialized_nonself_deferred, get_initialized_nonself_deferred

var types = SignalItemData.SignalItemType

func _init():
	data = SignalManagerData.new()


func is_valid(_signal_item: SignalItem):
	return SignalItemUtility.is_valid(_signal_item)

func add(_signal_item: SignalItem, _id = null, _validate = false):
	var do_add = true
	var added = false
	if _validate:
		do_add = not SignalItemUtility.is_valid(_signal_item)
	if do_add:
		if _is_invalid(_id):#not IDUtility.is_valid(_id):#not _valid_id(_id):
			if not _signal_item.object_from.resource_local_to_scene:
				_id = _signal_item.object_from.get_rid()
			else:
				_id = _signal_item.object_from.get_instance_id()
			if _is_invalid(_id):
				do_add = not _is_invalid(_id)
	if do_add:
		if _signal_item.type == types.SELF_ONESHOT:
			if not data.has_self_oneshot && not data.initialized_self_oneshot:
				pass
			#added = true
		elif _signal_item.type == types.SELF_DEFERRED:
			added = true
		elif _signal_item.type == types.NONSELF_ONESHOT:
			added = true
		elif _signal_item.type == types.NONSELF_ONESHOT:
			added = true
		else:
			added = false
	return added

func _is_invalid(_id:int):
	return not IDUtility.is_valid(_id)

func _on_not_valid(_id:int):
	var do_added = true
	if not IDUtility.is_valid(_id):
		do_added = false
	return do_added
	#return not IDUtility.is_valid(_id)

func _valid_id(_id:int):
	return IDUtility.is_valid(_id)
		#data.

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


# setters, getters
func set_db(_db: Object):
	pass


func get_db():
	return data.db


func set_self_oneshot(_self_oneshot: ResourceCollection):
	pass


func get_self_oneshot():
	return data.self_oneshot


func set_self_deferred(_self_deferred: ResourceCollection):
	pass


func get_self_deferred():
	return data.self_deferred


func set_nonself_oneshot(_nonself_oneshot: ResourceCollection):
	pass


func get_nonself_oneshot():
	return data.nonself_oneshot


func set_nonself_deferred(_nonself_deferred: ResourceCollection):
	pass


func get_nonself_deferred():
	return data.nonself_deferred


func set_has_self_oneshot(_has_self_oneshot: bool):
	pass


func get_has_self_oneshot():
	return data.has_self_oneshot


func set_has_self_deferred(_has_self_deferred: bool):
	pass


func get_has_self_deferred():
	return data.has_self_deferred


func set_has_nonself_oneshot(_has_nonself_oneshot: bool):
	pass


func get_has_nonself_oneshot():
	return data.has_nonself_oneshot


func set_has_nonself_deferred(_has_nonself_deferred: bool):
	pass


func get_has_nonself_deferred():
	return data.has_nonself_deferred


func set_initialized_self_oneshot(_initialized_self_oneshot: bool):
	pass


func get_initialized_self_oneshot():
	return data.initialized_self_oneshot


func set_initialized_self_deferred(_initialized_self_deferred: bool):
	pass


func get_initialized_self_deferred():
	return data.initialized_self_deferred


func set_initialized_nonself_oneshot(_initialized_nonself_oneshot: bool):
	pass


func get_initialized_nonself_oneshot():
	return data.initialized_nonself_oneshot


func set_initialized_nonself_deferred(_initialized_nonself_deferred: bool):
	pass


func get_initialized_nonself_deferred():
	return data.initialized_nonself_deferred
