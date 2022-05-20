tool
class_name EventListeners extends Resource

# fields
var _str = StringUtility
var _obj = ObjectUtility
var _arr = PoolArrayUtility
var _int = IntUtility
var _type = TypeUtility
var _data = {}


# private inherited methods
func _init():
	resource_local_to_scene = false
	_data = {
		"listeners": {},
		"listeners_amt": 0,
		"to_recycle": [],
		"to_recycle_amt": 0,
		"state":
		{
			"enabled": true,
		}
	}


# public methods
func has(_event_name = "", _listener_name = ""):
	return _has_listener(_event_name, _listener_name)


func add(_event = "", _listener = "", _ref = null, _method = "", _val = null, _oneshot = false):
	var on_add = false
	if _names_valid(_event, _listener) && not has(_event, _listener) && _obj.is_valid(_ref, _method):
		var has_ev = false
		if _is_event(_event) && _listener_events_keys().size() > 0:
			for e in _listener_events_keys():
				has_ev = e == _event
				if has_ev:
					break
		if not has_ev or (has_ev && not _has_listener(_event, _listener)):
			var on_recycle = _data.recycle_amt > 0
			var ls = EventListener
			var idx = 0
			if on_recycle:
				idx = _data.to_recycle_amt - 1
				ls = _data.to_recycle[idx]
				ls.enable(_ref, _method, _val, _oneshot)
			else:
				ls = EventListener.new(_ref, _method, _val, _oneshot)
			on_add = ls.enabled
			if on_add:
				_data.listeners[_event[_listener]] = ls
				if on_recycle:
					_data.to_recycle.remove(idx)
					_data.to_recycle_amt = idx
				_data.listeners_amt = _int.incr(_data.listeners_amt)
	return on_add


func remove(_event_name = "", _listener_name = ""):
	var on_rem = false
	if has(_event_name, _listener_name):
		var ls = _data.listeners[_event_name[_listener_name]]
		on_rem = ls.disable()
		if on_rem:
			_data.to_recycle.append(ls)
			_data.to_recycle_amt = _int.incr(_data.to_recycle_amt)
			_data.listeners[_event_name].erase(_listener_name)
			_data.listeners_amt = _int.decr(_data.listeners_amt)
	return on_rem


# private helper methods
func _names_valid(_event_name = "", _listener_name = ""):
	return _is_event(_event_name) && _str.is_valid(_listener_name)


func _is_event(_event_name = ""):
	return _str.is_valid(_event_name)


func _has_listeners():
	return _data.listeners_amt > 0


func _listener_events_keys():
	var keys = []
	if _has_listeners():
		keys = _arr.to_arr(_data.listeners.keys(), "str")
	return keys


func _has_listener(_event_name = "", _listener_name = ""):
	var h = false
	var ev_ls_keys = []
	if _is_event(_event_name) && _has_listeners():
		for e in _listener_events_keys():
			if e == _event_name:
				ev_ls_keys = _arr.to_arr(_data.listeners[e].keys(), "str")
				break
	if ev_ls_keys.size() > 0:
		for l in ev_ls_keys:
			h = l == _listener_name
			if h:
				break
	return h
