tool
class_name Singleton extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var is_editor_only setget , get_is_editor_only
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var cached setget , get_cached
export(bool) var has_manager setget , get_has_manager
export(String) var name setget , get_name
export(String) var path setget , get_path

# fields
const _BASE_CLASS_NAME = "Singleton"

var _data = {
	"name": "",
	"path": "",
	"self_ref": null,
	"manager_ref": null,
	"state":
	{
		"is_editor_only": false,
		"has_name": false,
		"has_path": false,
		"cached": false,
		"has_manager": false,
		"initialized": false,
		"enabled": false,
		"destroyed": false
	}
}


# inherited methods private
func _init(_name = "", _path = "", _self_ref = null, _mgr_ref = null, _editor_only = false):
	if SingletonUtility.is_params_valid(_name, _path, _self_ref, _mgr_ref):
		_data.name = _name
		_data.path = _path
		_data.self_ref = _self_ref
		_data.manager_ref = _mgr_ref
		_data.state.is_editor_only = _editor_only
		_data.state.has_name = true
		_data.state.has_path = true
		_data.state.cached = true
		_data.state.has_manager = true
		_data.state.initialized = true
		_data.state.enabled = true


# public methods
func is_class(_class):
	return (_data.state.has_name && _class == _data.name) || _class == _BASE_CLASS_NAME


func get_class():
	return _BASE_CLASS_NAME


# callbacks
func awake():
	pass


func on_enable():
	pass


func on_disable():
	pass


func enter_tree():
	pass


func exit_tree():
	pass


func ready():
	pass


func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


func input(_event: InputEvent):
	pass


func unhandled_input(_event: InputEvent):
	pass


func unhandled_key_input(_event: InputEvent):
	pass


# setters, getters public
func get_name():
	return _data.name


func get_path():
	return _data.path


func get_is_editor_only():
	return _data.state.is_editor_only


func get_has_name():
	return _data.state.has_name


func get_has_path():
	return _data.state.has_path


func get_cached():
	return _data.state.cached


func get_has_manager():
	return _data.state.has_manager


func get_enabled():
	return _data.state.enabled
