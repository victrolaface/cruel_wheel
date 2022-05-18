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
	_proc_event_queue(_delta, PROCESSING_MODE.IDLE)
	_proc_listeners(_delta, PROCESSING_MODE.IDLE)


func _physics_process(_delta):
	_proc_event_queue(_delta, PROCESSING_MODE.PHYSICS)
	_proc_listeners(_delta, PROCESSING_MODE.PHYSICS)


func subscribe(_do_subscribe = true, _event_name = "", _ref = null, _method = "", _proc_mode = 0, _oneshot = false):
	var subscribed_or_unsubscribed = false
	return subscribed_or_unsubscribed


func publish(_event_name = "", _val = null, _proc_mode = PROCESSING_MODE.NONE):
	var published = false
	if _str.is_valid(_event_name) && _has_listeners_total():
		var add_val_to_queue = false
		var add_ev_to_queue = false
		var q_ev = _queued_event(_event_name, _proc_mode)
		var ev_has_listeners = _listeners_take_val(_event_name, _val, _proc_mode)
		if _event_queue_has(_event_name, _proc_mode):
			add_val_to_queue = q_ev.enabled && q_ev.takes_val && ev_has_listeners && not q_ev.contains_val(_val)
		else:
			add_ev_to_queue = ev_has_listeners
		var ls_oneshot = []
		var ls = _listeners(_event_name, _proc_mode)
		if add_ev_to_queue:
			if ev_has_listeners:
				var idx = 0
				var idx_oneshot = _arr.init("int")
				for l in ls:
					if l.is_oneshot:
						ls_oneshot.append(l)
						idx_oneshot = _arr.add(idx_oneshot, idx, "int")
					idx = _int.incr(idx)
				if idx_oneshot.size() > 0:
					for i in idx_oneshot:
						ls.remove(i)
			published = _add_queued_event(_event_name, _val, ls, ls_oneshot, _proc_mode)
		elif add_val_to_queue:
			published = q_ev.add_val(_val)
	return published


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
	return connected_or_disconnected


func _register_listeners_connected():
	return is_connected(_REG_LISTENERS_SIGNAL, self, _REG_LISTENERS_SIGNAL_FUNC)


func _register_listeners():
	emit_signal(_REG_LISTENERS_SIGNAL)


func _on_register_listeners():
	var reg_ls_connected = _data.state.register_listeners_connected
	if not reg_ls_connected:
		_data.state.register_listeners_connected = not reg_ls_connected


func _has_listeners_total():
	return _listeners_total_amt() > 0


func _listeners_total_amt():
	return _listeners_queued_amt() + _listeners_amt()


func _listeners_amt():
	return _data.listeners_idle_amt + _data.listeners_physics_amt


func _listeners_queued_amt():
	return _data.listeners_idle_queued_amt + _data.listener_physics_queued_amt


func _has_listeners():
	return _listeners_total_amt() > 0


func _has_listeners_queued():
	return _listeners_queued_amt() > 0


func _has_listeners_idle_queued():
	return _data.listeners_idle_queued_amt > 0


func _has_listeners_physics_queued():
	return _data.listeners_physics_queued_amt > 0


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


func _listeners_take_val(_event_name = "", _val = null, _proc_mode = PROCESSING_MODE.NONE):
	var ls_takes_val = false
	var has_val = not _val == null
	if _listeners_has(_event_name, _proc_mode):
		var ls = _listeners(_event_name, _proc_mode)
		for l in ls:
			var takes_val = l.method_takes_val
			if has_val:
				ls_takes_val = has_val && takes_val && l.method_takes_typeof(_val)
			else:
				ls_takes_val = not has_val && not takes_val
			if not ls_takes_val:
				break
	return ls_takes_val


