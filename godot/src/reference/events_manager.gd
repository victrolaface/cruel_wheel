class_name EventsManager extends Node

# warning-ignore:UNUSED_SIGNAL
signal register_events_manager

# fields
enum PROCESSING_MODE { NONE, IDLE, PHYSICS }
const _EVENTS_SIGNAL = "register_listeners"
const _EVENTS_SIGNAL_FUNC = "_on_register_listeners"
const _SEPERATOR = "-"

var _arr = PoolArrayUtility
var _obj = ObjectUtility
var _str = StringUtility
var _int = IntUtility

var _data = {
	"event_queue":
	{
		"idle":
		{
			"event_01":
			[
				{
					#"name": "event_01",
					"has_val": true,
					"val": 0,
				},
				{},
			],
			#"_val",
		},
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
	"events_idle_queued_amt": 0,
	"events_idle_amt": 0,
	"events_physics_queued_amt": 0,
	"events_physics_amt": 0,
	"listeners_idle_queued_amt": 0,
	"listeners_idle_amt": 0,
	"listeners_physics_queued_amt": 0,
	"listeners_physics_amt": 0,
}

var _listener = {
	"name": "",
	"ref": null,
	"method": "",
	"is_oneshot": false,
	"has_name": false,
	"has_method": false,
	"has_ref": false,
}

var _queued_event = {
	"has_val": false,
	"val": null,
}

var _called_event_listeners = {"event_name": "", "listener_names": _arr.init("str")}


func _init():
	if not _register_listeners_connected():
		if _connect_register_listeners(true):
			_data.state.enabled = _data.state.register_listeners_connected
	_register_listeners()


func _register_listeners():
	emit_signal(_EVENTS_SIGNAL)


func _on_register_listeners():
	pass


func _register_listeners_connected():
	return is_connected(_EVENTS_SIGNAL, self, _EVENTS_SIGNAL_FUNC)


func _connect_register_listeners(_connect = true):
	var connected = false
	if _connect && connect(_EVENTS_SIGNAL, self, _EVENTS_SIGNAL_FUNC, [], CONNECT_DEFERRED):
		connected = _register_listeners_connected()
	else:
		disconnect(_EVENTS_SIGNAL, self, _EVENTS_SIGNAL_FUNC)
		connected = not _register_listeners_connected()
	_data.state.register_listeners_connected = connected
	return connected


func _has_queue():
	return _events_queued_amt() > 0 or _listeners_queued_amt() > 0


func _has_idle_queue():
	return _data.events_idle_queued_amt > 0 or _data.listeners_idle_queued_amt > 0


func _has_physics_queue():
	return _data.events_physics_queued_amt > 0 or _data.listeners_physics_queued_amt > 0


func _has_events():
	return _events_amt() > 0 or _has_listeners()


func _has_idle_events():
	return _data.events_idle_amt > 0 or _data.listeners_idle_amt > 0


func _has_physics_events():
	return _data.events_physics_amt > 0 or _data.listeners_physics_amt > 0


func _has_listeners():
	return _listeners_amt() > 0


func _events_amt():
	return _data.events_idle_amt + _data.events_physics_amt


func _listeners_amt():
	return _data.listeners_idle_amt + _data.listeners_physics_amt


func _events_queued_amt():
	return _data.events_idle_queued_amt + _data.events_physics_queued_amt


func _listeners_queued_amt():
	return _data.listeners_idle_queued_amt + _data.listeners_physics_queued_amt


func _on_empty_events(_proc_mode = PROCESSING_MODE.NONE):
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			_data.listeners.idle = {}
			_data.listeners_idle_amt = 0
			_data.events_idle_amt = 0
		PROCESSING_MODE.PHYSICS:
			_data.listeners.physics = {}
			_data.listeners_physics_amt = 0
			_data.events_physics_amt = 0


func disable():
	if _data.state.enabled:
		if _has_queue():
			if _has_idle_queue():
				_on_empty_queue(PROCESSING_MODE.IDLE)
			if _has_physics_queue():
				_on_empty_queue(PROCESSING_MODE.PHYSICS)
		if _has_events():
			if _has_idle_events():
				_on_empty_events(PROCESSING_MODE.IDLE)
			if _has_physics_events():
				_on_empty_events(PROCESSING_MODE.PHYSICS)
		if _data.state.register_listeners_connected:
			if _register_listeners_connected():
				if _connect_register_listeners(false):
					_data.state.enabled = not _data.state.enabled


func _on_empty_queue(_proc_mode = PROCESSING_MODE.NONE):
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			_data.event_queue.idle.clear()
			_data.events_idle_queued_amt = 0
			_data.listeners_idle_queued_amt = 0
		PROCESSING_MODE.PHYSICS:
			_data.event_queue.physics.clear()
			_data.events_physics_queued_amt = 0
			_data.listeners_physics_queued_amt = 0


func _ready():
	_register_listeners()


func _enter_tree():
	_register_listeners()


func _process(_delta):
	_proc_events_queue(PROCESSING_MODE.IDLE)


func _physics_process(_delta):
	_proc_events_queue(PROCESSING_MODE.PHYSICS)


func _proc_events_queue(_proc_mode = PROCESSING_MODE.NONE):
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			_call_listeners(_proc_mode)
			_call_listeners(PROCESSING_MODE.PHYSICS)
		PROCESSING_MODE.PHYSICS:
			# push idle to physics
			# call physics
			_call_listeners(_proc_mode)


func _on_call_listeners(_queued_event_name = "", _queued_event_instance = {}, _proc_mode = PROCESSING_MODE.NONE):
	pass


func _call_listeners(_proc_mode = PROCESSING_MODE.NONE):
	if _events_queued_amt() > 0:
		var queued_evnts_amt = 0
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				queued_evnts_amt = _data.events_idle_queued_amt
			PROCESSING_MODE.PHYSICS:
				queued_evnts_amt = _data.events_physics_queued_amt
		if queued_evnts_amt > 0:
			var evnts_to_rem = null
			var lstnrs_to_rem = {}
			var init_evnts_to_rem = false
			var init_lstnrs_to_rem = false
			var has_lstnrs_to_rem = false
			var rem_amt = 0
			var queued_evnts = {}
			var evnts = {}
			match _proc_mode:
				PROCESSING_MODE.IDLE:
					queued_evnts = _data.event_queue.idle
					evnts = _data.listeners.idle
				PROCESSING_MODE.PHYSICS:
					queued_evnts = _data.event_queue.physics
					evnts = _data.listeners.physics
			var evnts_keys = evnts.keys()
			var queued_evnts_keys = queued_evnts.keys()
			var queued_evnts_size = queued_evnts_keys.size()
			queued_evnts_amt = queued_evnts_amt if queued_evnts_size == queued_evnts_amt else queued_evnts_size
			if queued_evnts_amt > 0:
				var called_evnts_amt = 0
				var called_events_listeners = []
				for queued_event_name in queued_evnts_keys:
					var queued_event_instance = null  #_queued_event
					var queued_event_instances = queued_evnts[queued_event_name]
					if queued_event_instances.size() > 1:
						for i in queued_event_instances:
							queued_event_instance = i
							_on_call_listeners(queued_event_name, queued_event_instance, _proc_mode)
					elif queued_event_instances.size() == 1:
						queued_event_instance = queued_event_instances[0]
						_on_call_listeners(queued_event_name, queued_event_instance, _proc_mode)
					##########################################################################################################
					for e in evnts_keys:
						if queued_event_name == e:
							var called_lstnrs_amt = 0
							var to_call_lstnrs = e.keys()
							var to_call_lstnrs_amt = to_call_lstnrs.size()
							var called_evnt_lstnrs = _called_event_listeners  #_event_listeners_called
							called_evnt_lstnrs.event_name = e
							rem_amt = 0
							if to_call_lstnrs_amt > 0:
								var called_all_lstnrs_in_evnt = false
								for l in to_call_lstnrs:
									var to_call_lstnr = null
									init_lstnrs_to_rem = false
									match _proc_mode:
										PROCESSING_MODE.IDLE:
											to_call_lstnr = _data.listeners.idle[e[l]]
										PROCESSING_MODE.PHYSICS:
											to_call_lstnr = _data.listeners.physics[e[l]]
									if not to_call_lstnr == null && to_call_lstnr.has_name && l == to_call_lstnr.name:
										var called_listener = false
										if to_call_lstnr.has_ref && to_call_lstnr.has_method:
											to_call_lstnr.ref.call(to_call_lstnr.method, 0)  ####################### get val from queue
											called_evnt_lstnrs.listener_names = _arr.add(
												called_evnt_lstnrs.listener_names, to_call_lstnr.name, "str"
											)
											called_lstnrs_amt = _int.incr(called_lstnrs_amt)
											called_listener = true
										if called_listener && to_call_lstnr.is_oneshot:
											if not init_lstnrs_to_rem:
												lstnrs_to_rem[e] = _arr.init("str")
												init_lstnrs_to_rem = lstnrs_to_rem[e].size() > 0
											lstnrs_to_rem[e] = _arr.add(lstnrs_to_rem[e], to_call_lstnr.name, "str")
											rem_amt = _int.incr(rem_amt)
											if not has_lstnrs_to_rem:
												has_lstnrs_to_rem = not has_lstnrs_to_rem
									if rem_amt == to_call_lstnrs_amt:
										if not init_evnts_to_rem:
											evnts_to_rem = _arr.init("str")
											init_evnts_to_rem = evnts_to_rem.size() > 0
										evnts_to_rem = _arr.add(evnts_to_rem, e)
								called_all_lstnrs_in_evnt = called_lstnrs_amt == to_call_lstnrs_amt
								called_evnts_amt = _on_incr_amt(called_all_lstnrs_in_evnt, called_evnts_amt)
								called_events_listeners.append(called_evnt_lstnrs)
					if called_evnts_amt == queued_evnts_amt:
						_on_empty_queue(_proc_mode)
					elif called_events_listeners.size() > 0:
						var evnts_called = _arr.init("str")
						var lstnrs_called = _arr.init("str")
						for called_event_listeners in called_events_listeners:
							var n = called_event_listeners.event_name
							if _str.is_valid(n):
								evnts_called = _arr.add(evnts_called, n, "str")
							var lstnrs_called_group = called_event_listeners.listener_names
							if lstnrs_called_group.size() > 0:
								for l_called in lstnrs_called_group:
									if _str.is_valid(l_called):
										lstnrs_called = _arr.add(lstnrs_called, l_called, "str")
						if evnts_called.size() > 0 && lstnrs_called.size() > 0:
							for ev_called in evnts_called:
								if queued_evnts.has(ev_called):
									var q_ev_lstnrs = _arr.init("str")
									match _proc_mode:
										PROCESSING_MODE.IDLE:
											q_ev_lstnrs = _data.event_queue.idle[ev_called]
										PROCESSING_MODE.PHYSICS:
											q_ev_lstnrs = _data.event_queue.physics[ev_called]
									var init_amt = q_ev_lstnrs.size()
									var curr_amt = init_amt
									var idx = 0
									var idx_rem = _arr.init("int")
									var ls_called = _arr.init("str")
									var idx_rem_amt = 0
									var called_amt = 0
									rem_amt = 0
									for q_lstnr in q_ev_lstnrs:
										for l_called in lstnrs_called:
											if q_lstnr == l_called:
												idx_rem = _arr.add(idx_rem, idx, "int")
												ls_called = _arr.add(ls_called, l_called, "str")
												curr_amt = _int.decr(curr_amt)
										idx = _int.incr(idx)
									idx_rem_amt = idx_rem.size()
									called_amt = ls_called.size()
									if idx_rem_amt > 0 && called_amt > 0 && idx_rem_amt == called_amt:
										idx = 0
										for i in idx_rem:
											q_ev_lstnrs = _arr.rem(q_ev_lstnrs, "str", ls_called[idx], i, true)
											idx = _int.incr(idx)
									if q_ev_lstnrs.size() == 0:
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												_data.event_queue.idle.erase(ev_called)
												_data.events_idle_queued_amt = _int.decr(_data.events_idle_queued_amt)
												rem_amt = _data.listeners_idle_queued_amt - init_amt
												_data.listeners_idle_queued_amt = rem_amt
											PROCESSING_MODE.PHYSICS:
												_data.event_queue.physics.erase(ev_called)
												_data.events_physics_queued_amt = _int.decr(_data.events_physics_queued_amt)
												rem_amt = _data.listeners_physics_queued_amt - init_amt
												_data.listeners_physics_queued_amt = rem_amt
									else:
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												_data.event_queue.idle[ev_called] = q_ev_lstnrs
												rem_amt = _data.listeners_idle_queued_amt - curr_amt
												rem_amt = _data.listeners_idle_queued_amt - rem_amt
												_data.listeners_idle_queued_amt = rem_amt
											PROCESSING_MODE.PHYSICS:
												_data.event_queue.physics[ev_called] = q_ev_lstnrs
												rem_amt = _data.listeners_physics_queued_amt - curr_amt
												rem_amt = _data.listeners_physics_queued_amt - rem_amt
												_data.listeners_physics_queued_amt = rem_amt
			if has_lstnrs_to_rem:
				for el_rem in lstnrs_to_rem.keys():
					for e in evnts:
						if el_rem == e:
							var lstnrs_comp = null
							match _proc_mode:
								PROCESSING_MODE.IDLE:
									lstnrs_comp = _arr.to_arr(_data.listeners.idle[e].keys(), "str")
								PROCESSING_MODE.PHYSICS:
									lstnrs_comp = _arr.to_arr(_data.listeners.physics[e].keys(), "str")
							rem_amt = 0
							for l_rem in lstnrs_to_rem[el_rem].keys():
								for l_comp in lstnrs_comp:
									if l_rem == l_comp:
										var tmp = {}
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												tmp = _data.listeners.idle[e]
											PROCESSING_MODE.PHYSICS:
												tmp = _data.listeners.physics[e]
										rem_amt = _on_incr_amt(tmp.erase(l_rem), rem_amt)
										if lstnrs_comp.size() - tmp.size() == rem_amt:
											match _proc_mode:
												PROCESSING_MODE.IDLE:
													_data.listeners.idle[e] = tmp
													_data.listeners_idle_amt = _int.decr(_data.listeners_idle_amt)
												PROCESSING_MODE.PHYSICS:
													_data.listeners.physics[e] = tmp
													_data.listeners_physics_amt = _int.decr(_data.listeners_physics_amt)
			if evnts_to_rem.size() > 0:
				for e_rem in evnts_to_rem:
					for e_comp in evnts_keys:
						if e_rem == e_comp:
							var tmp = {}
							match _proc_mode:
								PROCESSING_MODE.IDLE:
									tmp = _data.listeners.idle
								PROCESSING_MODE.PHYSICS:
									tmp = _data.listeners.physics
							if tmp.erase(e_rem):
								match _proc_mode:
									PROCESSING_MODE.IDLE:
										_data.listeners.idle = tmp
										_data.events_idle_amt = _int.decr(_data.events_idle_amt)
									PROCESSING_MODE.PHYSICS:
										_data.listeners.physics = tmp
										_data.events_physics_amt = _int.decr(_data.events_physics_amt)


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_register_listeners()
		NOTIFICATION_POSTINITIALIZE:
			_register_listeners()
		NOTIFICATION_PREDELETE:
			disable()
		NOTIFICATION_WM_QUIT_REQUEST:
			disable()


func _proc_name(_ref = null):
	var name = _ref.get_class() + _SEPERATOR + String(_ref.resource_id) + _SEPERATOR
	name = name + String(_ref.get_instance_id()) if _ref.resource_local_to_scene else name + "global"
	return name


func subscribe(_event = "", _ref = null, _method = "", _proc_mode = PROCESSING_MODE.NONE, _oneshot = false):
	var added_event_idle = false
	var added_event_physics = false
	var added_listener_idle = false
	var added_listener_physics = false
	var name = _name_from_ref(_event, _ref, _method)
	if _str.is_valid(name):
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				added_event_idle = _on_subscribe_event(_event, _proc_mode)
				added_listener_idle = _on_subscribe_listener(_event, name, _ref, _method, _oneshot)
			PROCESSING_MODE.PHYSICS:
				added_event_physics = _on_subscribe_event(_event, _proc_mode)
				added_listener_physics = _on_subscribe_listener(_event, name, _ref, _method, _oneshot)
		_data.events_idle_amt = _on_incr_amt(added_event_idle, _data.events_idle_amt)
		_data.listeners_idle_amt = _on_incr_amt(added_listener_idle, _data.listeners_idle_amt)
		_data.events_physics_amt = _on_incr_amt(added_event_physics, _data.events_physics_amt)
		_data.listeners_physics_amt = _on_incr_amt(added_listener_physics, _data.listeners_physics_amt)
	return added_listener_idle or added_listener_physics


func _on_subscribe_event(_e = "", _p = PROCESSING_MODE.IDLE):
	var added_event = false
	match _p:
		PROCESSING_MODE.IDLE:
			if not _data.listeners.idle.has(_e):
				_data.listeners.idle[_e] = {}
				added_event = _data.listeners.idle.has(_e)
		PROCESSING_MODE.PHYSICS:
			if not _data.listeners.physics.has(_e):
				_data.listeners.physics[_e] = {}
				added_event = _data.listeners.physics.has(_e)
	return added_event


func _on_subscribe_listener(_e = "", _n = "", _r = null, _m = "", _p = PROCESSING_MODE.IDLE, _os = false):
	var added_listener = false
	match _p:
		PROCESSING_MODE.IDLE:
			if not _data.listeners.physics[_e].has(_n):
				_data.listeners.physics[_e[_n]] = _on_add_listener(_n, _r, _m, _os)
				added_listener = _data.listeners.physics[_e].has(_n)
		PROCESSING_MODE.PHYSICS:
			if not _data.listeners.physics[_e].has(_n):
				_data.listeners.physics[_e[_n]] = _on_add_listener(_n, _r, _m, _os)
				added_listener = _data.listeners.physics[_e].has(_n)
	return added_listener


func _on_add_listener(_name = "", _ref = null, _method = "", _oneshot = false):
	var l = _listener
	l.name = _name
	l.ref = _ref
	if not _ref == null && _str.is_valid(_method):
		if _ref.has_method(_method):
			l.method = _method
	l.method = _method
	l.oneshot = _oneshot
	l.value = null
	return l


func _on_incr_amt(_do_incr = false, _amt = 0):
	var amt = _amt
	if _do_incr:
		amt = _int.incr(amt)
	return amt


func _name_from_ref(_event = "", _ref = null, _method = ""):
	var name = ""
	var ref_valid = _obj.is_valid(_ref, _method) if _str.is_valid(_method) else _obj.is_valid(_ref)
	if _str.is_valid(_event) && ref_valid:
		if _ref.is_class("ResourceItem"):
			name = _ref.name if _ref.has_name else _proc_name(_ref)
		else:
			name = _proc_name(_ref)
	return name


func _unsubscribe(_event = "", _name = "", _proc_mode = PROCESSING_MODE.NONE):
	var unsubscribed = false
	var tmp = {}
	var init_listeners_amt = 0
	var init_events_amt = 0
	var events = {}
	var event = {}
	var amt = 0
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			init_events_amt = _data.events_idle_amt
			events = _data.listeners.idle
		PROCESSING_MODE.PHYSICS:
			init_events_amt = _data.events_physics_amt
			events = _data.listeners.physics
	if events.has(_event):
		event = events[_event]
		if event.has(_name):
			tmp = event
			init_listeners_amt = tmp.keys().size()
			tmp.erase(name)
			amt = tmp.keys().size()
			unsubscribed = amt == init_listeners_amt - 1
			if unsubscribed:
				match _proc_mode:
					PROCESSING_MODE.IDLE:
						_data.listeners.idle[_event] = tmp
						_data.listeners_idle_amt = _int.decr(_data.listeners_idle_amt)
					PROCESSING_MODE.PHYSICS:
						_data.listeners.physics[_event] = tmp
						_data.listeners_physics_amt = _int.decr(_data.listeners_physics_amt)
				if amt == 0:
					tmp = events
					init_events_amt = tmp.keys().size()
					tmp.erase(_event)
					amt = tmp.keys().size()
					if amt == init_events_amt - 1:
						match _proc_mode:
							PROCESSING_MODE.IDLE:
								_data.listeners.idle = tmp
								_data.events_idle_amt = _int.decr(_data.events_idle_amt)
							PROCESSING_MODE.PHYSICS:
								_data.listeners.physics = tmp
								_data.events_physics_amt = _int.decr(_data.events_physics_amt)
	return unsubscribed


func unsubscribe(_event = "", _ref = null):
	var unsubscribed = false
	if _events_amt() > 0:
		var name = _name_from_ref(_event, _ref)
		if _str.is_valid(name):
			unsubscribed = _unsubscribe(_event, name, PROCESSING_MODE.IDLE)
			if not unsubscribed:
				unsubscribed = _unsubscribe(_event, name, PROCESSING_MODE.PHYSICS)
	return unsubscribed


func _on_publish_event_is(_event_keys = [], _event = "", _proc_mode = PROCESSING_MODE.NONE):
	var event_is = false
	var has_event_type = false
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			has_event_type = _has_idle_events()
		PROCESSING_MODE.PHYSICS:
			has_event_type = _has_physics_events()
	if has_event_type:
		if _event_keys.size() > 0:
			for e in _event_keys:
				if e == _event:
					match _proc_mode:
						PROCESSING_MODE.IDLE:
							event_is = _data.listeners.idle[e].size() > 0
						PROCESSING_MODE.PHYSICS:
							event_is = _data.listeners.physics[e].size() > 0
					if event_is:
						break
	return event_is


func publish(_event = "", _val = null, _proc_mode = PROCESSING_MODE.NONE):
	if _str.is_valid(_event) && _has_events():
		var event_is_idle = false
		var event_is_physics = false
		var has_val = not _val == null
		var listeners_idle_keys = _data.listeners.idle.keys()
		var listeners_physics_keys = _data.listeners.physics.keys()
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				event_is_idle = _on_publish_event_is(listeners_idle_keys, _event, _proc_mode)
			PROCESSING_MODE.PHYSICS:
				event_is_physics = _on_publish_event_is(listeners_physics_keys, _event, _proc_mode)
			PROCESSING_MODE.NONE:
				var event_is = false
				event_is = _on_publish_event_is(listeners_idle_keys, _event, PROCESSING_MODE.IDLE)
				if not event_is:
					event_is = _on_publish_event_is(listeners_physics_keys, _event, PROCESSING_MODE.PHYSICS)
					event_is_physics = event_is
				else:
					event_is_idle = event_is
		if event_is_idle or event_is_physics:
			if not _has_queue():
				if event_is_idle:
					pass
				elif event_is_physics:
					pass
			else:
				if event_is_idle:
					if not _has_idle_queue():
						pass
					else:
						if _data.event_queue.idle.has(_event):
							var queued_event = _data.event_queue.idle[_event]
							if has_val && queued_event.has_val:
								if not queued_event.val == _val:
									pass
								#var queued_val = queued_event.val

						else:
							pass

				elif event_is_physics:
					if not _has_physics_queue():
						pass
					else:
						pass
			#if not _has_idle_queue()
			#var queued_idle_events_keys =
			#var queued_physics_events_keys =
			var queued_event = _queued_event
			#queued_event.name = _event
			queued_event.has_val = has_val  #not _val == null
			if queued_event.has_val:
				queued_event.val = _val
			if event_is_idle:
				_data.event_queue.idle[_event] = queued_event
				_data.events_idle_queued_amt = _int.incr(_data.events_idle_queued_amt)
			elif event_is_physics:
				_data.event_queue.physics[_event] = queued_event
				_data.events_physics_queued_amt = _int.incr(_data.events_physics_queued_amt)

				#queued_event#queued_events
				"""
				"event_queue":
				{
					"idle":
					{
						"event_01": "_val",
					},
					"physics": {},
				},
				"""

				#if _has_events():
				#var has_idle = _has_idle_events()
				#var has_physics = _has_physics_events()
				#if has_idle && not has_physics:
				#	listener_events = idle_keys
				#elif not has_idle && has_physics:
				#	listener_events = physics_keys
				#else:
				#	var is_mode = false
				#	for i in idle_keys:

	pass


"""
var _listener = {
	"name": "",
	"ref": null,
	"method": "",
	"oneshot": false,
	"value": null,
}
"""
"""
func publish(event_name, value = null):
    var event_receivers = receivers[event_name]
    for receiver in event_receivers.keys():
        var event = Event.new()
        event.receiver = receiver
        event.method = event_receivers[receiver]
        event.value = value

        events_lock.lock()
        events.push_back(event)
        events_lock.unlock()

func subscribe(event_name, receiver, method):
    if !receiver.has_method(method):
        printerr(receiver, " doesn't have method ", method)
        return

    receivers_lock.lock()
    if !receivers.has(event_name):
        receivers[event_name] = {}
    receivers_lock.unlock()
    receivers[event_name][receiver] = method;


func unsubscribe(event_name, receiver):
    receivers[event_name].erase(receiver)

func queue_size():
    return events.size()
"""
