tool
class_name ResourceTable extends Resource

# properties
export(String) var name setget set_name, get_name
export(bool) var has_name setget , get_has_name
export(bool) var has_self_ref setget , get_has_self_ref

# fields
var _data = {
	"name": "",
	"self_ref": null,
	"db_ref": null,
	"manager_ref": null,
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

const _CLASS_NAME = "ResourceTable"
const _BASE_CLASS_NAME = "Resource"


# private inherited methods
func _init(_self_ref = null):
	_data.self_ref = _self_ref
	_data.name = _init_name()
	_data.state.has_name = _init_has_name()
	_data.state.has_self_ref = _init_has_self_ref()


# inherited public methods
func is_class(_class):
	return _class == _data.name or _class == _CLASS_NAME or _class == _BASE_CLASS_NAME


func get_class():
	return _CLASS_NAME


# public methods
func init_from_manager(_db_ref = null, _manager_ref = null, _name = "", _self_ref = null):
	var init_self_ref = not _data.state.has_self_ref
	if not _data.state.has_name or init_self_ref:
		if init_self_ref:
			_data.self_ref = _self_ref
			_data.name = _init_name()
			_data.state.has_self_ref = _init_has_self_ref()
		else:
			_data.name = _name
		_data.state.has_name = _init_has_name()
	_data.db_ref = _db_ref
	_data.manager_ref = _manager_ref
	_data.state.has_db_ref = _is_obj_valid(_data.db_ref)
	_data.state.has_manager_ref = _is_obj_valid(_data.manager_ref)
	var ds = _data.state
	_data.state.cached = ds.has_name && ds.has_self_ref && ds.has_db_ref && ds.has_manager_ref
	_data.state.initialized = _data.state.cached
	_data.state.enabled = _data.state.initialized
	return _data.state.enabled


# private helper methods
func _init_name():
	return _data.self_ref.resource_name


func _init_has_name():
	return StringUtility.is_valid(_data.name)


func _init_has_self_ref():
	return _is_obj_valid(_data.self_ref)


func _is_obj_valid(_obj = null):
	return not _obj == null


# setters, getters functions
func set_name(_name = ""):
	_data.name = _name


func get_name():
	return _data.name


func get_has_name():
	return _data.state.has_name


func get_has_self_ref():
	return _data.state.has_self_ref
