tool
class_name SingletonTable extends Resource

const _CLASS_NAME = "SingletonTable"
const _BASE_CLASS_NAME = "Singleton"

# properties
export(bool) var enabled setget , get_enabled
export(bool) var has_items setget , get_has_items
export(int) var items_amount setget , get_items_amount

# fields
var _data = {
	"name": "",
	"self_ref": null,
	"manager_ref": null,
	"items": {},
	"amount": 0,
	"state":
	{
		"initialized": false,
		"registered": false,
		"saved": false,
		"has_name": false,
		"cached": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"has_items": false,
		"enabled": false,
		"destroyed": false
	}
}


# inherited private methods
func _init(_name = "", _self_ref = null, _manager = null):
	resource_local_to_scene = false
	_data.name = _name
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_on_init(_self_ref, _manager)


# inhertied public methods
func is_class(_class: String):
	return _class == _BASE_CLASS_NAME or _class == _CLASS_NAME or _class == _data.name


func get_class():
	return _CLASS_NAME


# public methods
func add(_key: String, _value):
	var added = false
	if not _data.items.has(_key):
		_data.items[_key] = _on_item(_key, _value)
		added = _on_add()
	return added


func enable(_self_ref = null, _manager = null):
	_on_init(_self_ref, _manager)
	var _enabled = _data.state.enabled
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
			if remove(n):
				rem_amt = rem_amt + 1
		removed = rem_amt == amt
	return removed


func remove(_key: String):
	var removed = _data.items.erase(_key)
	if removed:
		_data.amount = _data.amount - 1
		_on_no_items()
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
	if _on_en_items():
		_data.items.clear()
		_data.amount = 0
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


func destroy():
	remove_all()
	disable()
	_data.state.destroyed = true


# private helper methods
func _on_init(_self_ref = null, _manager = null):
	_data.self_ref = _self_ref
	_data.state.has_self_ref = not _data.self_ref == null
	_data.manager_ref = _manager
	_data.state.has_manager_ref = not _data.manager_ref == null
	_data.state.cached = _data.state.has_name && _data.state.has_manager_ref && _data.state.has_self_ref
	_data.state.initialized = _data.state.cached
	_data.state.enabled = _data.state.initialized


func _on_item(_key: String, _value):
	var item = _data.items[_key]
	if _data.state.enabled && StringUtility.is_valid(_key) && not _value == null:
		item = _value
	return item


func _on_en_items():
	return _data.state.enabled && _data.has_items


func _on_no_items():
	_data.state.has_items = not _data.amount == 0


func _on_add():
	_data.amount = _data.amount + 1
	if not _data.state.has_items:
		_data.state.has_items = true
	return _data.state.has_items


# setters, getters functions
func get_enabled():
	return _data.state.enabled


func get_has_items():
	return _data.state.has_items


func get_items_amount():
	return _data.amount

#func _on_get_kvp(_key: String):
#	return _on_en_items() && _data.items.has(_key)
#export(String) var name setget , get_name
#export(bool) var initialized setget , get_initialized
#export(bool) var cached setget , get_cached
#export(bool) var registered setget , get_registered
#export(bool) var saved setget , get_saved
#export(bool) var destroyed setget , get_destroyed
#export(bool) var has_name setget , get_has_name
#export(bool) var has_manager setget , get_has_manager

#func register_all():
#	var _reg_all = false
#	var _cannot_register = false
#	var names = _data.items.keys
#	for n in names:
#		if not _data.items[n].register():
#			_cannot_register = true
#			break
#	_reg_all = not _cannot_register
#	return _reg_all

#func save_all():
#	var _save_all = false
#	var _cannot_save = false
#	var names = _data.items.keys
#	for n in names:
#		if not _data.items[n].save():
#			_cannot_save = true
#			break
#	_save_all = not _cannot_save
#	return _save_all

#func set_item(_key: String, _value):
#	var set = false
#	if _data.items.has(_key):
#		_data.items[_key] = _on_item(_key, _value)
#		set = true
#	return set

#func get_name():
#	return _data.name

#func get_initialized():
#	return _data.state.initialized

#func get_registered():
#	return _data.state.registered

#func get_cached():
#	return _data.state.cached

#func get_saved():
#	return _data.state.saved

#func get_destroyed():
#	return _data.state.destroyed

#func get_has_name():
#	return _data.state.has_name

#func get_has_manager():
#	return _data.state.has_manager
