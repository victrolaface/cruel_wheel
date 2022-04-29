tool
class_name ResourceTable extends ResourceItem  #Resource

# properties
export(bool) var has_items setget , get_has_items
export(int) var items_amount setget , get_items_amount

# fields
enum _ITEM_TYPE { NONE = 0, DISABLED = 1, INVALID = 2, ALL = 3 }
const _ENABLE = "enable"
const _DISABLE = "disable"

var _t = {
	"items": {},
	"items_amount": 0,
	"type": "",
	"class_names": PoolStringArray(["ResourceTable"]),
	"path": "res://src/resource/resource_table.gd",
	"state":
	{
		"has_items": false,
	}
}


# private inherited methods
func _init(_local = true, _editor_only = false, _class_names = []):
	.init_resource(_local, self.resource_local_to_scene, _t.class_names[0], self.resource_name, _t.path, self.resource_path)
	var size = _class_names.size()
	if size > 0:
		_t.type = _class_names[size - 1]
	_t.class_names = ClassNameUtility.class_names(_class_names, _t.class_names)
	.init(_local, _editor_only, _t.class_names)


func has_key(_key = ""):
	var has = _t.state.has_items
	if has:
		has = _t.items.has(_key)
	return has


func enable():
	return _enable(true)


func disable():
	return _enable(false)


func add(_k = "", _v = null):
	var added = StringUtility.is_valid(_k) && ResourceItemUtility.item_is_valid(_v) && not has_key(_k)
	if added:
		_t.items[_k] = _v
		_t.items_amount = _t.items_amount + 1
		if not _t.state.has_items:
			_t.state.has_items = true
	else:
		_on_add_item_warning()
	return added


func remove_keys(_keys = []):
	var rem = _keys.size() > 0 && _t.state.has_items
	if rem:
		for k in _keys:
			if _on_removed(k):
				continue
			else:
				_on_add_item_warning(false)
				if rem:
					rem = not rem
		if not rem:
			_on_add_items_warning(false)
	else:
		_on_no_items_rem_warning()
	return rem


func remove_invalid():
	return _on_remove(_ITEM_TYPE.INVALID)


func remove_disabled():
	return _on_remove(_ITEM_TYPE.DISABLED)


func remove_all():
	return _on_remove(_ITEM_TYPE.ALL)


func validate(_enabled = true):
	var valid = true
	var names = _names()
	for n in names:
		if _t.items[n].validate(_enabled):
			continue
		else:
			_on_item_warning("validate")
			if valid:
				valid = not valid
	return valid


func has_keys(_keys = []):
	var has = false
	if _keys.size() > 0:
		for k in _keys:
			has = has_key(k)
			if not has:
				break
	return has


func has_keys_sans(_keys = []):
	var names = _names()
	var has_sans = false
	if _keys.size() > 0:
		for n in names:
			for k in _keys:
				has_sans = not n == k
				if has_sans:
					break
			if has_sans:
				break
	return has_sans


func keys_sans(_keys = []):
	var names = _names()
	var names_sans_keys = PoolStringArray()
	names_sans_keys.clear()
	if _keys.size() > 0:
		var amt = 0
		var idx = 0
		#var names_idx = 0
		for n in names:
			for k in _keys:
				if not n == k:
					var tmp = PoolStringArray(names_sans_keys)
					amt = amt + 1
					tmp.resize(amt)
					tmp.set(idx, n)
					idx = idx + 1
					names_sans_keys = PoolStringArray(tmp)
		if names_sans_keys.size() > 0:
			names_sans_keys = PoolStringArray(names_sans_keys)
		else:
			names_sans_keys = PoolStringArray()
	return names_sans_keys


# private helper methods
func _names():
	return PoolStringArray(_t.items.keys())


func _has_names(_names = []):
	return _names.size() > 0


func _enable(_enabled = true):
	var abled = .enable() if _enabled else .disable()
	var able_type = _ENABLE if _enabled else _DISABLE
	if abled:
		var names = _names()
		if _has_names(names):
			for n in names:
				abled = _t.items[n].enable() if _enabled else _t.items[n].disable()
				if abled:
					continue
				else:
					_on_item_warning(able_type)
					abled = not abled
	else:
		_on_table_warning(able_type)
	return abled


