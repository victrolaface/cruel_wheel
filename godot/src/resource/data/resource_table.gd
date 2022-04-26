tool
class_name ResourceTable extends Resource

# properties
export(String) var name setget set_name, get_name
export(bool) var has_name setget , get_has_name
export(bool) var has_self_ref setget , get_has_self_ref
export(bool) var enabled setget , get_enabled
export(bool) var has_items setget , get_has_items
export(int) var items_amount setget , get_items_amount
export(Resource) var self_ref setget set_self_ref, get_self_ref

# fields
var _data = {
	"name": "",
	"self_ref": null,
	"db_ref": null,
	"manager_ref": null,
	"base_class_names": ["ResourceTable", "Resource"],
	"items": {},
	"items_amount": 0,
	"state":
	{
		"has_name": false,
		"has_self_ref": false,
		"has_db_ref": false,
		"has_manager_ref": false,
		"cached": false,
		"initialized": false,
		"enabled": false
	}
}


# private inherited methods
func _init(_self_ref = null):
	_data.self_ref = _self_ref
	_data.name = _init_name()
	_data.state.has_name = _init_has_name()
	_data.state.has_self_ref = _init_has_self_ref()


# inherited public methods
func is_class(_class):
	return ClassNameUtility.is_class_name(_class, _data.name, _data.base_class_names)


func get_class():
	return _data.name


# public methods
func init_from_manager(_db_ref = null, _manager_ref = null):
	_data.db_ref = _db_ref
	_data.manager_ref = _manager_ref
	_data.state.has_db_ref = _is_obj_valid(_data.db_ref)
	_data.state.has_manager_ref = _is_obj_valid(_data.manager_ref)
	var ds = _data.state
	_data.state.cached = ds.has_name && ds.has_self_ref && ds.has_db_ref && ds.has_manager_ref
	_data.state.initialized = _data.state.cached
	_data.state.enabled = _data.state.initialized
	return _data.state.enabled


func enable(_self_ref = null, _db_ref = null, _manager = null):
	_init(_self_ref)
	var _enabled = init_from_manager(_db_ref, _manager)
	if _enabled:
		var cannot_enable = false
		var names = _data.items.keys()
		for n in names:
			if _data.items[n].enable(_data.items[n], _manager):
				continue
			push_warning("unable to enable item.")
			if not cannot_enable:
				cannot_enable = true
		_enabled = not cannot_enable
	return _enabled


func disable():
	var disabled = false
	var disable = false
	var names = _data.items.keys
	for n in names:
		disable = _data.items[n].disable()
		if not disable:
			push_warning("unable to disable item.")
			break
	disabled = not disable
	return disabled


func add(_key = "", _value = null):
	var added = false
	if not _data.items.has(_key):
		_data.items[_key] = _on_item(_key, _value)
		added = _on_add()
	return added


func remove_disabled():
	var removed = false
	var names = _data.items.keys()
	var names_to_remove = []
	for n in names:
		if not _data.items[n].enabled:
			names_to_remove.append(n)
	var amt = names_to_remove.count()
	var rem_amt = 0
	if amt > 0:
		for n in names_to_remove:
			if _remove(n):
				rem_amt = rem_amt + 1
		removed = rem_amt == amt
	return removed


func remove_keys(_keys: PoolStringArray):
	var removed_keys = false
	var exists = false
	if _keys.size() > 0:
		for k in _keys:
			if _data.items.erase(k):
				continue
			push_warning("unable to erase item.")
			if not exists:
				exists = true
	removed_keys = not exists
	return removed_keys


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
		_on_no_items()
		removed_all = true
	return removed_all


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
func _remove(_key: String):
	var removed = _data.items.erase(_key)
	if removed:
		_data.items_amount = _data.items_amount - 1
		_on_no_items()
	return removed


func _init_name():
	return _data.self_ref.resource_name


func _init_has_name():
	_data.state_has_name = StringUtility.is_valid(_data.name)
	_data.base_class_names = ClassNameUtility.init_base_class_names(_data.state.has_name, _data.state.has_name)


func _init_has_self_ref():
	return _is_obj_valid(_data.self_ref)


func _is_obj_valid(_obj = null):
	return not _obj == null


func _on_item(_key = "", _value = null):  #: String, _value):
	var item = _data.items[_key]
	if _data.state.enabled && StringUtility.is_valid(_key) && not _value == null:
		item = _value
	return item


func _on_no_items():
	_data.state.has_items = not _data.items_amount == 0


func _on_add():
	_data.items_amount = _data.items_amount + 1
	if not _data.state.has_items:
		_data.state.has_items = true
	return _data.state.has_items


# setters, getters functions
func set_name(_name = ""):
	_data.name = _name


func get_name():
	return _data.name


func get_has_name():
	return _data.state.has_name


func get_has_self_ref():
	return _data.state.has_self_ref


func get_items_amount():
	return _data.items_amount


func set_self_ref(_self_ref = null):
	_data.self_ref = _self_ref


func get_self_ref():
	return _data.self_ref


func get_enabled():
	return _data.state.enabled


func get_has_items():
	return _data.state.has_items
