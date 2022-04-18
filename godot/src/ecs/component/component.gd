tool
class_name Component extends Resource

# signals
signal received_entity
signal received_entity_id
signal is_named
signal is_initialized
signal is_enabled
signal is_disabled
signal is_destroyed

# properties
export(String) var name setget , get_name
export(Resource) var entity setget , get_parent_entity
export(int) var entity_id setget , get_parent_entity_id
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var destroyed setget , get_destroyed

# fields
var data: Dictionary
const COMPONENT_TYPE = "Component"


# default methods
func _init(_ref_entity = null, _entity_id = 0, _name = "", _ref_self = null):
	make_local()
	var ent = SignalUtility.is_self_connect_valid("received_entity", self, "_on_received_entity", CONNECT_ONESHOT)
	var ent_id = SignalUtility.is_self_connect_valid("received_entity_id", self, "_on_received_entity_id", CONNECT_ONESHOT)
	var nmed = SignalUtility.is_self_connect_valid("is_named", self, "_on_named", CONNECT_ONESHOT)
	var init = SignalUtility.is_self_connect_valid("is_initialized", self, "_on_initialized", CONNECT_ONESHOT)
	var enbl = SignalUtility.is_self_connect_valid("is_enabled", self, "_on_enabled", CONNECT_DEFERRED)
	var dsbl = SignalUtility.is_self_connect_valid("is_disabled", self, "_on_disabled", CONNECT_DEFERRED)
	var dstr = SignalUtility.is_self_connect_valid("is_destroyed", self, "_on_destroyed", CONNECT_ONESHOT)
	data = {
		"name": _name,
		"ref_self": _ref_self,
		"ref_entity": _ref_entity,
		"entity_id": _entity_id,
		"state":
		{
			"received_entity_connected": ent,
			"received_entity_id_connected": ent_id,
			"named_connected": nmed,
			"initialized_connected": init,
			"enabled_connected": enbl,
			"disabled_connected": dsbl,
			"destroyed_connected": dstr,
			"has_name": false,
			"has_ref_self": false,
			"has_entity": false,
			"has_entity_id": false,
			"initialized": false,
			"enabled": false,
			"destroyed": false
		}
	}
	var valid_init = (
		StringUtility.is_valid(data.name)
		#&& ObjectUtility.is_valid(data.ref_self)
		#&& ObjectUtility.is_valid(data.ref_entity)
		#&& EntityUtility.is_id_valid(data.entity_id)
		&& data.state.received_entity_connected
		&& data.state.received_entity_id_connected
		&& data.state.named_connected
		&& data.state.initialized_connected
		&& data.state.enabled_connected
		&& data.state.disabled_connected
		&& data.state.destroyed_connected
	)
	if valid_init:
		emit_signal("received_entity")
		emit_signal("received_entity_id")
		emit_signal("is_named")
		emit_signal("is_initialized")


# helper methods
func _can_enable(_enabled: bool):
	return not _enabled == data.state.enabled && data.state.initialized && not data.state.destroyed


# signal methods
func _on_received_parent_entity():
	data.state.has_parent_entity = true
	data.state.received_parent_entity_connected = false


func _on_received_entity_id():
	data.state.has_entity_id = true
	data.state.received_parent_entity_id_connected = false


func _on_named():
	data.state.has_name = true
	data.state.named_connected = false


func _on_initialized():
	data.state.initialized = true
	if not data.state.enabled && not data.state.destroyed:
		emit_signal("is_enabled")


func _on_enabled():
	data.state.enabled = true
	#func set_enabled(p_enable: bool) -> void:
	#if data.state.enabled == _enabled#p_enable:
	#	return
	#enabled = _enabled#p_enable
	#if _enabled#p_enable:
	#	_on_enable()
	#	owner._add_to_callbacks()
	#else:
	#	_on_disable()
	#	owner._remove_from_callbacks()

	#emit_signal("entity_add_to_components")


func _on_disabled():
	data.state.enabled = false
	#emit_signal("entity_disable_from_components")


func _on_destroyed():
	data.state.destroyed = true
	data.state.destroyed_connected = false


# setters, getters functions
func get_type():
	return COMPONENT_TYPE


func get_parent_entity():
	if data.state.has_parent_entity:
		return data.ref_entity


func get_parent_entity_id():
	if data.state.has_parent_entity_id:
		return data.entity_id


func get_name():
	if data.state.initialized:
		return data.name


func get_initialized():
	return data.state.initialized


func set_enabled(_enabled: bool):
	if _enabled && not data.state.enabled:
		emit_signal("is_enabled")
	elif not _enabled && data.state.enabled:
		emit_signal("is_disabled")


func get_enabled():
	return data.state.enabled


func get_destroyed():
	return data.state.destroyed


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


func _destroy():  #_do: bool):
	disable()
	emit_signal("is_destroyed")


func is_type(_type):
	return _type == COMPONENT_TYPE or .is_type(_type)