func _on_remove(_item_type = _ITEM_TYPE.NONE):
	var removed = not _item_type == _ITEM_TYPE.NONE && _t.state.has_items
	if removed:
		var names = _names()
		var names_to_rem = PoolStringArray()
		var amt = 0
		var idx = 0
		var proc_rem = false
		names_to_rem.clear()
		for n in names:
			match _item_type:
				_ITEM_TYPE.DISABLED:
					proc_rem = not _t.items[n].enabled
				_ITEM_TYPE.INVALID:
					proc_rem = not _t.items[n].validate()
				_ITEM_TYPE.ALL:
					proc_rem = true
			if proc_rem:
				var tmp = PoolStringArray(names_to_rem)
				amt = amt + 1
				tmp.resize(amt)
				tmp.set(idx, n)
				idx = idx + 1
				names_to_rem = PoolStringArray(tmp)
		amt = names_to_rem.size()
		if amt > 0:
			var init_amt = _t.items_amount
			var rem_amt = 0
			for n in names_to_rem:
				removed = _on_removed(n)
				if removed:
					rem_amt = rem_amt + 1
				else:
					_on_not_removed_warning(_item_type, false)
			var items_amt = _t.items_amount
			var init_sans_rem = init_amt - rem_amt
			var init_sans_amt = init_amt - amt
			removed = rem_amt == amt && items_amt == init_sans_rem && items_amt == init_sans_amt
			if not removed:
				_on_not_removed_warning(_item_type, true)
		else:
			_on_no_items_rem_warning()
	return removed


func _on_removed(_key = ""):
	var removed = _t.items.has(_key)
	if removed:
		removed = _t.items.erase(_key)
		if removed:
			_t.items_amount = _t.items_amount - 1
			_on_cleared()
	return removed


func _on_cleared():
	_t.state.has_items = not _t.items_amount == 0


func _on_table_warning(_do = ""):
	push_warning("cannot " + _do + "table.")


func _on_item_warning(_do = ""):
	push_warning("cannot " + _do + " item in table.")


func _on_add_item_warning(_add = true, _item_is = ""):
	var warning = "cannot "
	if _add:
		warning = warning + "add "
		warning = _on_warning_is_type(_item_is, warning)
		warning = warning + "to "
	else:
		warning = warning + "remove "
		warning = _on_warning_is_type(_item_is, warning)
		warning = warning + "from "
	warning = warning + "table."
	push_warning(warning)


func _on_warning_is_type(_item_is = "", _warning = ""):
	if StringUtility.is_valid(_item_is):
		_warning = _warning + _item_is + " item "
	else:
		_warning = _warning + "item "
	return _warning


func _on_add_items_warning(_add = true, _item_is = ""):
	var warning = "invalid amount of "
	if StringUtility.is_valid(_item_is):
		warning = warning + _item_is + " "
	warning = warning + "items "
	if _add:
		warning = warning + "added to "
	else:
		warning = warning + "removed from "
	warning = warning + "table."
	push_warning(warning)


func _on_not_removed_warning(_item_type = _ITEM_TYPE.NONE, _is_multiple = false):
	var item_type = ""
	match _item_type:
		_ITEM_TYPE.DISABLED:
			item_type = "disabled"
		_ITEM_TYPE.INVALID:
			item_type = "invalid"
	var disabled_or_invalid = _item_type == _ITEM_TYPE.DISABLED or _item_type == _ITEM_TYPE.INVALID
	var all = _item_type == _ITEM_TYPE.ALL
	if _is_multiple:
		if disabled_or_invalid:
			_on_add_items_warning(false, item_type)
		elif all:
			_on_add_items_warning(false)
	else:
		if disabled_or_invalid:
			_on_add_item_warning(false, item_type)
		elif all:
			_on_add_item_warning(false)


func _on_no_items_rem_warning():
	push_warning("no items to remove from table.")


# setters, getters functions
func get_has_items():
	return _t.state.has_items


func get_items_amount():
	return _t.items_amount
