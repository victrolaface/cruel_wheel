tool
class_name SingletonTable extends Resource

const _CLASS_NAME = "SingletonTable"
const _BASE_CLASS_NAME = "Singleton"

# properties
export(String) var name setget , get_name
export(int) var items_amount setget , get_items_amount
export(bool) var initialized setget , get_initialized
export(bool) var cached setget , get_cached
export(bool) var registered setget , get_registered
export(bool) var saved setget , get_saved
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed
export(bool) var has_items setget , get_has_items
export(bool) var has_name setget , get_has_name
export(bool) var has_manager setget , get_has_manager

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
		"has_manager": false,
		"has_items": false,
		"enabled": false,
		"destroyed": false
	}
}


# inherited private methods
func _init(_name = "", _self_ref = null, _manager = null, _enable = false):
	resource_local_to_scene = false
	if SingletonTableUtility.is_init_valid(_name, _self_ref, _manager):
		_data.name = _name
		_data.self_ref = _self_ref
		_data.manager_ref = _manager
		_data.cached = true
		_data.state.has_name = true
		_data.state.initialized = true
		_data.state.has_manager = true
		_data.state.enabled = _enable


# inhertied public methods
func is_class(_class: String):
	return _class == _BASE_CLASS_NAME or _class == _CLASS_NAME or _class == _data.name  #Singleton.CLASS_NAME


func get_class():
	return _CLASS_NAME


# public methods
func enable():
	_data.state.enabled = true


func add(_key: String, _value):
	var added = false
	if not _data.items.has(_key):
		_data.items[_key] = _on_item(_key, _value)
		added = _on_add()
	return added


func set_item(_key: String, _value):
	var set = false
	if _data.items.has(_key):
		_data.items[_key] = _on_item(_key, _value)
		set = true
	return set


func get_item(_key: String):
	var item = null
	if _on_get_kvp(_key):
		item = _data.items[_key]
	return item


func keys():
	return _data.items.keys


func values():
	return _data.items.values


func remove(_key: String):
	var removed = false
	if _on_get_kvp(_key):
		_data.items.erase(_key)
		removed = _on_remove()
		return removed


func clear():
	if _on_en_items():
		_data.items.clear()
		_data.amount = 0
		_on_has_no_items()


func disable():
	_data.state.enabled = false


func destroy():
	clear()
	disable()
	_data.state.destroyed = true


# private helper methods
func _on_item(_key: String, _value):
	var item = _data.items[_key]
	if _data.state.enabled && StringUtility.is_valid(_key) && not _value == null:
		item = _value
	return item


func _on_get_kvp(_key: String):
	return _on_en_items() && _data.items.has(_key)


func _on_en_items():
	return _data.state.enabled && _data.has_items


func _on_add():
	_data.amount = _data.amount + 1
	if not _data.state.has_items:
		_data.state.has_items = true
	return _data.state.has_items


func _on_remove():
	_data.amount = _data.amount - 1
	_on_has_no_items()
	return true


func _on_has_no_items():
	if _data.amount == 0:
		_data.state.has_items = false


# setters, getters functions
func get_name():
	return _data.name


func get_items_amount():
	return _data.amount


func get_initialized():
	return _data.state.initialized


func get_registered():
	return _data.state.registered


func get_cached():
	return _data.state.cached


func get_saved():
	return _data.state.saved


func get_enabled():
	return _data.state.enabled


func get_destroyed():
	return _data.state.destroyed


func get_has_items():
	return _data.state.has_items


func get_has_name():
	return _data.state.has_name


func get_has_manager():
	return _data.state.has_manager
