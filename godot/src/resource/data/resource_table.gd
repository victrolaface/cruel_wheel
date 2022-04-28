tool
class_name ResourceTable extends ResourceItem  #Resource

# properties
export(bool) var has_items setget , get_has_items
export(int) var items_amount setget , get_items_amount

# fields
enum _ITEM_TYPE { NONE = 0, DISABLED = 1, INVALID = 2, ALL = 3 }
const _ENABLE = "enable"
const _DISABLE = "disable"

var data = {
	"items": {},
	"items_amount": 0,
	"base_class_name": "ResourceTable",
	"state":
	{
		"has_items": false,
	}
}


# private inherited methods
func _init(_is_local = true):
	is_local_to_scene = _is_local
	base_class_name = data.base_class_name
	._init(self)


func get_class():
	return data.base_class_name


func has_key(_key = ""):
	var has = data.state.has_items
	if has:
		has = data.items.has(_key)
	return has


func enable(_self_ref = null, _db_ref = null, _manager = null):
	var enabled = .enable_from_manager(_db_ref, _manager, _self_ref)
	if enabled:
		var names = _names()
		if _has_names(names):
			for n in names:
				if data.items[n].enable_from_manager(_db_ref, _manager, data.items[n]):
					continue
				else:
					_on_item_warning(_ENABLE)
					enabled = not enabled
	else:
		_on_table_warning(_ENABLE)
	return enabled


func disable():
	var disabled = .disable()
	if disabled:
		var names = _names()
		if _has_names(names):
			for n in names:
				if data.items[n].disable():
					continue
				else:
					_on_item_warning(_DISABLE)
					disabled = not disabled
	else:
		_on_table_warning(_DISABLE)
	return disabled


func add(_key = "", _value = null):
	var added = StringUtility.is_valid(_key) && ResourceUtility.obj_is_valid(_value) && not has_key(_key)
	if added:
		data.items[_key] = _value
		data.items_amount = data.items_amount + 1
		if not data.state.has_items:
			data.state.has_items = true
	else:
		_on_add_item_warning()
	return added


func remove_keys(_keys: PoolStringArray):
	var removed_keys = _keys.size() > 0 && data.state.has_items
	if removed_keys:
		for k in _keys:
			if _on_removed(k):
				continue
			else:
				_on_add_item_warning(false)
				if removed_keys:
					removed_keys = not removed_keys
		if not removed_keys:
			_on_add_items_warning(false)
	else:
		_on_no_items_rem_warning()
	return removed_keys


func remove_invalid():
	return _on_remove(_ITEM_TYPE.INVALID)


func remove_disabled():
	return _on_remove(_ITEM_TYPE.DISABLED)


func remove_all():
	return _on_remove(_ITEM_TYPE.ALL)


func validate():
	var validated = true
	var names = _names()
	for n in names:
		if data.items[n].validate():
			continue
		else:
			_on_item_warning("validate")
			if validated:
				validated = not validated
	return validated


func has_keys(_keys: PoolStringArray):
	var has = false
	if _keys.size() > 0:
		for k in _keys:
			has = has_key(k)
			if not has:
				break
	return has


func has_keys_sans(_keys: PoolStringArray):
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


func keys_sans(_keys: PoolStringArray):
	var names = _names()
	var names_sans_keys = []
	if _keys.size() > 0:
		for n in names:
			for k in _keys:
				if not n == k:
					names_sans_keys.append(n)
		if names_sans_keys.count() > 0:
			names_sans_keys = PoolStringArray(names_sans_keys)
		else:
			names_sans_keys = PoolStringArray()
	return names_sans_keys


# private helper methods
func _names():
	return PoolStringArray(data.items.keys())


func _has_names(_names: PoolStringArray):
	return _names.size() > 0


func _on_remove(_item_type = _ITEM_TYPE.NONE):
	var removed = not _item_type == _ITEM_TYPE.NONE && data.state.has_items
	if removed:
		var names = _names()
		var names_to_rem = PoolStringArray()
		var proc_rem = false
		for n in names:
			match _item_type:
				_ITEM_TYPE.DISABLED:
					proc_rem = not data.items[n].enabled
				_ITEM_TYPE.INVALID:
					proc_rem = not data.items[n].validate()
				_ITEM_TYPE.ALL:
					proc_rem = true
			if proc_rem:
				names_to_rem.append(n)
		var amt = names_to_rem.size()
		if amt > 0:
			var init_amt = data.items_amount
			var rem_amt = 0
			for n in names_to_rem:
				removed = _on_removed(n)
				if removed:
					rem_amt = rem_amt + 1
				else:
					_on_not_removed_warning(_item_type, false)
			var items_amt = data.items_amount
			var init_sans_rem = init_amt - rem_amt
			var init_sans_amt = init_amt - amt
			removed = rem_amt == amt && items_amt == init_sans_rem && items_amt == init_sans_amt
			if not removed:
				_on_not_removed_warning(_item_type, true)
		else:
			_on_no_items_rem_warning()
	return removed


func _on_removed(_key = ""):
	var removed = data.items.has(_key)
	if removed:
		removed = data.items.erase(_key)
		if removed:
			data.items_amount = data.items_amount - 1
			_on_cleared()
	return removed


func _on_cleared():
	data.state.has_items = not data.items_amount == 0


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
	return data.state.has_items


func get_items_amount():
	return data.items_amount
