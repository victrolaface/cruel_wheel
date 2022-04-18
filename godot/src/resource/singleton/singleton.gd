tool
class_name Singleton extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var is_editor_only setget , get_is_editor_only

# fields
var _has_name setget , _get_has_name
var _has_path setget , _get_has_path
var _cached setget , _get_cached
var _cached_manager setget , _get_cached_manager

const _BASE_CLASS_NAME = "Singleton"

var _data = {
	"name": "",
	"path": "",
	"self_ref": null,
	"manager_ref": null,
	"state": {"is_editor_only": false, "initialized": false, "enabled": false, "destroyed": false}
}


# inherited methods private
func _init(_name = "", _path = "", _self_ref = null, _mgr_ref = null, _editor_only = false, _enbl = false):
	_data.name = _name
	_data.path = _path
	_data.self_ref = _self_ref
	_data.manager_ref = _mgr_ref
	_data.state.is_editor_only = _editor_only
	_data.initialized = self._has_name && self._has_path && self._cached && self._cached_manager
	_data.enabled = _data.initialized && _enbl


# public methods
func is_class(_class):
	return (self._has_name && _class == _data.name) || _class == _BASE_CLASS_NAME


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
func get_enabled():
	return _data.state.enabled


func get_is_editor_only():
	return _data.state.is_editor_only


# setters, getters private
func _get_has_name():
	return StringUtility.is_valid(_data.name)


func _get_has_path():
	return PathUtility.is_valid(_data.path)


func _get_cached():
	return SingletonUtility.is_valid(_data.self_ref)


func _get_cached_manager():
	return SingletonUtility.is_manager_valid(_data.manager_ref)
