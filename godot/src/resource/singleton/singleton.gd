# ===========================================================================================

"""
tool
class_name Singleton extends Resource

# signals
#signal is_enabled
#signal is_disabled
#signal is_destroyed

enum SINGLETON_STATE { NONE = 0, INITIALIZED = 1, ENABLED = 2, DISABLED = 3, DESTROYED = 4 }

# properties
#export(Resource) var manager setget set_manager, get_manager
export(String) var name setget , get_name
export(String) var path setget , get_path
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var destroyed setget , get_destroyed
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var is_editor_only setget , get_is_editor_only
#export(SINGLETON_STATE) var state setget , get_state

var _has_manager setget , _get_has_manager
var _is_cached setget , _get_is_cached
#func get_state():
#	return _data.state.current


func _get_has_manager():
	return not _data.ref_manager == null && _data.manager_ref.get_class() == "SingletonManager"


func get_has_name():
	return StringUtility.is_valid(_data.name)


func _get_is_cached():
	var cached = not _data.self_ref == null && self.has_name && self.has_path
	if cached:
		cached = _data.self_ref.is_class(_data.name) && _data.self_ref.resource_path() == _data.path
	return cached


func get_destroyed():
	return _data.state == SINGLETON_STATE.DESTROYED


func get_has_path():
	return StringUtility.is_valid(_data.path)


# fields
var _data = {
	"manager_ref": null,
	"self_ref": null,
	"name": "",
	"path": "",
	"state":
	{
		"current": SINGLETON_STATE.NONE,
		"is_editor_only": false
		#"is_enabled_connected": false,
		#"is_disabled_connected": false,
		#"is_destroyed_connected": false,
		#"has_name": false,
		#"has_path": false,
		#"has_manager": false,
		#"has_ref": false,
		#"enabled": false,
		#"destroyed": false,
		#"initialized": false
	}
}
func _is_manager_valid(_manager: SingletonManager):
	return not _manager == null && _manager.get_class() == "SingletonManager"

func _is_cached_valid(_self_ref):#:Resource):
"""
#return not _self_ref == null && _is_name_valid(_self_ref) && _is_path_valid(_self_ref)

#func _is_name_valid(_self_ref):#L:Resource):
#var name_valid = StringUtility.is_valid(_self_ref.resource_name)
#if name_valid:

#return StringUtility.is_valid()

#func _is_path_valid(_self_ref):#::Resource):
"""
func _init(_manager_ref = null, _self_ref = null, _editor_only = false, _enable = false):
	_data.manager_ref = _manager_ref
	_data.self_ref = _self_ref
	var init_valid = _is_manager_valid(_data.manager_ref) && _is_cached_valid(_data.self_ref)
	#var mgr_valid = not _data.manager_ref == null && _data.manager_ref.get_class() == "SingletonManager"
	if _data._self_ref == null
"""

#self.manager = _manager
"""
func _get_can_set():
	return not _data.state.current == SINGLETON_STATE.NONE


func is_class(_class: String):
	var _is_class = false
	if self._can_set:
		_is_class = (self.has_name && _data.name == _class) or _class == get_class()
	return _is_class


func get_class():
	return "Singleton"
"""

# setters, getters functions
"""
func set_manager(_manager: SingletonManager):
	if self._can_set && not self.has_manager && not _manager == null && _manager.get_class() == "SingletonManager":
		_data.manager_ref = _manager


func get_manager():
	return _data.ref_manager
"""

#func get_singleton(_singleton: Singleton):
#	var singleton = null
#	if _data.state.has_manager:
#		singleton = _data.ref_manager.get_singleton(_singleton)
#	return singleton

"""
func set_enabled(_enabled: bool):
	match _data.state.current:
		SINGLETON_STATE.INITIALIZED:
			if _enabled:
				_data.state.current = SINGLETON_STATE.ENABLED
			else:
				_data.state.current = SINGLETON_STATE.DISABLED
		SINGLETON_STATE.ENABLED:
			if not _enabled:
				_data.state.current = SINGLETON_STATE.DISABLED
		SINGLETON_STATE.DISABLED:
			if _enabled:
				_data.state.current = SINGLETON_STATE.ENABLED
		_:
			pass
"""
#if not _data.state.enabled == enabled:
#	if _enabled:
#		_emit_deferred("is_enabled")
#	else:
#		_emit_deferred("is_disabled")

"""
func get_enabled():
	return _data.state.current == SINGLETON_STATE.ENABLED


func get_path():
	return _data.path

func get_name():
	return _data.name
"""

#func get_has_path():
#	return _data.state.has_path

"""
func get_is_editor_only():
	return _data.state.is_editor_only
"""

# setters, getters helper utility functions

"""
func _is_enabled_connected():
	return SignalUtility.is_self_connect_valid("is_enabled", self, "_on_is_enabled", CONNECT_DEFERRED)


func _is_disabled_connected():
	return SignalUtility.is_self_connect_valid("is_disabled", self, "_on_is_disabled", CONNECT_DEFERRED)


func _manager_is_valid(_manager: Resource):
	return ResourceUtility.is_valid(_manager)


# public methods
func enable():
	_emit_deferred("is_enabled")


func _on_is_enabled():
	_data.state.current = SINGLETON_STATE.ENABLED
	_data.state.enabled = true


func disable():
	_emit_deferred("is_disabled")


func _on_is_disabled():
	_data.state.current = SINGLETON_STATE.DISABLED
	_data.state.enabled = false


func _emit_deferred(_signal: String):
	if _data.state.initialized:
		emit_signal(_signal)


func _on_is_destroyed():
	_data.state.current = SINGLETON_STATE.DESTROYED
	_data.state.destroyed = true


func destroy():
	if not _data.state.destroyed:
		_emit_deferred("is_disabled")
		if not _data.state.enabled:
			var enbl_dcon = SignalUtility.is_self_disconnect("is_enabled", self, "_on_is_enabled")
			var dsbl_dcon = SignalUtility.is_self_disconnect("is_disabled", self, "_on_is_disabled")
			if enbl_dcon && dsbl_dcon:
				_data.state.is_enabled_connected = not enbl_dcon
				_data.state.is_disabled_connected = not dsbl_dcon
				emit_signal("is_destroyed")

"""
# inherited methods

#_data.ref_manager = _on_valid_manager(_manager)
#

#
#_data.state.is_editor_only = _editor_only
#var enbl = _is_enabled_connected()
#var dsbl = _is_disabled_connected()
#var dstry = SignalUtility.is_self_connect_valid("is_destroyed", self, "_on_is_destroyed", CONNECT_ONESHOT)
#var connected = enbl && dsbl && dstry
#var managed = _data.has_path && _data.has_manager
#if connected && managed:
#	_data.state.is_enabled_connected = enbl
#	_data.state.is_disabled_connected = dsbl
#	_data.state.is_destroyed_connected = dstry
#	_data.state.current = SINGLETON_STATE.INITIALIZED
#	_data.state.initialized = true
#	if _enable:
#		emit_signal("is_enabled")
"""

func _awake():
	pass


func _on_enable():
	pass


func _on_disable():
	pass


func _enter_tree():
	pass


func _exit_tree():
	pass


func _ready():
	pass


func _process(_delta: float):
	pass


func _physics_process(_delta: float):
	pass


func _input(_event: InputEvent):
	pass


func _unhandled_input(_event: InputEvent):
	pass


func _unhandled_key_input(_event: InputEvent):
	pass
"""
