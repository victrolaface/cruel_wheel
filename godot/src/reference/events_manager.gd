class_name EventsManager extends Node

# warning-ignore:UNUSED_SIGNAL
signal register_events_manager

# fields
enum PROCESSING_MODE { IDLE, PHYSICS }
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
	"events_idle_queued_amt": 0,
	"listeners_idle_queued_amt": 0,
	"events_physics_queued_amt": 0,
	"listeners_physics_queued_amt": 0,
	"events_idle_amt": 0,
	"listeners_idle_amt": 0,
	"events_physics_amt": 0,
	"listeners_physics_amt": 0,
}

var _listener = {
	"name": "",
	"ref": null,
	"method": "",
	"oneshot": false,
	"value": null,
}

var _event_listeners_called = {"event_name": "", "listener_names": _arr.init("str")}


func _has_events():
	return _data.events_amt > 0


func _init():
	if not _register_listeners_connected():
		_data.state.register_listeners_connected = _connect_register_listeners(true)
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
	return connected


func disable():
	if _data.state.enabled:
		if _register_listeners_connected():
			if _connect_register_listeners(false):
				_data.state.enabled = not _data.state.enabled


func _ready():
	_register_listeners()


func _enter_tree():
	_register_listeners()


func _process(_delta):
	_proc_events(PROCESSING_MODE.IDLE)


func _physics_process(_delta):
	_proc_events(PROCESSING_MODE.PHYSICS)


func _proc_events(_proc_mode = PROCESSING_MODE.IDLE):
	match _proc_mode:
		PROCESSING_MODE.IDLE:
			_call_listeners(_proc_mode)
			_call_listeners(PROCESSING_MODE.PHYSICS)
		PROCESSING_MODE.PHYSICS:
			# push idle to physics
			# call physics
			_call_listeners(_proc_mode)


