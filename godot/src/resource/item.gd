class_name Item extends Resource

signal named
signal entity_id_received
signal init_meta
signal is_init
signal is_enabled
signal is_disabled
signal is_destroyed

export(String) var name setget , get_name
export(int) var entity_id setget set_entity_id, get_entity_id
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed

var meta_data: Dictionary


# signal methods
func _on_cached():
	meta_data.state.cached = true


func _on_named():
	meta_data.state.named = true


func _on_entity_id_received():
	meta_data.state.has_entity_id = true
	if not meta_data.state.init_meta && meta_data.state.cached && meta_data.state.named:
		emit_signal("init_meta")


func _on_init_meta():
	meta_data.state.meta_init = true
	emit_signal("is_init")


func _on_init():
	meta_data.state.init = true
	emit_signal("is_enabled")


func _on_enabled():
	meta_data.state.enabled = true


func _on_disabled():
	meta_data.state.enabled = false


func _on_destroyed():
	meta_data.state.destroyed = true


func _init(_name = "", _ref_self = null):
	resource_local_to_scene = true
	var cache_connect = _init_connect("cached", "_on_cached", CONNECT_ONESHOT)
	var name_connect = _init_connect("named", "_on_named", CONNECT_ONESHOT)
	var ent_id_connect = _init_connect("entity_id_received", "_on_entity_id_received", CONNECT_ONESHOT)
	var meta_init_connect = _init_connect("init_meta", "_on_init_meta", CONNECT_ONESHOT)
	var init_connect = _init_connect("is_init", "_on_init", CONNECT_ONESHOT)
	var enable_connect = _init_connect("is_enabled", "_on_enabled", CONNECT_DEFERRED)
	var disable_connect = _init_connect("is_disabled", "_on_disabled", CONNECT_DEFERRED)
	var destroy_connect = _init_connect("is_destroyed", "_on_destroyed", CONNECT_ONESHOT)
	meta_data = {
		"name": _name,
		"ref_self": _ref_self,
		"entity_id": 0,
		"state":
		{
			"cached_connected": cache_connect,
			"named_connected": name_connect,
			"entity_id_received_connected": ent_id_connect,
			"init_meta_connected": meta_init_connect,
			"is_init_connected": init_connect,
			"is_enabled_connected": enable_connect,
			"is_disabled_connected": disable_connect,
			"is_destroyed_connected": destroy_connect,
			"named": false,
			"has_entity_id": false,
			"cached": false,
			"meta_init": false,
			"init": false,
			"enabled": false,
			"destroyed": false
		}
	}
	var init_valid = (
		meta_data.state.cached_connected
		&& meta_data.state.named_connected
		&& meta_data.state.entity_id_received_connected
		&& meta_data.state.init_meta_connected
		&& meta_data.state.is_init_connected
		&& meta_data.state.is_enabled_connected
		&& meta_data.state.is_disabled_connected
		&& meta_data.state.is_destroyed_connected
	)
	if init_valid:
		emit_signal("cached")
		emit_signal("named")


# _init helper methods
func _init_connect(_signal_name: String, _method: String, _flags: int):
	return SignalUtility.is_connect_valid(_signal_name, self, null, _method, [], _flags)


# public methods
func enable():
	if not self.enabled && self.initialized && not self.destroyed:
		emit_signal("is_enabled")


func disable():
	if self.enabled && self.initialized && not self.destroyed:
		emit_signal("is_disabled")


func destroy():
	disable()
	emit_signal("is_destroyed")


# setters, getters functions
func get_name():
	if meta_data.state.named:
		return meta_data.name


func set_entity_id(_entity_id: int):
	if not meta_data.state.has_entity_id && EntityUtility.is_valid(_entity_id):
		meta_data.entity_id = _entity_id
		emit_signal("entity_id_received")


func get_entity_id():
	if meta_data.state.has_entity_id:
		return meta_data.entity_id


func get_initialized():
	return meta_data.state.init


func get_enabled():
	return meta_data.state.enabled


func get_destroyed():
	return meta_data.state.destroyed
