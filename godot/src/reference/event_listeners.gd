tool
class_name EventListeners extends RecyclableItems

export(bool) var has_listeners setget , get_has_listeners

# fields
const _RES_PATH = "res://data/event_listeners.tres"

var _storage = preload(_RES_PATH)
var _arr = PoolArrayUtility
var _type = TypeUtility
var _data = {}


# private inherited methods
func _init():
	self.resource_local_to_scene = false
	_data = {
		"listeners": {},
		"listeners_amt": 0,
	}
	var to_rec = []
	var to_rec_amt = 0
	if _storage.initialized:
		if not _storage.enabled:
			_storage.enable()
		if not _storage.has_listeners && _storage.has_to_recycle:
			to_rec = _storage.to_recycle
			to_rec_amt = _storage.to_recycle_amt
	.init("EventListener", to_rec, to_rec_amt)


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


# setters, getters functions
func get_has_listeners():
	return _has_listeners()

#export(Array, Resource) var to_recycle setget , get_to_recycle
#export(int) var to_recycle_amt setget , get_to_recycle_amt
#export(bool) var has_to_recycle setget , get_has_to_recycle
#export(bool) var enabled setget , get_enabled
#export(bool) var initialized setget , get_initialized
#func get_to_recycle():
#	return _data.to_recycle
#func get_to_recycle_amt():
#	return _data.to_recycle_amt
#func get_has_to_recycle():
#	return _data.to_recycle_amt>0

#func get_enabled():
#	return _data.state.enabled

#func get_initialized():
#	retunr _data.state.initialized

#var _str = StringUtility
#var _obj = ObjectUtility

#var _int = IntUtility

#"to_recycle": [],
#"to_recycle_amt": 0,
#"state":
#{
#	"enabled": true,
#}
