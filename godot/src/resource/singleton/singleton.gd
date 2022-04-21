tool
class_name Singleton extends Resource

# properties
export(bool) var is_singleton setget , get_is_singleton
export(bool) var enabled setget , get_enabled
export(bool) var initialized setget , get_initialized
export(bool) var destroyed setget , get_destroyed
export(bool) var registered setget , get_registered
export(bool) var is_editor_only setget , get_is_editor_only
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var cached setget , get_cached
export(bool) var has_manager setget , get_has_manager
export(String) var name setget , get_name
export(String) var path setget , get_path
export(String) var persistent_path setget , get_persistent_path

# fields
const _PERSISTENT_PATH = "res://data/singleton_db.tres"

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
		"registered": false,
		"destroyed": false
	}
}


# inherited methods private
func _init(_name = "", _self_ref = null, _mgr_ref = null, _editor_only = false):
	resource_local_to_scene = false
	if SingletonUtility.is_params_valid(_name, _self_ref, _mgr_ref):
		_data.name = _name  #_self_ref.get_name()
		_data.path = _self_ref.resource_path
		_data.self_ref = _self_ref
		_data.manager_ref = _mgr_ref
		_data.state.is_editor_only = _editor_only
		_data.state.has_name = true
		_data.state.has_path = true
		_data.state.cached = true
		_data.state.has_manager = true
		_data.state.initialized = true


# public methods
func is_class(_class):
	return (_data.state.has_name && _class == _data.name) || _class == SingletonUtility.BASE_CLASS_NAME  #_BASE_CLASS_NAME


func get_class():
	return SingletonUtility.BASE_CLASS_NAME


func enable():
	if _data.state.initialized && not _data.state.enabled:
		_data.state.enabled = true


func disable():
	if _data.state.initialized && _data.state.enabled:
		_data.state.enabled = false


func register():
	if _data.state.initialized && not _data.state.registered:
		_data.state.registered = true


func unregister():
	if _data.state.initialized && _data.state.registered:
		_data.state.registered = false


func destroy():
	if _data.state.enabled:
		disable()
	unregister()
	_data.state.destroyed = true


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
func get_is_singleton():
	return true


func get_name():
	return _data.name


func get_path():
	return _data.path


func get_persistent_path():
	return _PERSISTENT_PATH


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


func get_initialized():
	return _data.state.initialized


func get_destroyed():
	return _data.state.destroyed


func get_registered():
	return _data.state.registered


func get_enabled():
	return _data.state.enabled
