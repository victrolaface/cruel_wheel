extends Node

# signals
# warning-ignore:UNUSED_SIGNAL
signal node_added_to_scene_tree

# fields
const _SEPERATOR = "-"
const _NAME = "EventManager"
const _REQ_SUBS_EVENT = "request_subscribers"
const _REQ_SUBS_FUNC = "_on_request_subscribers"
const _REQ_UNSUB_EVENT = "request_unsubscribe"
const _REQ_UNSUB_FUNC = "_on_request_unsubscribe"
const _NODE_ADDED_SIGNAL = "node_added_to_scene_tree"
const _NODE_ADDED_FUNC = "_on_node_added_to_scene_tree"
var _str = StringUtility
var _obj = ObjectUtility
var _type = TypeUtility
var _res = ResourceUtility
var _node = NodeUtility
var _int = IntUtility
var _data = {}


# private inherited methods
func _init():
	_enable()


func _ready():
	_enable()


func _enter_tree():
	_enable()


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_enable()
		NOTIFICATION_POSTINITIALIZE:
			_enable()
		NOTIFICATION_PREDELETE:
			_disable()
		NOTIFICATION_WM_QUIT_REQUEST:
			_disable()


func _process(_delta):
	_proc_queue_and_listeners()


func _physics_process(_delta):
	_proc_queue_and_listeners()


# public methods
func subscribe(_event_name = "", _ref = null, _method = "", _val = null, _oneshot = false):
	var subscribed = false
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
			subscribed = _data.listeners.has(_event_name, listener_name)
	return subscribed


func publish(_event_name = "", _val = null):
	var published = false
	if _has_listeners() && _data.listeners.has_event(_event_name):
		_data.event_queue.add(_event_name, _val)
		published = _data.event_queue.has(_event_name)
	return published


func unsubscribe(_event_name = "", _ref = null):
	var unsubscribed = false
	if _proc_ref_valid(_event_name, _ref):
		var ls_name = _proc_listener_name(_ref)
		unsubscribed = _str.is_valid(ls_name) && _data.listeners.remove(_event_name, ls_name)
	return unsubscribed


# private helper methods
func _enable():
	if not _data.state.enabled:
		_on_init(true)


func _disable():
	if _data.state.enabled:
		_on_init(false)


func _on_init(_do_init = true):
	var on_do_init = _do_init && (_data.keys().size() == 0 or not _data.state.enabled)
	var on_do_deinit = not _do_init && _data.state.enabled
	var pub_req_unsub = false
	var pub_req_subs = false
	if on_do_init or on_do_deinit:
		_data = {
			"event_queue": null,
			"listeners": null,
			"state":
			{
				"enabled": false,
				"node_added_to_scene_tree_connected": false,
				"request_subscribers_connected": false,
				"unsubscribe_request_connected": false,
			}
		}
		if on_do_init:
			_data.event_queue = EventQueue.new()
			_data.listeners = EventListeners.new()
			_data.state.request_subscribers_connected = _sub_req_subs_event(true)
			_data.state.request_unsubscribe_connected = _sub_req_unsub_event(true)
			_data.state.node_added_to_scene_tree_connected = _sub_node_added_event(true)
			if _data.state.request_subscribers_connected:
				pub_req_subs = publish(_REQ_SUBS_EVENT, _NAME)
			_data.state.enabled = (
				_data.event_queue.enabled
				&& _data.listeners.enabled
				&& _data.state.request_subscribers_connected
				&& _data.state.request_unsubscribe_connected
				&& _data.state.node_added_to_scene_tree_connected
				&& pub_req_subs
			)
		elif on_do_deinit:  #not #_do_init :
			if _data.state.enabled:
				pub_req_unsub = publish(_REQ_UNSUB_EVENT, _NAME)
				_on_deinit_all_unsubbed(pub_req_unsub)
	if _data.state.enabled:
		if _do_init:
			pub_req_subs = publish(_REQ_SUBS_EVENT, _NAME)
		else:
			pub_req_unsub = publish(_REQ_UNSUB_EVENT, _NAME)
			_on_deinit_all_unsubbed(pub_req_unsub)


func _on_deinit_all_unsubbed(_pub_req_unsub = false):
	if _pub_req_unsub && not _data.listeners.has_listeners:
		_data.state.request_subscribers_connected = _sub_req_subs_event(false)
		_data.state.request_unsubscribe_connected = _sub_req_unsub_event(false)
		_data.state.node_added_to_scene_tree_connected = _sub_node_added_event(false)
		if (
			not _data.state.request_subscribers_connected
			&& not _data.state.request_unsubscribe_connected
			&& not _data.state.node_added_to_scene_tree_connected
			&& _data.event_queue.disable()
			&& _data.listeners.disable()
		):
			if (
				not _data.event_queue.enabled
				&& not _data.listeners.enabled
				&& not _data.event_queue.has_events
				&& not _data.listeners.has_listeners
			):
				_data.state.enabled = not _data.state.enabled


func _sub_req_subs_event(_subscribe = true):
	return subscribe(_REQ_SUBS_EVENT, self, _REQ_SUBS_FUNC, _NAME) if _subscribe else unsubscribe(_REQ_SUBS_EVENT, self)


func _sub_req_unsub_event(_subscribe = true):
	return subscribe(_REQ_UNSUB_EVENT, self, _REQ_UNSUB_FUNC, _NAME) if _subscribe else unsubscribe(_REQ_UNSUB_EVENT, self)


func _sub_node_added_event(_subscribe = true):
	var subbed_or_unsubbed = false
	var connected = _is_connected_node_added()
	if _subscribe && not connected:
		subbed_or_unsubbed = get_tree().connect(_NODE_ADDED_SIGNAL, self, _NODE_ADDED_FUNC, [], CONNECT_DEFERRED)
	elif not _subscribe && connected:
		get_tree().disconnect(_NODE_ADDED_SIGNAL, self, _NODE_ADDED_FUNC)
		subbed_or_unsubbed = not _is_connected_node_added()
	return subbed_or_unsubbed


func _is_connected_node_added():
	return get_tree().is_connected(_NODE_ADDED_SIGNAL, self, _NODE_ADDED_FUNC)


func _proc_queue_and_listeners():
	if _has_queued_events() && _has_listeners():
		var queued_event_keys = _data.event_queue.event_keys
		var init_queued_ev_amt = queued_event_keys.size()
		var ls_event_keys = _data.listeners.event_keys
		if init_queued_ev_amt > 0 && ls_event_keys.size() > 0:
			var called_events = false
			var called_listeners = false
			var on_ev = false
			var queued_ev_amt = init_queued_ev_amt
			for le in ls_event_keys:
				for qe in queued_event_keys:
					on_ev = qe == le
					if on_ev:
						var queued_ev = _data.event_queue.pop(qe)
						if not queued_ev == null:
							queued_ev_amt = _int.decr(queued_ev_amt)
							var vals = queued_ev.vals if queued_ev.has_values else []
							called_listeners = _data.listeners.call_listeners(le, vals)
							if not called_listeners:
								break
			called_events = queued_ev_amt == _data.event_queue.events_amt
			if not called_events:
				_data.event_queue.empty_queue()


func _has_queued_events():
	return _data.state.enabled && _data.event_queue.enabled && _data.event_queue.has_events


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


# callbacks
func _on_request_subscribers():
	pass


func _on_request_unsubscribe():
	pass


# signal methods
func _on_node_added_to_scene_tree(_node_internal = null):
	if not _node_internal == null:
		publish(_REQ_SUBS_EVENT, _NAME)
