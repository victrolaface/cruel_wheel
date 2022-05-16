class_name EventsManager extends Node

# warning-ignore:UNUSED_SIGNAL
signal register_events_manager

# fields
enum PROCESSING_MODE { NONE, IDLE, PHYSICS }
const _REG_LISTENERS_SIGNAL = "register_listeners"
const _REG_LISTENERS_SIGNAL_FUNC = "_on_register_listeners"
const _SEPERATOR = "-"

var _arr = PoolArrayUtility
var _obj = ObjectUtility
var _str = StringUtility
var _int = IntUtility
var _data = {}


func _init():
	_on_init(true)


func _on_init(_do_init = true):
	_data = {
		"event_queue":
		{
			"idle": {},
			"physics": {},
		},
		"listeners":
		{
			"idle": {},
			"physics": {},
		},
		"state":
		{
			"enabled": false,
			"register_listeners_connected": false,
		},
		"events_idle_amt": 0,
		"events_idle_queued_amt": 0,
		"events_physics_amt": 0,
		"events_physics_queued_amt": 0,
		"listeners_idle_amt": 0,
		"listeners_idle_queued_amt": 0,
		"listeners_physics_amt": 0,
		"listeners_physics_queued_amt": 0,
	}
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
	_data.state.register_listeners_connected = connected
	return connected_or_disconnected


func _register_listeners_connected():
	return is_connected(_REG_LISTENERS_SIGNAL, self, _REG_LISTENERS_SIGNAL_FUNC)


func _register_listeners():
	emit_signal(_REG_LISTENERS_SIGNAL)


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


func subscribe(_do_subscribe = true, _event_name = "", _ref = null, _method = "", _proc_mode = 0, _oneshot = false):
	var subscribed_or_unsubscribed = false
	return subscribed_or_unsubscribed


func publish(_event_name = "", _val = null, _proc_mode = 0):
	var published = false
	return published
