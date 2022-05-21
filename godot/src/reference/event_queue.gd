tool
class_name EventQueue extends RecyclableItems

# properties
export(bool) var has_events setget , get_has_events

# fields
const _RES_PATH = "res://data/event_queue.tres"

var _storage = preload(_RES_PATH)
var _data = {}


# private inherited methods
func _init():
	_data = {
		"queue": {},
		"events_amt": 0,
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


func remove(_event_name = ""):
	var on_rem = false
	if _str.is_valid(_event_name) && has(_event_name):
		var ev = _data.queue[_event_name]
		on_rem = ev.disable()
		if on_rem:
			_data.queue.erase(_event_name)
			_data.events_amt = _int.decr(_data.events_amt)
			on_rem = .add_to_recycled(ev)
	return on_rem


func add_val(_event_name = "", _val = null):
	var on_add = false
	if _str.is_valid(_event_name) && has(_event_name):
		var ev = _data.queue[_event_name]
		if not ev.has_val(_val):
			on_add = ev.add_val(_val)
			if on_add:
				_data.queue[_event_name] = ev
	return on_add


func has(_event_name = ""):
	var has_ev = false
	if _str.is_valid(_event_name) && _data.events_amt > 0:
		for e in _data.queue.keys():
			has_ev = _event_name == e
			if has_ev:
				break
	return has_ev


# private helper methods
func _on_enable(_do_en = true):
	var en = _do_en && not self.enabled
	var dis = not _do_en && self.enabled
	if dis:
		var rec_amt = self.to_recycle_amt
		var ev_amt = _data.events_amt
		if ev_amt > 0:
			for e in _data.queue.keys():
				if remove(e):
					ev_amt = _int.decr(ev_amt)
					rec_amt = _int.incr(rec_amt)
		dis = ev_amt == _data.events_amt && rec_amt == self.to_recycle_amt
		if dis && .on_disable():
			dis = not self.enabled && ResourceSaver.save(_RES_PATH, self, ResourceSaver.FLAG_COMPRESS)
	elif en:
		_init()
	return dis or en


# setters, getters functions
func get_has_events():
	return _data.events_amt > 0
