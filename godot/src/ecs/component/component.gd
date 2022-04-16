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
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed

# fields
var cmpnt_data: Dictionary
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
	cmpnt_data = {
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
		StringUtility.is_valid(cmpnt_data.name)
		&& ObjectUtility.is_valid(cmpnt_data.ref_self)
		&& ObjectUtility.is_valid(cmpnt_data.ref_entity)
		&& EntityUtility.is_id_valid(cmpnt_data.entity_id)
		&& cmpnt_data.state.received_entity_connected
		&& cmpnt_data.state.received_entity_id_connected
		&& cmpnt_data.state.named_connected
		&& cmpnt_data.state.initialized_connected
		&& cmpnt_data.state.enabled_connected
		&& cmpnt_data.state.disabled_connected
		&& cmpnt_data.state.destroyed_connected
	)
	if valid_init:
		emit_signal("received_entity")
		emit_signal("received_entity_id")
		emit_signal("is_named")
		emit_signal("is_initialized")


# helper methods
func _can_enable(_enabled: bool):
	return not _enabled == cmpnt_data.state.enabled && cmpnt_data.state.initialized && not cmpnt_data.state.destroyed


# signal methods
func _on_received_parent_entity():
	cmpnt_data.state.has_parent_entity = true
	cmpnt_data.state.received_parent_entity_connected = false


func _on_received_entity_id():
	cmpnt_data.state.has_entity_id = true
	cmpnt_data.state.received_parent_entity_id_connected = false


func _on_named():
	cmpnt_data.state.has_name = true
	cmpnt_data.state.named_connected = false


func _on_initialized():
	cmpnt_data.state.initialized = true
	if not cmpnt_data.state.enabled && not cmpnt_data.state.destroyed:
		emit_signal("is_enabled")


func _on_enabled():
	cmpnt_data.state.enabled = true


func _on_disabled():
	cmpnt_data.state.enabled = false


func _on_destroyed():
	cmpnt_data.state.destroyed = true
	cmpnt_data.state.destroyed_connected = false


# setters, getters functions
func get_type():
	return COMPONENT_TYPE


func get_parent_entity():
	if cmpnt_data.state.has_parent_entity:
		return cmpnt_data.ref_entity


func get_parent_entity_id():
	if cmpnt_data.state.has_parent_entity_id:
		return cmpnt_data.entity_id


func get_name():
	if cmpnt_data.state.initialized:
		return cmpnt_data.name


func get_initialized():
	return cmpnt_data.state.initialized


func get_enabled():
	return cmpnt_data.state.enabled


func get_destroyed():
	return cmpnt_data.state.destroyed


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
