tool
class_name EventListeners extends RecyclableItems

export(bool) var has_listeners setget , get_has_listeners

# fields
const _RES_PATH = "res://data/event_listeners.tres"

var _storage = preload(_RES_PATH)
var _data = {}


# private inherited methods
func _init():
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
func enable():
	return _on_enable(true)


func disable():
	return _on_enable(false)


func has_event(_event_name = ""):
	var has_ev = false
	if _is_event(_event_name):
		for e in _listener_events_keys():
			has_ev = e == _event_name
			if has_ev:
				break
	return has_ev


func has(_event_name = "", _listener_name = ""):
	var has_ls = false
	if has_event(_event_name) && _has_listeners():
		for e in _listener_events_keys():
			if e == _event_name:
				for l in _event_listeners_keys(e):
					has_ls = l == _listener_name
					if has_ls:
						break
	return has_ls


func add(_event = "", _listener = "", _ref = null, _method = "", _val = null, _oneshot = false):
	var on_add = false
	if _names_valid(_event, _listener) && not has(_event, _listener) && _obj.is_valid(_ref, _method):
		var has_ev = false
		if _has_events() && _is_event(_event):
			for e in _listener_events_keys():
				has_ev = e == _event
				if has_ev:
					break
		if not has_ev or (has_ev && not has(_event, _listener)):
			var ls = EventListener
			if self.has_to_recycle:
				ls = .recycled()
				ls.enable(_ref, _method, _val, _oneshot)
			else:
				ls = EventListener.new(_ref, _method, _val, _oneshot)
			on_add = ls.enabled
			if on_add:
				_data.listeners[_event[_listener]] = ls
				_data.listeners_amt = _int.incr(_data.listeners_amt)
	return on_add


func remove(_event_name = "", _listener_name = ""):
	var on_rem = false
	if _has_events() && has(_event_name, _listener_name):
		var ls = _data.listeners[_event_name[_listener_name]]
		if ls.disable():
			on_rem = .add_to_recycled(ls)
		if on_rem:
			_data.listeners[_event_name].erase(_listener_name)
			_data.listeners_amt = _int.decr(_data.listeners_amt)
	return on_rem


# private helper methods
func _on_enable(_en = true):
	var en = _en && not self.enabled
	var dis = not _en && self.enabled
	if dis:
		if _data.listeners_amt > 0:
			var ls_amt = 0
			var total_ls_amt = _data.listeners_amt
			var rec_amt = self.to_recycle_amt
			var evs_amt = _events_amt()
			for e in _listener_events_keys():
				var ev_ls = _event_listeners_keys(e)
				ls_amt = ev_ls.size()
				for l in ev_ls:
					if remove(e, l):
						ls_amt = _int.decr(ls_amt)
						rec_amt = _int.incr(rec_amt)
						total_ls_amt = _int.decr(total_ls_amt)
						if ls_amt == 0:
							_data.listeners.erase(e)
							evs_amt = _int.decr(evs_amt)
			dis = (
				total_ls_amt == 0
				&& total_ls_amt == _data.listeners_amt
				&& evs_amt == 0
				&& _events_amt() == 0
				&& evs_amt == _events_amt()
				&& not _has_listeners()
				&& not _has_events()
				&& rec_amt == self.to_recycle_amt
			)
		if dis && .on_disable():
			dis = not self.enabled && ResourceSaver.save(_RES_PATH, self, ResourceSaver.FLAG_COMPRESS)
	elif en:
		_init()
	return dis or en


func _names_valid(_event_name = "", _listener_name = ""):
	return _is_event(_event_name) && _str.is_valid(_listener_name)


func _is_event(_event_name = ""):
	return _str.is_valid(_event_name)


func _has_listeners():
	return _data.listeners_amt > 0


func _events_amt():
	return _data.listeners.keys().size()


func _has_events():
	return _events_amt() > 0


func _listener_events_keys():
	return _data.listeners.keys() if _has_listeners() else []


func _event_listeners_keys(_event_name = ""):
	return _data.listeners[_event_name].keys() if _is_event(_event_name) && _has_events() else []


# setters, getters functions
func get_has_listeners():
	return _has_listeners()