func _call_listeners(_proc_mode = PROCESSING_MODE.IDLE):
	if _events_queued_amt() > 0:
		var queued_evnts_amt = 0
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				queued_evnts_amt = _data.events_idle_queued_amt
			PROCESSING_MODE.PHYSICS:
				queued_evnts_amt = _data.events_physics_queued_amt
		if queued_evnts_amt > 0:
			var queued_evnts = {}
			var evnts = {}
			match _proc_mode:
				PROCESSING_MODE.IDLE:
					queued_evnts = _data.event_queue.idle
					evnts = _data.listeners.idle
				PROCESSING_MODE.PHYSICS:
					queued_evnts = _data.event_queue.physics
					evnts = _data.listeners.physics
			var evnts_to_rem = null
			var lstnrs_to_rem = null
			var has_lstnr_to_rem = false
			var init_evnts_to_rem = false
			var init_lstnrs_to_rem = false
			var has_lstnrs_to_rem = false
			var rem_amt = 0
			var queued_evnts_arr = _arr.to_arr(queued_evnts.keys(), "str")
			var evnts_arr = _arr.to_arr(evnts.keys(), "str")
			queued_evnts_amt = queued_evnts_amt if queued_evnts_arr.size() == queued_evnts_amt else queued_evnts_arr.size()
			if queued_evnts_amt > 0:
				var called_evnts_amt = 0
				var evnts_lstnrs = []
				for q in queued_evnts_arr:
					for e in evnts_arr:
						if q == e:
							var called_lstnrs_amt = 0
							var lstnrs = e.keys()
							var lstnrs_amt = lstnrs.size()
							var evnt_lstnrs = _event_listeners_called
							evnt_lstnrs.event_name = e
							rem_amt = 0
							if lstnrs_amt > 0:
								var called_all_lstnrs_in_evnt = false
								for l in lstnrs:
									var lstnr_ref = null
									init_lstnrs_to_rem = false
									match _proc_mode:
										PROCESSING_MODE.IDLE:
											lstnr_ref = _data.listeners.idle[e[l]].ref
										PROCESSING_MODE.PHYSICS:
											lstnr_ref = _data.listeners.physics[e[l]].ref
									lstnr_ref.call(lstnr_ref.method, lstnr_ref.value)
									evnt_lstnrs.listener_names = _arr.add(evnt_lstnrs.listener_names, l, "str")
									called_lstnrs_amt = _int.incr(called_lstnrs_amt)
									if lstnr_ref.oneshot:
										var lstnr_name = lstnr_ref.name
										has_lstnr_to_rem = false
										if not init_lstnrs_to_rem:
											lstnrs_to_rem = {}
											lstnrs_to_rem[e] = _arr.to_arr([], "str", false, lstnr_name)
											init_lstnrs_to_rem = (not lstnrs_to_rem == null && lstnrs_to_rem[e].size() > 0)
											has_lstnr_to_rem = init_lstnrs_to_rem
										else:
											var tmp = lstnrs_to_rem[e]
											var init_amt = tmp.size()
											tmp = _arr.add(tmp, lstnr_name, "str")
											lstnrs_to_rem[e] = tmp
											has_lstnr_to_rem = lstnrs_to_rem[e].size() == init_amt + 1
										if has_lstnr_to_rem:
											rem_amt = _int.incr(rem_amt)
											if not has_lstnrs_to_rem:
												has_lstnrs_to_rem = not has_lstnrs_to_rem
											if rem_amt == lstnrs_amt:
												if not init_evnts_to_rem:
													evnts_to_rem = _arr.to_arr([], "str", false, e)
													init_evnts_to_rem = evnts_to_rem.size() > 0
												else:
													evnts_to_rem = _arr.add(evnts_to_rem, e)
								called_all_lstnrs_in_evnt = called_lstnrs_amt == lstnrs_amt
								if called_all_lstnrs_in_evnt:
									called_evnts_amt = _int.incr(called_evnts_amt)
								evnts_lstnrs.append(evnt_lstnrs)
					if called_evnts_amt == queued_evnts_amt:  #called_all_lstnrs_in_evnts
						pass
						# purge queue
					elif evnts_lstnrs.size() > 0:
						var evnts_called = _arr.init("str")
						var lstnrs_called = _arr.init("str")
						for evnt_lstnrs in evnts_lstnrs:
							var ev_called = evnt_lstnrs.event_name
							if _str.is_valid(ev_called):
								evnts_called = _arr.add(evnts_called, ev_called, "str")
							var lstnrs_called_group = evnt_lstnrs.listener_names
							if lstnrs_called_group.size() > 0:
								for l_called in lstnrs_called_group:
									if _str.is_valid(l_called):
										lstnrs_called = _arr.add(lstnrs_called, l_called, "str")
						if evnts_called.size() > 0 && lstnrs_called.size() > 0:
							for ev_called in evnts_called:
								if queued_evnts.has(ev_called):
									var queued_ev_lstnrs = _arr.init("str")
									match _proc_mode:
										PROCESSING_MODE.IDLE:
											queued_ev_lstnrs = _data.event_queue.idle[ev_called]
										PROCESSING_MODE.PHYSICS:
											queued_ev_lstnrs = _data.event_queue.physics[ev_called]
									var init_lstnrs_amt = queued_ev_lstnrs.size()
									var curr_lstnrs_amt = init_lstnrs_amt
									var idx = 0
									for q_lstnr in queued_ev_lstnrs:
										for l_called in lstnrs_called:
											if q_lstnr == l_called:
												queued_ev_lstnrs = _arr.rem(queued_ev_lstnrs, "str", l_called, idx, true)
												curr_lstnrs_amt = _int.decr(curr_lstnrs_amt)
										idx = _int.incr(idx)
									if queued_ev_lstnrs.size() == 0:
										var events_queued_amt = 0
										var lstnrs_amt = 0
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												_data.event_queue.idle.erase(ev_called)
												events_queued_amt = _data.events_idle_queued_amt
												events_queued_amt = _int.decr(events_queued_amt)
												_data.events_idle_queued_amt = events_queued_amt
												lstnrs_amt = _data.listeners_idle_queued_amt
												lstnrs_amt = lstnrs_amt - init_lstnrs_amt
												_data.listeners_idle_queued_amt = lstnrs_amt
											PROCESSING_MODE.PHYSICS:
												_data.event_queue.physics.erase(ev_called)
												events_queued_amt = _data.events_physics_queued_amt
												events_queued_amt = _int.decr(events_queued_amt)
												_data.events_physics_queued_amt = events_queued_amt
												lstnrs_amt = _data.listeners_physics_queued_amt
												lstnrs_amt = lstnrs_amt - init_lstnrs_amt
												_data.listeners_physics_queued_amt = lstnrs_amt
									else:
										var lstnrs_amt = 0
										var rem_lstnrs_amt = 0
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												_data.event_queue.idle[ev_called] = queued_ev_lstnrs
												lstnrs_amt = _data.listeners_idle_queued_amt
												rem_lstnrs_amt = init_lstnrs_amt - curr_lstnrs_amt
												lstnrs_amt = lstnrs_amt - rem_lstnrs_amt
												_data.listeners_idle_queued_amt = lstnrs_amt
											PROCESSING_MODE.PHYSICS:
												_data.event_queue.physics[ev_called] = queued_ev_lstnrs
												lstnrs_amt = _data.listeners_physics_queued_amt
												rem_lstnrs_amt = init_lstnrs_amt - curr_lstnrs_amt
												lstnrs_amt = lstnrs_amt - rem_lstnrs_amt
												_data.listeners_physics_queued_amt = lstnrs_amt
			if has_lstnrs_to_rem:
				var evnts_w_lstnrs_to_rem = lstnrs_to_rem.keys()
				for el_rem in evnts_w_lstnrs_to_rem:
					for e in evnts:
						if el_rem == e:
							var to_rem = lstnrs_to_rem[el_rem].keys()
							var lstnrs_comp = _arr.init("str")
							match _proc_mode:
								PROCESSING_MODE.IDLE:
									lstnrs_comp = _arr.to_arr(_data.listeners.idle[e].keys(), "str")
								PROCESSING_MODE.PHYSICS:
									lstnrs_comp = _arr.to_arr(_data.listeners.physics[e].keys(), "str")
							var init_amt = lstnrs_comp.size()
							rem_amt = 0
							for l_rem in to_rem:
								for l_comp in lstnrs_comp:
									if l_rem == l_comp:
										var tmp = {}
										match _proc_mode:
											PROCESSING_MODE.IDLE:
												tmp = _data.listeners.idle[e]
											PROCESSING_MODE.PHYSICS:
												tmp = _data.listeners.physics[e]
										if tmp.erase(l_rem):
											rem_amt = _int.incr(rem_amt)
											if init_amt - tmp.size() == rem_amt:
												match _proc_mode:
													PROCESSING_MODE.IDLE:
														_data.listeners.idle[e] = tmp
														_data.listeners_idle_amt = _int.decr(_data.listeners_idle_amt)
													PROCESSING_MODE.PHYSICS:
														_data.listeners.physics[e] = tmp
														_data.listeners_physics_amt = _int.decr(_data.listeners_physics_amt)
			if evnts_to_rem.size() > 0:
				for e_rem in evnts_to_rem:
					for e_comp in evnts_arr:
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


