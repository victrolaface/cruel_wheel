class_name EventManager extends Node

# signals
# warning-ignore:UNUSED_SIGNAL
signal register_event_manager

# properties
export(bool) var initialized setget , get_initialized
export(bool) var has_queued_events setget , get_has_queued_events
export(bool) var has_listeners setget , get_has_listeners
export(bool) var enabled setget , get_enabled


func get_initialized():
	return _data.state.initialized


func get_has_queued_events():
	pass


func get_has_listeners():
	pass


func get_enabled():
	pass


# fields
#const _EVENT_MANAGER_PATH = "res://data/event_manager.tres"
const _REG_LISTENERS_SIGNAL = "register_listeners"
const _REG_LISTENERS_SIGNAL_FUNC = "_on_register_listeners"
const _SEPERATOR = "-"
#var _event_mgr_res = preload(_EVENT_MANAGER_PATH)
var _data = {}


# private inheritied methods
func _init():
	_on_init(true)


func _ready():
	_register_listeners()


func _enter_tree():
	_register_listeners()


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_register_listeners()
		NOTIFICATION_POSTINITIALIZE:
			_register_listeners()
		NOTIFICATION_PREDELETE:
			_on_init(false)
		NOTIFICATION_WM_QUIT_REQUEST:
			_on_init(false)


func _process(_delta):
	pass


func _physics_process(_delta):
	pass


# public methods
func subscribe():
	pass


func unsubscribe():
	pass


func publish():
	pass


# private helper methods
func _on_init(_do_init = true):
	_data = {
		"event_queue": null,
		"listeners": null,
		"state":
		{
			"enabled": false,
			"register_listeners_connected": false,
		}
	}
	if _do_init:
		#if _event_mgr_res

		_data.event_queue = EventQueue.new()
		_data.listeners = EventListeners.new()
	_data.state.enabled = _connect_register_listeners(_do_init) if _do_init else not _connect_register_listeners(_do_init)
	if _data.state.enabled:
		_register_listeners()


func _connect_register_listeners(_connect = true):
	var connected_or_disconnected = false
	var connected = false
	if _connect && connect(_REG_LISTENERS_SIGNAL, self, _REG_LISTENERS_SIGNAL_FUNC, [], CONNECT_DEFERRED):
		connected = _register_listeners_connected()
		connected_or_disconnected = connected
	else:
		disconnect(_REG_LISTENERS_SIGNAL, self, _REG_LISTENERS_SIGNAL_FUNC)
		connected_or_disconnected = not _register_listeners_connected()
	return connected_or_disconnected


func _register_listeners_connected():
	return is_connected(_REG_LISTENERS_SIGNAL, self, _REG_LISTENERS_SIGNAL_FUNC)


func _register_listeners():
	emit_signal(_REG_LISTENERS_SIGNAL)


func _on_register_listeners():
	var reg_ls_connected = _data.state.register_listeners_connected
	if not reg_ls_connected:
		_data.state.register_listeners_connected = not reg_ls_connected
