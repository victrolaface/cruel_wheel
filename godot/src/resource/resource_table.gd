tool
class_name ResourceTable extends ResourceItem

# properties
export(bool) var has_items setget , get_has_items

# fields
var _t = {
	"items": {},
	"items_amt": 0,
	"class_item_name": "ResourceTable",
	"path": "res//src/resource/resource_table.gd",
}


func _init(_class_names = [], _rids = [], _paths = [], _local = true, _id = 0):
	var params = .init_parent(_class_names, _t.class_item_name, _rids, self.get_rid(), _id, _paths, _t.path)
	._init(params.class_names, params.rids, params.paths, _local, _id)

	#.init_parent(_class_names, _t.class_item_name, _rids, self.get_rid(), _id, _local, _paths, _t.path)
	#self.resource_local_to_scene = _local
	#var rid = self.get_rid()
	#var res_loc = self.resource_local_to_scene
	#var params = _util.init_params(_class_names, _i.class_item_name, _rids, rid, _id, _local, res_loc, _paths, _i.path)
	#if params.size() > 0 && params.can_enable:
	#	_i.name = params.name
	#	_i.id = params.id
	#	_i.rids = params.rids
	#	_i.class_names = params.class_names
	#	_i.paths = params.paths
	#	_i.state.local = params.local
	#	self.resource_name = _i.name
	#	self.resource_path = _i.paths[0]
	#	var connected = _changed_connected()
	#	if not connected:
	#		connected = _on_changed_connected(true)
	#	if connected:
	#		_i.state.enabled = params.can_enable
	#		enable()


# setters, getters functions
func get_has_items():
	return _t.items_amt > 0


