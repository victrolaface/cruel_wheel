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
	var on_add = false
	if _str.is_valid(_event_name):
		var ev = QueuedEvent
		var has_val = not _val == null
		var add_ev = not has(_event_name)
		var add_ev_val = add_ev && has_val
		var add_val = not add_ev && has_val
		add_ev = add_ev && not has_val
		if add_ev_val or add_ev:
			if _data.to_recycle_amt > 0:
				var idx = _data.to_recycle_amt - 1
				ev = _data.to_recycle[idx]
				on_add = ev.enable(_event_name, _val) if add_ev_val else ev.enable(_event_name)
				_data.to_recycle.remove(idx)
				_data.to_recycle_amt = idx
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
			_data.to_recycle.append(ev)
			_data.to_recycle_amt = _int.incr(_data.to_recycle_amt)
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
