tool
class_name ResourceTable extends ResourceItem  #Resource

# properties
export(bool) var has_items setget , get_has_items
export(int) var items_amount setget , get_items_amount

# fields
const _CLASS_NAME = "ResourceTable"

var data = {
	"items": {},
	"items_amount": 0,
	"state":
	{
		"has_items": false,
	}
}


# private inherited methods
func _init(_is_local = true):
	is_local_to_scene = _is_local
	base_class_name = _CLASS_NAME
	._init(self)


func get_class():
	return _CLASS_NAME


func enable(_self_ref = null, _db_ref = null, _manager = null):
	var enabled = .enable_from_manager(_db_ref, _manager, _self_ref)
	if enabled:
		var names = _names()
		if _has_names(names):
			for n in names:
				if data.items[n].enable_from_manager(_db_ref, _manager, data.items[n]):
					continue
				else:
					_on_item_warning()
					enabled = not enabled
	else:
		_on_table_warning()
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
					_on_item_warning(false)
					disabled = not disabled
	else:
		_on_table_warning(false)
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


func remove_disabled():
	var removed = false
	var names = _names()
	var names_to_remove = PoolStringArray()
	var init_amt = data.items_amount
	for n in names:
		if not data.items[n].enabled:
			names_to_remove.append(n)
	var amt = names_to_remove.size()
	var rem_amt = 0
	if amt > 0:
		for n in names_to_remove:
			removed = _on_removed(n)
			if removed:
				rem_amt = rem_amt + 1
			else:
				_on_add_item_warning(false, "disabled")
		var items_amt = data.items_amount
		var init_sans_rem = init_amt - rem_amt
		var init_sans_amt = init_amt - amt
		removed = rem_amt == amt && items_amt == init_sans_rem && items_amt == init_sans_amt
		if not removed:
			_on_add_items_warning(false, "disabled")
	else:
		_on_no_items_rem_warning()
	return removed


func remove_keys(_keys: PoolStringArray):
	var removed_keys = _keys.size() > 0
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


func _on_no_items_rem_warning():
	push_warning("no items to remove.")


func remove_invalid():
	var removed = false
	var names = _data.items.keys()
	var invalid_names = []
	for n in names:
		if not _data.items[n].validate():
			invalid_names.append(n)
	var amt = invalid_names.count()
	if amt > 0:
		var removed_amt = 0
		for n in invalid_names:
			if _data.items.erase(n):
				removed_amt = removed_amt + 1
			else:
				push_warning("unable to remove item.")
		removed = removed_amt == amt
	else:
		_on_no_items_rem_warning()
	return removed


func remove_all():
	var removed_all = false
	if _data.has_items:
		_data.items.clear()
		_data.items_amount = 0
		removed_all = true
	else:
		_on_no_items_rem_warning()
	return removed_all


func validate():
	var validated = false
	var names = _data.items.keys()
	var invalid = false
	for n in names:
		if _data.items[n].validate():
			continue
		push_warning("unable to validate item.")
		if not invalid:
			invalid = true
	validated = not invalid
	return validated


func has_key(_key: String):
	return _data.items.has(_key)


func has_keys(_keys: PoolStringArray):
	var has = false
	if _keys.size() > 0:
		for k in _keys:
			has = _data.items.has(k)
			if not has:
				break
	return has


func has_keys_sans(_keys: PoolStringArray):
	var names = _data.items.keys()
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
	var names = _data.items.keys()
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


func _has_names(_names = []):
	return _names.size() > 0


func _on_removed(_key = ""):
	var removed = data.items.has(_key)
	if removed:
		removed = data.items.erase(_key)
		if removed:
			data.items_amount = data.items_amount - 1
			_on_cleared()
	return removed


func _on_cleared():
	_data.state.has_items = not _data.items_amount == 0


func _on_table_warning(_enabled = true):
	var do = _on_do(_enabled)
	push_warning("cannot " + do + "table.")


func _on_item_warning(_enabled = true):
	var do = _on_do(_enabled)
	push_warning("cannot " + do + " item in table.")


func _on_do(_enabled = true):
	return "enable" if _enabled else "disable"


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


# setters, getters functions
func get_has_items():
	return data.state.has_items


func get_items_amount():
	return data.items_amount
