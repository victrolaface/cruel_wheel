tool
class_name ResourceTable extends Resource

# properties
export(String) var name setget set_name, get_name
export(bool) var has_name setget , get_has_name
export(bool) var has_self_ref setget , get_has_self_ref
export(int) var items_amount setget , get_items_amount

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


func add(_key = "", _value = null):
	var added = false
	if not _data.items.has(_key):
		_data.items[_key] = _on_item(_key, _value)
		added = _on_add()
	return added


func enable(_db_ref = null, _manager = null):
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


# private helper methods
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
