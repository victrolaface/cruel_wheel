class_name Component extends Resource

# signals
signal received_parent_entity
signal received_parent_entity_id
signal is_initialized
signal is_enabled
signal is_disabled
signal is_destroyed

# properties
export(String) var name setget , get_name
export(Resource) var parent_entity setget , get_parent_entity
export(int) var parent_entity_id setget , get_parent_entity_id
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed

# fields
var cmpnt_data: Dictionary

# default methods
func _init(_ref_entity = null, _entity_id = 0, _name = "", _ref_self = null):
	make_local()
	var init_connect = SignalUtility.is_self_connect_valid("is_initialized", self, "_on_initialized", CONNECT_ONESHOT)
	var enable_connect = SignalUtility.is_self_connect_valid("is_enabled", self, "_on_enabled", CONNECT_DEFERRED)
	var disable_connect = SignalUtility.is_self_connect_valid("is_disabled", self, "_on_disabled", CONNECT_DEFERRED)
	var destroy_connect = SignalUtility.is_self_connect_valid("is_destroyed", self, "_on_destroyed", CONNECT_ONESHOT)
	#
	var entity_connected = SignalUtility.is_self_connect_valid(
		"received_parent_entity", self, "_on_received_parent_entity", CONNECT_ONESHOT
	)
	var entity_id_connected = SignalUtility.is_self_connect_valid(
		"received_parent_entity_id", self, "_on_received_entity_id", CONNECT_ONESHOT
	)
	cmpnt_data = {
		"name": _name,
		"ref_self": _ref_self,
		"ref_entity": _ref_entity,
		"entity_id": _entity_id,
		"state":
		{
			"initialized_connected": init_connect,
			"enabled_connected": enable_connect,
			"disabled_connected": disable_connect,
			"destroyed_connected": destroy_connect,
			"received_parent_entity_connected": entity_connected,
			"received_parent_entity_id_connected": entity_id_connected,
			"has_parent_entity": false,
			"has_parent_entity_id": false,
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
		&& cmpnt_data.state.initialized_connected
		&& cmpnt_data.state.enabled_connected
		&& cmpnt_data.state.disabled_connected
		&& cmpnt_data.state.destroyed_connected
		&& cmpnt_data.state.received_parent_entity_connected
		&& cmpnt_data.state.received_parent_entity_id_connected
	)
	if valid_init:
		emit_signal("received_parent_entity")
		emit_signal("received_parent_entity_id")
		if cmpnt_data.state.has_parent_entity && cmpnt_data.state.has_parent_entity_id:
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
#

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


# setters, getters functions
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


func _destroy():#_do: bool):
	disable()
	emit_signal("is_destroyed")
