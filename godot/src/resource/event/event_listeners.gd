tool
class_name EventListeners extends RecyclableItems

# properties
export(bool) var has_listeners setget , get_has_listeners
export(Array, String) var event_keys setget , get_event_keys

# fields
const _RES_PATH = "res://data/event/event_listeners_storage.tres"
var _type = TypeUtility
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


func has(_event_name = "", _listener_name = ""):
	var has_ls = false
	var has_ev = _has_event(_event_name)
	var has_ev_ls = false
	if has_ev && _has_listeners():
		for e in _listener_events_keys():
			if e == _event_name:
				for l in _event_listeners_keys(e):
					has_ls = l == _listener_name
					if has_ls:
						break
		has_ev_ls = has_ev && has_ls
	return has_ev_ls


func add(_event = "", _listener = "", _ref = null, _method = "", _val = null, _oneshot = false):
	var on_add = false
	if _is_event(_event) && _str.is_valid(_listener) && not has(_event, _listener) && _obj.is_valid(_ref, _method):
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


func call_listeners(_event_name = "", _vals_arr = []):
	var called_listeners = false
	if _has_events() && _has_event(_event_name):
		var e = _event_name
		var listener_names = _event_listeners_keys(_event_name)
		var vals_are_obj_type = false
		var vals_are_built_in_type = false
		var vals_built_in_type = 0
		var vals_obj_type = ""
		if _vals_arr.size() > 0:
			var idx = 0
			var init = false
			var incr_idx = false
			for v in _vals_arr:
				if not v == null:
					if idx == 0:
						vals_are_built_in_type = _type.is_built_in_type(v)
						if vals_are_built_in_type:
							vals_built_in_type = _type.built_in_type(v)
							init = vals_are_built_in_type && not vals_built_in_type == 0
						else:
							vals_are_obj_type = _type.is_type_object(v)
							if vals_are_obj_type:
								vals_obj_type = v.get_class()
								init = vals_are_obj_type && _str.is_valid(vals_obj_type)
					else:
						if vals_are_built_in_type:
							incr_idx = _type.built_in_type(v) == vals_built_in_type
						elif vals_are_obj_type:
							incr_idx = v.get_class() == vals_obj_type
					if init:
						incr_idx = init
					if incr_idx:
						idx = _int.incr(idx)
					else:
						break
				else:
					break
		for n in listener_names:
			var called_listener = false
			var is_oneshot = _data.listeners[e[n]].is_oneshot
			if (
				_data.listeners[e[n]].takes_val
				&& (
					(
						_data.listeners[e[n]].takes_val_built_in
						&& vals_are_built_in_type
						&& _data.listeners[e[n]].val_built_in_type == vals_built_in_type
					)
					or (
						_data.listeners[e[n]].takes_val_obj
						&& vals_are_obj_type
						&& _data.listeners[e[n]].val_obj_type == vals_obj_type
					)
				)
			):
				if is_oneshot:
					called_listener = _data.listeners[e[n]].call_funcref(_vals_arr[0])
				else:
					for v in _vals_arr:
						called_listener = _data.listeners[e[n]].call_funcref(v)
						if not called_listener:
							break
			else:
				called_listener = _data.listeners[e[n]].call_funcref()
			if called_listener:
				called_listeners = remove(e, n) if is_oneshot else true
			if not called_listeners:
				break
	return called_listeners


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
	var on_enable = _en && not self.enabled
	var on_disable = not _en && self.enabled
	var saved_on_disabled = false
	if on_enable:
		_init()
	elif on_disable:
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
			on_disable = (
				total_ls_amt == 0
				&& total_ls_amt == _data.listeners_amt
				&& evs_amt == 0
				&& _events_amt() == 0
				&& evs_amt == _events_amt()
				&& not _has_listeners()
				&& not _has_events()
				&& rec_amt == self.to_recycle_amt
			)
		if on_disable && .on_disable():
			saved_on_disabled = not self.enabled && ResourceSaver.save(_RES_PATH, self, ResourceSaver.FLAG_COMPRESS)
	return on_enable or saved_on_disabled


func _has_event(_event_name = ""):
	var has_ev = false
	if _is_event(_event_name):
		for e in _listener_events_keys():
			has_ev = e == _event_name
			if has_ev:
				break
	return has_ev


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


func get_event_keys():
	return _listener_events_keys()
