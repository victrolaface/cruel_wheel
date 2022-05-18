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


func _has_listeners_total():
	return _listeners_total_amt() > 0


func _has_listeners():
	return _listeners_total_amt() > 0


func _has_listeners_queued():
	return _listeners_queued_amt() > 0


func _has_listeners_idle_queued():
	return _data.listeners_idle_queued_amt > 0


func _has_listeners_physics_queued():
	return _data.listeners_physics_queued_amt > 0


func _listeners_total_amt():
	return _listeners_queued_amt() + _listeners_amt()


func _listeners_queued_amt():
	return _data.listeners_idle_queued_amt + _data.listener_physics_queued_amt


func _listeners_amt():
	return _data.listeners_idle_amt + _data.listeners_physics_amt


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


"""
	"event_queue":
	{
		"idle": {},
		"physics": {},
	},
"""


func _event_queue_names(_proc_mode = PROCESSING_MODE.NONE):
	var ns = []
	if _has_queued_events(_proc_mode):
		ns = _arr.to_arr(_event_queue_keys(_proc_mode), "str")
	return ns


func _queued_event(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	var q_event = QueuedEvent
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			if _data.event_queue.idle.has(_event_name):
				q_event = _data.event_queue.idle[_event_name]
		PROCESSING_MODE.PHYSICS:
			if _data.event_queue.physics.has(_event_name):
				q_event = _data.event_queue.physics[_event_name]
	return q_event


func _queue_has_event(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	var has_ev = false
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			has_ev = _data.event_queue.idle.has(_event_name)
		PROCESSING_MODE.PHYSICS:
			has_ev = _data.event_queue.physics.has(_event_name)
	return has_ev


func _event_queue_keys(_proc_mode = PROCESSING_MODE.NONE):
	var ks = []
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			ks = _data.event_queue.idle.keys()
		PROCESSING_MODE.PHYSICS:
			ks = _data.event_queue.physics.keys()
	return ks


func _has_queued_events(_proc_mode = PROCESSING_MODE.NONE):
	return _event_queue_keys(_proc_mode).size() > 0


func _listeners_has_event(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	return false


func publish(_event_name = "", _val = null, _proc_mode = 0):
	var published = false
	var has_val = not _val == null
	if _str.is_valid(_event_name) && _has_listeners_total():
		var add_val_to_queue = false
		var add_ev_to_queue = false
		if _has_queued_events(_proc_mode):
			if _queue_has_event(_event_name):
				var q_ev = _queued_event(_event_name, _proc_mode)
				if q_ev.enabled && q_ev.takes_val:
					add_val_to_queue = not q_ev.contains_val(_val)
		elif not add_ev_to_queue:
			if _listeners_has_event(_event_name, _proc_mode):
				
			#add_ev_to_queue = _listeners_has_event(_event_name, _proc_mode)
			#if add_ev_to_queue:

		if add_ev_to_queue:
			if has_val:
				pass
			pass
		elif add_val_to_queue:
			pass
	return published