func _listeners_has(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	var has_ev = false
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			has_ev = _data.listeners.idle.has(_event_name)
		PROCESSING_MODE.PHYSICS:
			has_ev = _data.listeners.physics.has(_event_name)
	return has_ev


func _listeners(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	var ls = []
	if _listeners_has(_event_name, _proc_mode):
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				ls = _data.listeners.idle[_event_name]
			PROCESSING_MODE.PHYSICS:
				ls = _data.listeners.idle[_event_name]
	return ls


func _event_queue_has(_event_name = "", _proc_mode = PROCESSING_MODE.NONE):
	var has_ev = false
	if _has_queued_events(_proc_mode):
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				has_ev = _data.event_queue.idle.has(_event_name)
			PROCESSING_MODE.PHYSICS:
				has_ev = _data.event_queue.physics.has(_event_name)
	return has_ev


func _has_queued_events(_proc_mode = PROCESSING_MODE.NONE):
	return _event_queue_keys(_proc_mode).size() > 0


func _event_queue_keys(_proc_mode = PROCESSING_MODE.NONE):
	var ks = []
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			ks = _data.event_queue.idle.keys()
		PROCESSING_MODE.PHYSICS:
			ks = _data.event_queue.physics.keys()
	return ks


func _add_queued_event(_ev_name = "", _val = null, _ls = [], _ls_os = [], _proc_mode = PROCESSING_MODE.NONE):
	var ls_names = _listener_names(_ls.size(), _ls)
	var ls_os_names = _listener_names(_ls_os.size(), _ls_os)
	var added = false
	var ev_queue = _event_queue(_proc_mode)
	if not _event_queue_has(_ev_name, _proc_mode):
		var queued_ev = ev_queue[_ev_name]
		queued_ev = QueuedEvent.new(_ev_name, _val, _proc_mode, ls_names, ls_os_names)
		if queued_ev.enabled:
			var init_amt = _event_queue_keys(_proc_mode).size()
			var amt = 0
			ev_queue[_ev_name] = queued_ev
			match _proc_mode:
				PROCESSING_MODE.IDLE:
					_data.event_queue.idle = ev_queue
				PROCESSING_MODE.PHYSICS:
					_data.event_queue.physics = ev_queue
			amt = _event_queue_keys(_proc_mode).size()
			added = amt > init_amt
	return added


func _listener_names(_amt = 0, _listeners = []):
	var ns = _arr.init("str")
	if _amt > 0:
		for l in _listeners:
			if l.has_listener_name:
				ns = _arr.add(ns, l.listener_name, "str")
	return ns


func _event_queue(_proc_mode = PROCESSING_MODE.NONE):
	var evs = {}
	if _has_queued_events(_proc_mode):  #_queue_has_event(_event_name, _proc_mode):
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				evs = _data.event_queue.idle
			PROCESSING_MODE.PHYSICS:
				evs = _data.event_queue.physics
	return evs


func _proc_event_queue(_delta = 0.0, _proc_mode = PROCESSING_MODE.NONE):
	var has_events_to_rem = _has_event_to_proc(true, false, _proc_mode)
	var has_events_to_proc = _has_event_to_proc(false, true, _proc_mode)
	if has_events_to_rem:
		pass
	if has_events_to_proc:
		pass


func _has_event_to_proc(_rem = false, _proc = false, _proc_mode = PROCESSING_MODE.NONE):
	var has_ev_to_proc = false
	var ev_queue = _event_queue(_proc_mode)
	var ev_queue_keys = _event_queue_keys(_proc_mode)
	if ev_queue_keys.size() > 0:
		for k in ev_queue_keys:
			var queued_ev = ev_queue[k]
			if _rem:
				has_ev_to_proc = queued_ev.destroy
			elif _proc:
				if queued_ev.enabled:
					has_ev_to_proc = queued_ev.has_listeners or queued_ev.has_listeners_oneshot
			if has_ev_to_proc:
				break
	return has_ev_to_proc


func _proc_listeners(_delta = 0.0, _proc_mode = PROCESSING_MODE.NONE):
	pass
