extends Node

#warning-ignore-all:unused_signal
signal initialized(id)
signal enabled(id)
signal disabled(id)

const SINGLETON_MANAGER_PATH = "res://src/singleton_manager.gd"

var id = null
var has_id = false
var is_enabled = false
var is_initialized = false
var init_connected = false
var enabled_connected = false
var disabled_connected = false

var storage = preload("res://src/singleton/singleton_manager_storage.gd")


func _init():
	if not is_initialized:
		if not has_id:
			id = get_instance_id()
			has_id = id != null
		if has_id:
			if not is_enabled:
				enabled_connected = _connected(enabled_connected, "enabled", "_enable")
			if not disabled_connected:
				disabled_connected = _connected(disabled_connected, "disabled", "_disable")
			if not init_connected:
				init_connected = _connected(init_connected, "initialized", "_initialize", true)
			if is_enabled && disabled_connected && init_connected:
				if storage.pushed("SingletonManager", SINGLETON_MANAGER_PATH, self):
					emit_signal("initialized", id)
	else:
		if not is_enabled:
			emit_signal("enabled", id)


func _ready():
	_init()


func _enter_tree():
	_init()


func _exit_tree():
	emit_signal("disabled", id)


func _connected(_is_connected: bool, _signal: String, _method: String, _oneshot = false):
	var connected = false
	if not _is_connected:
		if not is_connected(_signal, self, _method):
			if not _oneshot:
				connected = connect(_signal, self, _method)
				emit_signal(_signal, id)
			else:
				connected = connect(_signal, self, _method, [], CONNECT_ONESHOT)
		else:
			connected = true
	else:
		connected = true
	return connected


func _enable():
	if not is_enabled:
		is_enabled = true


func _disable():
	if is_enabled:
		is_enabled = false


func _initialize():
	if not is_initialized:
		is_initialized = true
