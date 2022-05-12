class_name EventsManager extends Node

# warning-ignore:UNUSED_SIGNAL
signal register_events_manager

enum PROCESSING_MODE { IDLE, PHYSICS }
const _EVENTS_TABLE = "events"
const _EVENTS_SIGNAL = "register_listeners"
const _EVENTS_SIGNAL_FUNC = "_on_register_listeners"
const _SEPERATOR = "-"

# fields
var _data = {
	"events_lock": Mutex.new(),
	"listeners_lock": Mutex.new(),
	"events":
	{
		"idle": {},
		"physics": {},
	},
	"state":
	{
		"enabled": false,
		"register_listeners_connected": false,
	},
	"events_amt": 0,
	"listeners_amt": 0,
}

var _listener = {
	"name": "",
	"ref": null,
	"method": "",
}


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
	_proc_events(false)


func _physics_process(_delta):
	_proc_events(true)


func _proc_events(_physics_proc = false):
	pass


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


func _on_add_listener(_name = "", _ref = null, _method = ""):
	var l = _listener
	l.name = _name
	l.ref = _ref
	l.method = _method
	return l


func subscribe(_event = "", _ref = null, _method = "", _proc_mode = PROCESSING_MODE.IDLE):
	var subscribed = false
	var added_event = false
	var added_listener = false
	if StringUtility.is_valid(_event) && ObjectUtility.is_valid(_ref, _method):
		var name = ""
		if _ref.is_class("ResourceItem"):
			name = _ref.name if _ref.has_name else _proc_name(_ref)
		else:
			_proc_name(_ref)
		match _proc_mode:
			PROCESSING_MODE.IDLE:
				if not _data.events.idle.has(_event):
					_data.events.idle[_event] = {}
					added_event = _data.events.idle.has(_event)
				if not _data.events.idle[_event].has(name):
					_data.events.idle[_event[name]] = _on_add_listener(name, _ref, _method)
					added_listener = _data.events.idle[_event].has(name)
			PROCESSING_MODE.PHYSICS:
				if not _data.events.physics.has(_event):
					_data.events.physics[_event] = {}
					added_event = _data.events.physics.has(_event)
				if not _data.events.physics[_event].has(name):
					_data.events.physics[_event[name]] = _on_add_listener(name, _ref, _method)
					added_listener = _data.events.physics[_event].has(name)
		if added_event:
			_data.events_amt = IntUtility.incr(_data.events_amt)
		if added_listener:
			_data.listeners_amt = IntUtility.incr(_data.listeners_amt)
		subscribed = added_listener
	return subscribed


#export(int) var events_at_once = 1
#export (int, "Idle", "Physics") var processing_mode = 0

#var events_lock = Mutex.new()
#var receivers_lock = Mutex.new()
#const receivers = {}
#const events = []

#class Event:
#    var receiver = null
#    var method = null
#    var value = null

#func _ready():
#set_process(false)
#set_physics_process(false)
#if (processing_mode == PROCESSING_MODE.IDLE):
#    set_process(true)
#elif(processing_mode == PROCESSING_MODE.PHYSICS):
#    set_physics_process(true)

#func _process(delta):
#    _process_events();

#func _physics_process(delta):
#    _process_events()

"""
func _process_events():
    if events.size() == 0:
        return

    var num = min(events_at_once, events.size())
    for i in range(0, num):
        events_lock.lock()
        var event = events.pop_front()
        events_lock.unlock()

        event.receiver.call(event.method, event.value)

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