"""
# properties
export(bool) var has_items setget , get_has_items
#export(int) var items_amount setget , get_items_amount

# fields
enum _ITEM_TYPE { NONE = 0, DISABLED = 1, INVALID = 2, ALL = 3 }

var _t = {
	"items": {},
	"items_amt": 0,
	"class_names": PoolStringArray(["ResourceTable"]),
	"path": "res://src/resource/resource_table.gd",
}


# private inherited methods
# (_paths = [], _class_names = [], _local = true, _id = 0, _editor_only = false)
func _init():  #_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	pass
	#_t.class_names = .init_class_names(_class_names, _t.class_names)
	#var local = .init_local_param(_local, _id)
	#var path = .init_path_param(_path, _t.path)
	#(_paths = [], _class_names = [], _local = true, _id = 0, _editor_only = false)
	#._init(local, path, _editor_only, _t.class_names, _id)


func enable():
	var enabled = false
	if _able(true):
		enabled = .enable()
	return enabled


func disable():
	var disabled = false
	if _able(false):
		disabled = .disable()
	return disabled


func _able(_enabled = true):
	var abled = true
	if self.has_items:
		for k in _keys():
			var en = _enabled
			var dis = not _enabled
			var on_able = en or dis
			if on_able:
				var cont = false
				if en:
					cont = _t.items[k].enable()
				elif dis:
					cont = _t.items[k].disable()
				if cont:
					continue
			if _enabled:
				_itm_warn("enable")
			else:
				_itm_warn("disable")
			abled = false
	return abled


func _itm_warn(_do = ""):
	push_warning("cannot " + _do + " item in table.")


func add(_key, _val, _is_validated):
	var valid = _is_validated
	var key_is_id = false
	var key_is_class = false
	var can_add = false
	var added = false
	if not valid:
		var itm_valid = .item_is_valid(_val)
		var id = 0
		if itm_valid:
			id = _val.id if _val.has_id else id
			key_is_id = _val.local && _key == id
		var itm_class_name = ""
		if itm_valid && not key_is_id:
			itm_class_name = _val.get_class() if not key_is_id else itm_class_name
			key_is_class = .str_is_valid(itm_class_name) && _key == itm_class_name
		valid = key_is_id or key_is_class
	if valid:
		can_add = not _has_key(_key) if self.has_items else not self.has_items
		if can_add:
			_t.items[_key] = _val
			_t.items_amt = _t.items_amt + 1
			added = can_add
	return added


func _has_key(_key):
	return _t.items.has(_key)


func _keys():
	return PoolStringArray(_t.items.keys())


func remove(_key):
	var removed = false
	if _has_key(_key):
		removed = _t.items.erase(_key)
		if removed:
			_t.items_amt = _t.items_amt - 1
	return removed


# setters, getters functions
func get_has_items():
	return _t.items_amt > 0


#func remove_keys(_keys = []):
#	var rem = _keys.size() > 0 && _t.state.has_items
#	if rem:
#		for k in _keys:
#			if _on_removed(k):
#				continue
#			else:
#				_on_add_item_warning(false)
#				if rem:
#					rem = not rem
#		if not rem:
#			_on_add_items_warning(false)
#	else:
#		_on_no_items_rem_warning()
#	return rem

#func remove_invalid():
#	return _on_remove(_ITEM_TYPE.INVALID)

#func remove_disabled():
#	return _on_remove(_ITEM_TYPE.DISABLED)

#func remove_all():
#	return _on_remove(_ITEM_TYPE.ALL)

#func validate(_enabled = true):
#	var valid = true
#	var keys = _keys()
#	for k in keys:
#		if _t.items[k].validate(_enabled):
#			continue
#		else:
#			_on_item_warning("validate")
#			if valid:
#				valid = not valid
#	return valid

#func has_keys(_keys = []):
#	var has = false
#	if _keys.size() > 0:
#		for k in _keys:
#			has = _has_key(k)
#			if not has:
#				break
#	return has

#func has_keys_sans(_keys = []):
#	var keys = _keys()
#	var has_sans = false
#	if _keys.size() > 0:
#		for k in keys:
#			for _k in _keys:
#				has_sans = not k == _k
#				if has_sans:
#					break
#			if has_sans:
#				break
#	return has_sans

#func keys_sans(_keys = []):
#	var keys = _keys()
#	var keys_sans = PoolStringArray()
#	keys_sans.clear()
#	if _keys.size() > 0:
#		var amt = 0
#		var idx = 0
#		for k in keys:
#			for _k in _keys:
#				if not k == _k:
#					var tmp = PoolStringArray(keys_sans)
#					amt = amt + 1
#					tmp.resize(amt)
#					tmp.set(idx, k)
#					idx = idx + 1
#					keys_sans = PoolStringArray(tmp)
#	return keys_sans

# private helper methods
#func _has_keys(_keys = []):
#	return _keys.size() > 0

#func _on_remove(_item_type = _ITEM_TYPE.NONE):
#	var removed = not _item_type == _ITEM_TYPE.NONE && self.has_items#_t.state.has_items
#	if removed:
#		var keys = _keys()
#		var keys_to_rem = PoolStringArray()
#		var amt = 0
#		var idx = 0
#		var proc_rem = false
#		keys_to_rem.clear()
#		for k in keys:
#			match _item_type:
#				_ITEM_TYPE.DISABLED:
#					proc_rem = not _t.items[k].enabled
#				_ITEM_TYPE.INVALID:
#					proc_rem = not _t.items[k].validate()
#				_ITEM_TYPE.ALL:
#					proc_rem = true
#			if proc_rem:
#				var tmp = PoolStringArray(keys_to_rem)  #names_to_rem)
#				amt = amt + 1
#				tmp.resize(amt)
#				tmp.set(idx, k)
#				idx = idx + 1
#				keys_to_rem = PoolStringArray(tmp)
#		amt = keys_to_rem.size()
#		if amt > 0:
#			var init_amt = _t.items_amount
#			var rem_amt = 0
#			for k in keys_to_rem:
#				removed = _on_removed(k)
#				if removed:
#					rem_amt = rem_amt + 1
#				else:
#					_on_not_removed_warning(_item_type, false)
#			var items_amt = _t.items_amount
#			var init_sans_rem = init_amt - rem_amt
#			var init_sans_amt = init_amt - amt
#			removed = rem_amt == amt && items_amt == init_sans_rem && items_amt == init_sans_amt
#			if not removed:
#				_on_not_removed_warning(_item_type, true)
#		else:
#			_on_no_items_rem_warning()
#	return removed

#func _on_removed(_key = ""):
#	var removed = _t.items.has(_key)
#	if removed:
#		removed = _t.items.erase(_key)
#		if removed:
#			_t.items_amount = _t.items_amount - 1
#			_on_cleared()
#	return removed

#func _on_cleared():
#	_t.state.has_items = not _t.items_amount == 0

#func _on_add_item_warning(_add = true, _item_is = ""):
#	var warning = "cannot "
#	if _add:
#		warning = warning + "add "
#		warning = _on_warning_is_type(_item_is, warning)
#		warning = warning + "to "
#	else:
#		warning = warning + "remove "
#		warning = _on_warning_is_type(_item_is, warning)
#		warning = warning + "from "
#	warning = warning + "table."
#	push_warning(warning)

#func _on_warning_is_type(_item_is = "", _warning = ""):
#	if .str_is_valid(_item_is):
#		_warning = _warning + _item_is + " item "
#	else:
#		_warning = _warning + "item "
#	return _warning

#func _on_add_items_warning(_add = true, _item_is = ""):
#	var warning = "invalid amount of "
#	if .str_is_valid(_item_is):
#		warning = warning + _item_is + " "
#	warning = warning + "items "
#	if _add:
#		warning = warning + "added to "
#	else:
#		warning = warning + "removed from "
#	warning = warning + "table."
#	push_warning(warning)

#func _on_not_removed_warning(_item_type = _ITEM_TYPE.NONE, _is_multiple = false):
#	var item_type = ""
#	match _item_type:
#		_ITEM_TYPE.DISABLED:
#			item_type = "disabled"
#		_ITEM_TYPE.INVALID:
#			item_type = "invalid"
#	var disabled_or_invalid = _item_type == _ITEM_TYPE.DISABLED or _item_type == _ITEM_TYPE.INVALID
#	var all = _item_type == _ITEM_TYPE.ALL
#	if _is_multiple:
#		if disabled_or_invalid:
#			_on_add_items_warning(false, item_type)
#		elif all:
#			_on_add_items_warning(false)
#	else:
#		if disabled_or_invalid:
#			_on_add_item_warning(false, item_type)
#		elif all:
#			_on_add_item_warning(false)

#func _on_no_items_rem_warning():
#	push_warning("no items to remove from table.")

#func get_items_amount():
#	return _t.items_amt
"""
"""
	var added = _v.is_class("ResourceItem") && _v.enabled && _v.has_parent_class && .item_is_valid(_v) && .str_is_valid(_k)
	if added:
		added = _v.has_name
		var is_local = _v.has_id && _v.local && .id_is_valid(_v.id)
		var add_local = added && is_local
		var add_single = added && not is_local
		var item_class_name = _v.get_class()
		var parent_class_name = _v.parent_class
		var has_parent_class = false
		var has_item_class = false
		var parent_class_keys = null
		var item_class_keys = null
		var init_add_parent_class = true
		if add_local:
			parent_class_keys = PoolStringArray(_t.items.local.keys())
			for k in parent_class_keys:
				has_parent_class = k == parent_class_name
				if has_parent_class:
					item_class_keys = PoolStringArray(_t.items.local[parent_class_name].keys())
					has_parent_class = item_class_keys.size() > 0
					init_add_parent_class = not has_parent_class
					break
			var init_add_item_class = true
			if has_parent_class:
				for i in item_class_keys:
					has_item_class = i == item_class_name
					if has_item_class:
						init_add_item_class = not has_item_class
						break
				var id = _v.id
				var has_id = false
				if has_item_class:
					var ids_keys = PoolStringArray(_t.items.local[parent_class_name[item_class_name]].keys())
					if ids_keys.size() > 0:
						for i in ids_keys:
							has_id = i == id
							if has_id:
								if not _t.items.local[parent_class_name[item_class_name[id]]].validate():
									add_local = remove(item_class_name, parent_class_name, id)
								else:
									add_local = not add_local
									break
			if init_add_parent_class:
				_t.items.local[parent_class_name] = {}
			if init_add_item_class:
				_t.items.local[parent_class_name[item_class_name]] = {}
				add_local = init_add_item_class
			if add_local:
				_t.items.local[parent_class_name[item_class_name[id]]] = _v
				added = add_local
		elif add_single:
			#######################################################################
			parent_class_keys = PoolStringArray(_t.items.single.keys())
			for k in parent_class_keys:
				has_parent_class = k == parent_class_name
				if has_parent_class:
					parent_class = _t.items.single[parent_class_name]
					item_class_keys = PoolStringArray(parent_class.keys())
					has_parent_class = item_class_keys.size() > 0
					init_add_parent_class = not has_parent_class
			if has_parent_class:
				for i in item_class_keys:
					has_item_class = i == item_class_name
					if has_item_class:
						break
				if has_item_class:
					if not _t.items.single.parent_class.item_class.validate():
						add_single = remove(item_class_name, parent_class_name)
					else:
						add_single = not add_single
			if init_add_parent_class:
				pass
			#######################################################################
		if added:
			_t.items_amount = _t.items_amount + 1
			if not _t.state.has_items:
				_t.state.has_items = not _t.state.has_items
		else:
			_on_add_item_warning()
	return added
"""
