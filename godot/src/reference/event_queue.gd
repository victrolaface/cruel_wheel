tool
class_name EventQueue extends RecyclableItems

# properties
export(int) var events_amt setget , get_events_amt
export(bool) var has_events setget , get_has_events
export(Array, String) var event_keys setget , get_event_keys

# fields
const _RES_PATH = "res://data/event_queue.tres"
var _storage = preload(_RES_PATH)
var _data = {}


# private inherited methods
func _init():
	_data = {
		"queue": {},
		"events_amt": 0,
		"state":
		{
			"enabled": false,
		}
	}
	var to_rec = []
	var to_rec_amt = 0
	if _storage.initialized:
		if not _storage.enabled:
			_storage.enable()
		if not _storage.has_events && _storage.has_to_recycle:
			to_rec = _storage.to_recycle
			to_rec_amt = _storage.to_recycle_amt
	.init("QueuedEvent", to_rec, to_rec_amt)


# public methods
func enable():
	return _on_enable(true)


func disable():
	return _on_enable(false)


func add(_event_name = "", _val = null):
	var on_add = false
	if _str.is_valid(_event_name):
		var ev = QueuedEvent
		var has_val = not _val == null
		var add_ev = not has(_event_name)
		var add_ev_val = add_ev && has_val
		var add_val = not add_ev && has_val
		add_ev = add_ev && not has_val
		if add_ev_val or add_ev:
			if self.has_to_recycle:
				ev = .recycled()
				if not ev == null:
					on_add = ev.enable(_event_name, _val) if add_ev_val else ev.enable(_event_name)
			else:
				ev = QueuedEvent.new(_event_name, _val) if add_ev_val else QueuedEvent.new(_event_name)
				on_add = ev.enabled
			if on_add:
				_data.events_amt = _int.incr(_data.events_amt)
		elif add_val:
			ev = _data.queue[_event_name]
			on_add = ev.add_val(_val)
		if on_add:
			_data.queue[_event_name] = ev
	return on_add


func pop(_event_name = ""):
	var ev = null
	if has(_event_name):
		ev = _data.queue[_event_name]
		if not ev == null:
			if not _remove(_event_name):
				ev = null
	return ev


func has(_event_name = ""):
	var has_ev = false
	if _str.is_valid(_event_name) && _has_events():
		for e in _queue_keys():
			has_ev = _event_name == e
			if has_ev:
				break
	return has_ev


func empty_queue():
	var on_empty = false
	var evs_amt = _data.events_amt
	if _has_events():
		for e in _queue_keys():
			if _remove(e):
				evs_amt = _int.decr(evs_amt)
		if not evs_amt == 0:
			_data.queue.clear()
			_data.events_amt = 0
	return on_empty


# private helper methods
func _on_enable(_en = true):
	var on_enable = _en && not self.enabled
	var on_disable = not _en && self.enabled
	var saved_on_disable = false
	if on_enable:
		_init()
	elif on_disable:
		var rec_amt = self.to_recycle_amt
		var evs_amt = _data.events_amt
		if _has_events():
			for e in _queue_keys():
				if _remove(e):
					evs_amt = _int.decr(evs_amt)
					rec_amt = _int.incr(rec_amt)
		if evs_amt == 0 && evs_amt == _data.events_amt && rec_amt == self.to_recycle_amt && .on_disable():
			saved_on_disable = not self.enabled && ResourceSaver.save(_RES_PATH, self, ResourceSaver.FLAG_COMPRESS)
	return on_enable or saved_on_disable


func _remove(_event_name = ""):
	var on_rem = false
	if _str.is_valid(_event_name) && has(_event_name):
		var ev = _data.queue[_event_name]
		on_rem = ev.disable()
		if on_rem:
			_data.queue.erase(_event_name)
			_data.events_amt = _int.decr(_data.events_amt)
			on_rem = .add_to_recycled(ev)
	return on_rem


func _has_events():
	return _data.events_amt > 0


func _queue_keys():
	return _data.queue.keys()


# setters, getters functions
func get_events_amt():
	return _data.events_amt


func get_has_events():
	return _has_events()


func get_event_keys():
	return _queue_keys() if _has_events() else []
