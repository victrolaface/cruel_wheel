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
					push_warning("cannot enable item in table.")
					enabled = not enabled
	return enabled


func _names():
	return PoolStringArray(data.items.keys())


func _has_names(_names = []):
	return _names.size() > 0


func disable():
	var disabled = .disable()
	if disabled:
		var names = _names()
		if _has_names(names):
			for n in names:
				if data.items[n].disable():
					continue
				else:
					push_warning("cannot disable item in table.")
					disabled = not disabled
	return disabled


func add(_key = "", _value = null):
	var added = StringUtility.is_valid(_key) && ResourceUtility.obj_is_valid(_value) && not has_key(_key)
	if added:
		data.items[_key] = _value
		data.items_amount = data.items_amount + 1
		if not data.state.has_items:
			data.state.has_items = true
	else:
		push_warning("cannot add item to table.")
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
				push_warning("cannot remove disabled item from table.")
		var items_amt = data.items_amount
		var init_sans_rem = init_amt - rem_amt
		var init_sans_amt = init_amt - amt
		removed = rem_amt == amt && items_amt == init_sans_rem && items_amt == init_sans_amt
		if not removed:
			push_warning("invalid amount of disabled items removed from table.")
	return removed


func remove_keys(_keys: PoolStringArray):
	return false
	#var removed_keys = false
	#var exists = false
	#if _keys.size() > 0:
	#	for k in _keys:
	#		if _data.items.erase(k):
	#			continue
	#		push_warning("unable to erase item.")
	#		if not exists:
	#			exists = true
	#removed_keys = not exists
	#return removed_keys


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
	return removed


func remove_all():
	var removed_all = false
	if _data.state.enabled && _data.has_items:
		_data.items.clear()
		_data.items_amount = 0
		#_on_no_items()
		removed_all = true
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
func _on_removed(_key = ""):
	var removed = data.items.erase(_key)
	if removed:
		data.items_amount = data.items_amount - 1
		_on_cleared()
	return removed


func _on_cleared():
	_data.state.has_items = not _data.items_amount == 0


# setters, getters functions
func get_has_items():
	return data.state.has_items  #data.items_amount > 0


func get_items_amount():
	return data.items_amount
