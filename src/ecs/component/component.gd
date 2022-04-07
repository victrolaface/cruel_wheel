#warning-ignore-all:unused_signal
class_name Component
extends Resource

signal enabled(name, id)
signal disabled(name, id)
signal destroyed(name, id)
signal parented(name, id)
signal initialized(name, id)

export(String) var name setget set_name, get_name
export(int) var id setget set_id, get_id

var meta: ComponentMetaData = null


func set_name(_name: String):
	if _valid_name(_name) && not _valid_name(meta.name):
		meta.name = _name


func _valid_name(_name: String):
	return _name != "" && _name != null


func _valid_id(_id: int):
	return _id != 0 && _id != null


func get_name():
	return meta.name


func set_id(_id: int):
	if _valid_id(_id) && not _valid_id(meta.id):
		meta.id = _id


func get_id():
	return meta.id


func _init():
	name = null
	id = null
	meta = ComponentMetaData.new()
	resource_local_to_scene = true


func initialize(_name: String, _id: int, _parent_init: bool, _is_local: bool):
	resource_local_to_scene = _is_local
	set_name(_name)
	set_id(_id)
	if _valid_name(name) && _valid_id(id):
		meta.initialize(name, id, _is_local)
		var emit_parented = false
		var connecting = true
		while connecting:
			meta.connected.parented = _connected("parented", "_parent", CONNECT_ONESHOT)
			emit_parented = meta.connected.parented
			connecting = emit_parented
			meta.connected.disabled = _connected("disabled", "_disable", CONNECT_DEFERRED)
			emit_parented = meta.connected.disabled
			connecting = emit_parented
			meta.connected.enabled = _connected("enabled", "_enable", CONNECT_DEFERRED)
			emit_parented = meta.connected.enabled
			connecting = emit_parented
			meta.connected.destroyed = _connected("destroyed", "_on_destroy", CONNECT_ONESHOT)
			emit_parented = meta.connected.destroyed
			connecting = emit_parented
			meta.connected.initialized = _connected("initialized", "_on_init", CONNECT_ONESHOT)
			emit_parented = meta.connected.initialized
			connecting = emit_parented
			connecting = not connecting
		if emit_parented:
			emit_signal("parented", meta.name, meta.id)


func _connected(_signal: String, _method: String, _flag: int):
	var _connected = false
	if not is_connected(_signal, self, _method):
		_connected = connect(_signal, self, _method, [], _flag)
	return _connected


func destroy():
	if meta.connected.destroyed:
		if meta.state.enabled:
			emit_signal("disabled", meta.name, meta.id)
		if not meta.state.enabled:
			emit_signal("destroyed", meta.name, meta.id)


func _parent():
	if meta.connected.parented && not meta.state.parented:
		meta.state.parented = meta.connected.parented
		meta.connected.parented = not meta.state.parented


func _enable():
	if meta.connected.enabled && not meta.state.enabled:
		meta.state.enabled = meta.connected.enabled


func _disable():
	if meta.connected.disabled && meta.state.enabled:
		meta.state.enabled = not meta.state.enabled


func _on_destroy():
	if meta.connected.destroyed && not meta.state.destroyed:
		meta.state.destroyed = meta.connected.destroyed
		meta.connected.destroyed = not meta.state.destroyed


func _on_init():
	if meta.connected.initialized && not meta.state.initialized:
		meta.state.initialized = meta.connected.initialized
		meta.connected.initialized = not meta.state.initialized
		emit_signal(meta.name, meta.id)
