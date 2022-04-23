tool
class_name Singleton extends Resource

const _BASE_CLASS_NAME = "Singleton"

# properties
export(bool) var is_singleton setget , get_is_singleton
export(bool) var saved setget , get_saved
export(bool) var enabled setget , get_enabled
export(bool) var initialized setget , get_initialized
export(bool) var destroyed setget , get_destroyed
export(bool) var registered setget , get_registered
export(bool) var editor_only setget set_editor_only, get_editor_only
export(bool) var has_path setget , get_has_path
export(bool) var has_name setget , get_has_name
export(bool) var cached setget , get_cached
export(bool) var has_manager setget , get_has_manager
export(bool) var emit_changed_connected setget , get_emit_changed_connected
export(String) var name setget , get_name
export(String) var path setget , get_path

var _data = {
	"name": "",
	"path": "",
	"self_ref": null,
	"manager_ref": null,
	"state":
	{
		"editor_only": false,
		"has_name": false,
		"cached": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"initialized": false,
		"enabled": false,
		"registered": false,
		"saved": false,
		"destroyed": false,
		"emit_changed_connected": false
	}
}


func get_emit_changed_connected():
	return _data.state.emit_changed_connected


# inherited methods private
func _init(_self_ref = null):
	if SingletonUtility.is_init_valid(_self_ref):
		_data.name = _self_ref.resource_name
		_data.path = _self_ref.resource_path
		_data.self_ref = _self_ref
		_data.state.has_self_ref = true
		_data.state.has_path = true
		_data.state.has_name = true
		_data.state.cached = true
		if not self.is_connected("emit_changed", self, "_on_changed"):
			if self.connect("emit_changed", self, "_on_changed", [], CONNECT_DEFERRED):
				_data.state.emit_changed_connected = true
		emit_changed()


func init_from_manager(_mgr_ref = null, _enable = false):
	if SingletonUtility.is_init_from_mgr_valid(self, _mgr_ref):
		_data.manager_ref = _mgr_ref
		_data.has_manager = true
		_data.state.initialized = true
		_data.state.enabled = _enable
		register()
		emit_changed()
		save()


func _on_changed():
	if _data.state.saved:
		_data.state.saved = false


# public methods
func is_class(_class):
	return (_data.state.has_name && _class == _data.name) || _class == _BASE_CLASS_NAME


func get_class():
	return _BASE_CLASS_NAME


func enable():
	if _data.state.initialized && not _data.state.enabled:
		_data.state.enabled = true
		emit_changed()


func disable():
	if _data.state.enabled:
		unregister()
		_data.name = ""
		_data.path = ""
		_data.self_ref = null
		_data.manager_ref = null
		_data.state.has_name = false
		_data.state.cached = false
		_data.state.has_self_ref = false
		_data.state.has_manager_ref = false
		_data.state.initialized = false
		_data.state.enabled = false
		emit_changed()
		_disconnect_emit_changed()


func register():
	var _registered = false
	if _data.state.enabled && not _data.state.registered:
		_data.state.registered = true
		_registered = true
		emit_changed()
	return _registered


func unregister():
	if _data.state.enabled && _data.state.registered:
		_data.state.registered = false
		emit_changed()


func save():
	if _data.state.enabled && _data.state.registered && not _data.state.saved:
		_data.state.saved = true


func destroy():
	if _data.state.enabled:
		disable()
	_data.state.destroyed = true


func _disconnect_emit_changed():
	if _data.state.emit_changed_connected && self.is_connected("emit_changed", self, "_on_changed"):
		if self.disconnect("emit_changed", self, "_on_changed"):
			_data.state.emit_changed_connected = false


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


func set_editor_only(_editor_only: bool):
	_data.state.editor_only = _editor_only


func get_editor_only():
	return _data.state.editor_only


func get_has_name():
	return _data.state.has_name


func get_has_path():
	return _data.state.has_path


func get_cached():
	return _data.state.cached


func get_has_manager():
	return _data.state.has_manager_ref


func get_initialized():
	return _data.state.initialized


func get_saved():
	return _data.state.saved


func get_destroyed():
	return _data.state.destroyed


func get_registered():
	return _data.state.registered


func get_enabled():
	return _data.state.enabled
