class_name EventManager extends Node

# signals
# warning-ignore-all:UNUSED_SIGNAL
signal request_subscribers
signal subscribe_request(_event_name, _ref, _method, _val, _oneshot)
signal add_to_event_queue(_event_name, _val)
signal unsubscribe_request(_event_name, _ref)
signal request_unsub

# fields
enum _SIGNAL_TYPE { NONE = 0, REQ_SUBS = 1, SUB_REQ = 2, ADD_EV_QUEUE = 3, UNSUB_REQ = 4 }
const _SUB_REQ_SIGNAL = "subscribe_request"
const _REQ_SUBS_SIGNAL = "request_subscribers"
const _UNSUB_REQ_SIGNAL = "unsubscribe_request"
const _ADD_EV_QUEUE_SIGNAL = "add_to_event_queue"
const _SEPERATOR = "-"

var _str = StringUtility
var _obj = ObjectUtility
var _type = TypeUtility
var _res = ResourceUtility
var _node = NodeUtility
var _data = {}


# private inheritied methods
func _init():
	_on_init(true)


func _ready():
	emit_signal(_REQ_SUBS_SIGNAL)


func _enter_tree():
	emit_signal(_REQ_SUBS_SIGNAL)


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			emit_signal(_REQ_SUBS_SIGNAL)
		NOTIFICATION_POSTINITIALIZE:
			emit_signal(_REQ_SUBS_SIGNAL)
		NOTIFICATION_PREDELETE:
			_on_init(false)
		NOTIFICATION_WM_QUIT_REQUEST:
			_on_init(false)


func _process(_delta):
	_proc_queue_and_listeners()


func _physics_process(_delta):
	_proc_queue_and_listeners()


# private helper methods
func _on_init(_do_init = true):
	_data = {
		"event_queue": null,
		"listeners": null,
		"state":
		{
			"enabled": false,
			"request_subscribers_connected": false,
			"subscribe_request_connected": false,
			"add_to_event_queue_connected": false,
			"unsubscribe_request_connected": false,
		}
	}
	if _do_init:
		_data.event_queue = EventQueue.new()
		_data.listeners = EventListeners.new()
		_data.state.enabled = _data.event_queue.enabled && _data.listeners.enabled && _connect_signals(_do_init)
		if _data.state.enabled:
			emit_signal(_REQ_SUBS_SIGNAL)
	else:
		var disabled = _data.event_queue.disable() && _data.listeners.disable() && _connect_signals(_do_init)
		if not disabled:
			_data.state.enabled = not disabled


