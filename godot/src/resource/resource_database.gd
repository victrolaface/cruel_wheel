tool
class_name ResourceDatabase extends ResourceItem

# properties
export(bool) var has_items setget , get_has_items

# fields
var _int = IntUtility
var _path_util = PathUtility
#var _arr = PoolArrayUtility
#var _str = StringUtility

var _t = {
	"items": {},
	"items_amt": 0,
	"items_static": {},
	"items_static_amt": 0,
	"class_item_name": "ResourceTable",
	"path": "res://src/resource/resource_database.gd",
	"save_path": "",
}


func _init(_name = "", _id = 0, _path = ""):
	_t.save_path = _path
	var _class_names = _arr.init("str") if not _str.is_valid(_name) else _arr.to_arr([], "str", false, _name)
	var paths = _arr.init("str") if not _has_save_path() else _arr.to_arr([], "str", false, _t.save_path)
	var params = .init_parent(_class_names, _t.class_item_name, [], self.get_rid(), _id, paths, _t.path)
	._init(params.class_names, params.rids, params.paths, false, _id)


# setters, getters functions
func get_has_items():
	var _has_items = false
	if self.enabled:
		_has_items = _has_items()
	return _has_items


# public methods
func enable():
	return _enable_db(true)


func disable():
	return _enable_db(false)


func save():
	return false


func clear():
	return false


func add(_val = null):
	var added = false
	if self.enabled && not _val == null:
		var can_add = false
		var itm_class_name = ""
		var amt = 0
		var no_items = _total_items_amt() == 0
		var id = 0
		var is_static = false
		var is_instance = false
		if _val.has_id():
			id = _val.id
			is_static = id == 0
			is_instance = _util.valid_id(id)
		itm_class_name = _val.get_class()
		if is_static:
			amt = _t.items_static_amt
		elif is_instance:
			amt = _t.items_amt
		no_items = true if no_items else amt == 0
		if is_static:
			can_add = true if no_items else not _t.items_static.has(itm_class_name)
		elif is_instance:
			no_items = no_items or not _t.items.has(itm_class_name)
			can_add = true if no_items else not _t.items[itm_class_name].has(id)
		if can_add:
			if _util.is_valid(_val):
				if is_static:
					_t.items_static[itm_class_name] = _val
					_t.items_static_amt = _int.incr(_t.items_static_amt)
				elif is_instance:
					var tmp = _t.items[itm_class_name]
					tmp[id] = _val
					_t.items[itm_class_name] = tmp
					_t.items_amt = _int.incr(_t.items_amt)
				added = true
	return added


func remove(_class = "", _id = 0):  #, _is_static=false):
	return false


func remove_disabled():
	return false


func item(_class = "", _id = 0):
	return null


func static_items(_classes = []):
	return []


func items(_classes = [], _class = "", _ids = []):
	return []


func all_static_items():
	return []


func all_items(_classes = [], _class = ""):
	return []


# private methods
func _enable_db(_enable = true):
	var enbl_or_dsbl = false
	if not self.enabled && _enable && _on_enable_or_disable_db(_enable):
		enbl_or_dsbl = .enable()
	elif self.enabled && not _enable && _on_enable_or_disable_db(_enable):
		enbl_or_dsbl = .disable()
	return enbl_or_dsbl


func _total_items_amt():
	return _t.items_amt + _t.items_static_amt


func _has_items():
	return _total_items_amt() > 0


func _has_save_path():
	return _path_util.is_valid(_t.save_path)


func _keys():
	return _arr.to_arr(_t.items.keys(), "str")


func _on_enable_or_disable_db(_enable = true):
	var enbl = not self.enabled && _enable
	var dsbl = self.enabled && _enable == false
	var enbl_or_dsbl = enbl or dsbl
	var do = "enable" if enbl else "disable"
	if enbl_or_dsbl && _has_items():
		var invalid_items = 0
		for k in _keys():
			var valid = false
			if enbl:
				valid = _t.items[k].enable()
			elif dsbl:
				valid = _t.items[k].disable()
			if not valid:
				push_warning("cannot " + do + " item in table.")
				invalid_items = _int.incr(invalid_items)
		enbl_or_dsbl = not invalid_items > 0
	return enbl_or_dsbl
