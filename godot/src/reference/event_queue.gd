tool
class_name EventQueue extends Resource

# fields
var _str = StringUtility
var _int = IntUtility
var _data = {}


# private inherited methods
func _init():
	resource_local_to_scene = false
	_data = {
		"queue": {},
		"events_amt": 0,
		"to_recycle": [],
		"to_recycle_amt": 0,
		"state":
		{
			"enabled": true,
		}
	}


# public methods
func add(_event_name = "", _val = null):
	var added = false
	if _str.is_valid(_event_name):
		var ev = QueuedEvent
		var has_val = not _val == null
		var add_ev = not has(_event_name)
		var add_ev_val = add_ev && has_val
		var add_val = not add_ev && has_val
		var set_queued_ev = false
		add_ev = add_ev && not has_val
		if add_ev_val or add_ev:
			if _data.to_recycle_amt > 0:
				var idx = _data.to_recycle_amt - 1
				ev = _data.to_recycle[idx]
				set_queued_ev = ev.enable(_event_name, _val) if add_ev_val else ev.enable(_event_name)
				_data.to_recycle.remove(idx)
				_data.to_recycle_amt = idx
			else:
				ev = QueuedEvent.new(_event_name, _val) if add_ev_val else QueuedEvent.new(_event_name)
				set_queued_ev = ev.enabled
			if set_queued_ev:
				_data.events_amt = _int.incr(_data.events_amt)
		elif add_val:
			ev = _data.queue[_event_name]
			set_queued_ev = ev.add_val(_val)
		if set_queued_ev:
			_data.queue[_event_name] = ev
			added = set_queued_ev
	return added


func remove(_event_name = ""):
	var rem = false
	if _str.is_valid(_event_name) && has(_event_name):
		var ev = _data.queue[_event_name]
		rem = ev.disable()
		if rem:
			_data.queue.erase(_event_name)
			_data.events_amt = _int.decr(_data.events_amt)
			_data.to_recycle.append(ev)
			_data.to_recycle_amt = _int.incr(_data.to_recycle_amt)
	return rem


func add_val(_event_name = "", _val = null):
	var added = false
	if _str.is_valid(_event_name) && has(_event_name):
		var ev = _data.queue[_event_name]
		if not ev.has_val(_val):
			added = ev.add_val(_val)
			if added:
				_data.queue[_event_name] = ev
	return added


func has(_event_name = ""):
	var h = false
	if _str.is_valid(_event_name) && _data.events_amt > 0:
		for e in _data.queue.keys():
			h = _event_name == e
			if h:
				break
	return h