func _connect_signals(_connect = true):
	var all_connected_or_disconnected = false
	var connecting_or_disconnecting = true
	var signal_type = _SIGNAL_TYPE.NONE
	var signal_func = ""
	while connecting_or_disconnecting:
		var on_connect_or_disconnect = true
		match signal_type:
			_SIGNAL_TYPE.NONE:
				signal_type = _SIGNAL_TYPE.REQ_SUBS
				signal_func = "_on_request_subscribers"
			_SIGNAL_TYPE.REQ_SUBS:
				signal_type = _SIGNAL_TYPE.SUB_REQ
				signal_func = "_on_subcribe_request"
			_SIGNAL_TYPE.SUB_REQ:
				signal_type = _SIGNAL_TYPE.ADD_EV_QUEUE
				signal_func = "_on_add_to_event_queue"
			_SIGNAL_TYPE.ADD_EV_QUEUE:
				signal_type = _SIGNAL_TYPE.UNSUB_REQ
				signal_func = "_on_unsubscribe_request"
			_SIGNAL_TYPE.UNSUB_REQ:
				signal_type = _SIGNAL_TYPE.NONE
		if signal_type == _SIGNAL_TYPE.NONE:
			all_connected_or_disconnected = true
			connecting_or_disconnecting = false
		elif _connect && not is_connected(signal_type, self, signal_func):
			var connected = false
			var ev_name = ""
			var ref = null
			var val = null
			match signal_type:
				_SIGNAL_TYPE.REQ_SUBS:
					if connect(signal_type, self, signal_func, [], CONNECT_DEFERRED):
						_data.state.request_subscribers_connected = true
					connected = _data.state.request_subscribers_connected
				_SIGNAL_TYPE.SUB_REQ:
					if connect(signal_type, self, signal_func, [ev_name, ref, "", val, false], CONNECT_DEFERRED):
						_data.state.subscribe_request_connected = true
					connected = _data.state.subscribe_request_connected
				_SIGNAL_TYPE.ADD_EV_QUEUE:
					if connect(signal_type, self, signal_func, [ev_name, val], CONNECT_DEFERRED):
						_data.state.add_event_to_queue_connected = true
					connected = _data.state.add_event_to_queue_connected
				_SIGNAL_TYPE.UNSUB_REQ:
					if connect(signal_type, self, signal_func, [ev_name, ref], CONNECT_DEFERRED):
						_data.state.unsubscribe_request_connected = true
					connected = _data.state.unsubscribe_request_connected
			if not connected:
				on_connect_or_disconnect = false
		elif not _connect && is_connected(signal_type, self, signal_func):
			disconnect(signal_type, self, signal_func)
			if not is_connected(signal_type, self, signal_func):
				match signal_type:
					_SIGNAL_TYPE.REQ_SUBS:
						_data.state.request_subscribers_connected = false
					_SIGNAL_TYPE.SUB_REQ:
						_data.state.subscribe_request_connected = false
					_SIGNAL_TYPE.ADD_EV_QUEUE:
						_data.state.add_to_event_queue_connected = false
					_SIGNAL_TYPE.UNSUB_REQ:
						_data.state.unsubscribe_request_connected = false
			else:
				on_connect_or_disconnect = false
		if not on_connect_or_disconnect:
			connecting_or_disconnecting = false
	return all_connected_or_disconnected


func _proc_queue_and_listeners():
	pass


# signal methods
func _on_subscribe_request(_event_name = "", _ref = null, _method = "", _val = null, _oneshot = false):
	var ref_valid = _proc_ref_valid(_event_name, _ref, _method)
	var listener_valid = (
		ref_valid
		if _val == null
		else ref_valid && (not _type.built_in_type(_val) == 0 or _type.is_type_object(_val))
	)
	if listener_valid:
		var listener_name = _proc_listener_name(_ref)
		if _str.is_valid(listener_name):
			_data.listeners.add(_event_name, listener_name, _ref, _method, _val, _oneshot)


func _on_add_to_event_queue(_event_name = "", _val = null):
	if _has_listeners() && _data.listeners.has_event(_event_name):
		_data.event_queue.add(_event_name, _val)


func _on_unsubscribe_request(_event_name = "", _ref = null):
	if _proc_ref_valid(_event_name, _ref):
		_data.listeners.remove(_event_name, _proc_listener_name(_ref))


func _has_listeners():
	return _data.state.enabled && _data.listeners.enabled && _data.listeners.has_listeners


func _proc_ref_valid(_event_name = "", _ref = null, _method = ""):
	var obj_valid = _obj.is_valid(_ref, _method) if _str.is_valid(_method) else _obj.is_valid(_ref)
	return _str.is_valid(_event_name) && obj_valid


func _proc_listener_name(_ref = null):
	var ls_name = ""
	if not _ref == null:
		var cl_name = _ref.get_class()
		if _str.is_valid(cl_name):
			var is_res = _res.is_valid(_ref)
			var is_node_inst = _node.is_instance(_ref)
			var is_res_loc = is_res && _ref.resource_local_to_scene
			ls_name = cl_name + _SEPERATOR
			if is_res:
				ls_name = ls_name + String(_ref.resource_id) + _SEPERATOR
			if is_res_loc or is_node_inst:
				ls_name = ls_name + String(_ref.get_instance_id())
			elif not is_res_loc or not is_node_inst:
				ls_name = ls_name + "global"
	return ls_name
