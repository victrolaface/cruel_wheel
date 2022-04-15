"""
class_name Item extends Resource

# signals
signal is_initialized
signal is_enabled
signal is_disabled
signal is_destroyed

# properties
export(String) var name setget , get_name
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed

# fields
var itm_data: Dictionary


# default methods
func _init(_name = "", _ref_self = null):
	make_local()
	var init_connect = SignalUtility.is_self_connect_valid("is_initialized", self, "_on_initialized", CONNECT_ONESHOT)
	var enable_connect = SignalUtility.is_self_connect_valid("is_enabled", self, "_on_enabled", CONNECT_DEFERRED)
	var disable_connect = SignalUtility.is_self_connect_valid("is_disabled", self, "_on_disabled", CONNECT_DEFERRED)
	var destroy_connect = SignalUtility.is_self_connect_valid("is_destroyed", self, "_on_destroyed", CONNECT_ONESHOT)
	itm_data = {
		"name": _name,
		"ref_self": _ref_self,
		"state":
		{
			"initialized_connected": init_connect,
			"enabled_connected": enable_connect,
			"disabled_connected": disable_connect,
			"destroyed_connected": destroy_connect,
			"initialized": false,
			"enabled": false,
			"destroyed": false
		}
	}
	var init_valid = (
		ObjectUtility.is_valid(itm_data.ref_self)
		&& StringUtility.is_valid(itm_data.name)
		&& itm_data.state.initialized_connected
		&& itm_data.state.enabled_connected
		&& itm_data.state.disabled_connected
		&& itm_data.state.destroyed_connected
	)
	if init_valid:
		emit_signal("is_initialized")


# helper methods
func _can_enable(_enabled: bool):
	return not _enabled == itm_data.state.enabled && itm_data.state.initialized && not itm_data.state.destroyed


# signal methods
func _on_initialized():
	itm_data.state.initialized = true
	if not itm_data.state.enabled && not itm_data.state.destroyed:
		emit_signal("is_enabled")


func _on_enabled():
	itm_data.state.enabled = true


func _on_disabled():
	itm_data.state.enabled = false


func _on_destroyed():
	itm_data.state.destroyed = true


# setters, getters functions
func get_name():
	if self.initialized:
		return itm_data.name


func get_initialized():
	return itm_data.state.init


func get_enabled():
	return itm_data.state.enabled


func get_destroyed():
	return itm_data.state.destroyed


# public methods
func make_local():
	if not resource_local_to_scene:
		resource_local_to_scene = true


func enable():
	if _can_enable(true):
		emit_signal("is_enabled")


func disable():
	if _can_enable(false):
		emit_signal("is_disabled")


func _destroy(_do: bool):
	if _do:
		disable()
		emit_signal("is_destroyed")
"""