#warning-ignore-all:unused_signal
tool
class_name Component extends Item

# virtual methods
func _init():
	resource_local_to_scene = true
	

# public methods
"""
func initialize(_is_local: bool):
	resource_local_to_scene = _is_local
	meta.is_local = resource_local_to_scene
	if meta.name != "" && meta.id != 0:
		var emit_parented = false
		var connecting = true
		while connecting:
			meta.connected.parented = _connect(
				meta.connected.parented, "parented", "_parent", CONNECT_ONESHOT
			)
			emit_parented = meta.connected.parented
			connecting = emit_parented
			meta.connected.disabled = _connect(
				meta.connected.disabled, "disabled", "_disable", CONNECT_DEFERRED
			)
			emit_parented = meta.connected.disabled
			connecting = emit_parented
			meta.connected.enabled = _connect(
				meta.connected.enabled, "enabled", "_enable", CONNECT_DEFERRED
			)
			emit_parented = meta.connected.enabled
			connecting = emit_parented
			meta.connected.destroyed = _connect(
				meta.connected.destroyed, "destroyed", "_on_destroy", CONNECT_ONESHOT
			)
			emit_parented = meta.connected.destroyed
			connecting = emit_parented
			meta.connected.initialized = _connect(
				meta.connected.initialized, "initialized", "_on_init", CONNECT_ONESHOT
			)
			emit_parented = meta.connected.initialized
			connecting = not connecting
		if emit_parented:
			emit_signal("parented", meta.name, meta.id)


func destroy():
	if meta.state.enabled:
		emit_signal("disabled", meta.name, meta.id)
	emit_signal("destroyed", meta.name, meta.id)


# helper methods
func _connect(_connected: bool, _signal: String, _method: String, _flag: int):
	if not _connected:
		if not is_connected(_signal, self, _method):
			_connected = connect(_signal, self, _method, [], _flag)
	return _connected


# signal functions
func _parent():
	meta.state.parented = true
	meta.connected.parented = not meta.state.parented


func _enable():
	meta.state.enabled = true


func _disable():
	meta.state.enabled = false


func _on_destroy():
	meta.state.destroyed = true
	meta.connected.destroyed = not meta.state.destroyed


func _on_init():
	meta.state.initialized = true
	meta.connected.initialized = not meta.state.initialized
	emit_signal(meta.name, meta.id)


# setters, getters functions
func set_name(_name: String):
	pass


func get_name():
	return meta.name


func set_id(_id: int):
	pass


func get_id():
	return meta.id


func set_is_local(_is_local: bool):
	pass


func get_is_local():
	return meta.is_local
"""