func _on_add_listener(_name = "", _ref = null, _method = "", _oneshot = false):
	var l = _listener
	l.name = _name
	l.ref = _ref
	l.method = _method
	l.oneshot = _oneshot
	l.value = null
	return l


func _events_amt():
	return _data.events_idle_amt + _data.events_physics_amt


func _listeners_amt():
	return _data.listeners_idle_amt + _data.listeners_physics_amt


func _events_queued_amt():
	return _data.events_idle_queued_amt + _data.events_physics_queued_amt


func subscribe(_event = "", _ref = null, _method = "", _proc_mode = PROCESSING_MODE.IDLE, _oneshot = false):
	var subscribed = false
	var added_event_idle = false
	var added_event_physics = false
	var added_listener_idle = false
	var added_listener_physics = false
	var name = _name_from_ref(_event, _ref, _method)
	if _str.is_valid(name):
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				if not _data.listeners.idle.has(_event):
					_data.listeners.idle[_event] = {}
					added_event_idle = _data.listeners.idle.has(_event)
				if not _data.listeners.idle[_event].has(name):
					_data.listeners.idle[_event[name]] = _on_add_listener(name, _ref, _method, _oneshot)
					added_listener_idle = _data.listeners.idle[_event].has(name)
			PROCESSING_MODE.PHYSICS:
				if not _data.listeners.physics.has(_event):
					_data.listeners.physics[_event] = {}
					added_event_physics = _data.listeners.physics.has(_event)
				if not _data.listeners.physics[_event].has(name):
					_data.listeners.physics[_event[name]] = _on_add_listener(name, _ref, _method, _oneshot)
					added_listener_physics = _data.listeners.physics[_event].has(name)
		if added_event_idle:
			_data.events_idle_amt = _int.incr(_data.events_idle_amt)
		if added_listener_idle:
			_data.listeners_idle_amt = _int.incr(_data.listeners_idle_amt)
		if added_event_physics:
			_data.events_physics_amt = _int.incr(_data.events_physics_amt)
		if added_listener_physics:
			_data.listeners_physics_amt = _int.incr(_data.listeners_physics_amt)
		subscribed = added_listener_idle or added_listener_physics
	return subscribed


func _name_from_ref(_event = "", _ref = null, _method = ""):
	var name = ""
	var ref_valid = _obj.is_valid(_ref, _method) if _str.is_valid(_method) else _obj.is_valid(_ref)
	if _str.is_valid(_event) && ref_valid:
		if _ref.is_class("ResourceItem"):
			name = _ref.name if _ref.has_name else _proc_name(_ref)
		else:
			name = _proc_name(_ref)
	return name


func _unsubscribe(_event = "", _name = "", _proc_mode = PROCESSING_MODE.IDLE):
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


func publish(_event = "", _val = null):
	pass


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
