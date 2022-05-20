tool
class_name QueuedEvent extends Resource

# properties
export(bool) var enabled setget , get_enabled

# fields
var _str = StringUtility
var _int = IntUtility
var _data = {}


# private inherited methods
func _init(_event_name = "", _val = null):
	resource_local_to_scene = true
	_on_init(true, _event_name, _val)


# public methods
func enable(_event_name = "", _val = null):
	_on_init(true, _event_name, _val)
	return _data.state.enabled


func disable():
	_on_init(false)
	return not _data.state.enabled


func add_val(_val = null):
	var on_add = not _val == null && not has_val(_val)
	if on_add:
		_data.vals.append(_val)
		_data.vals_amt = _int.incr(_data.vals_amt)
	return on_add


func has_val(_val = null):
	var has = false
	if _data.vals_amt > 0:
		for v in _data.vals:
			has = _val == v
			if has:
				break
	return has


# private helper methods
func _on_init(_do_init = false, _event_name = "", _val = null):
	_data = {
		"event_name": "",
		"vals": [],
		"vals_amt": 0,
		"state":
		{
			"has_event_name": false,
			"has_val": false,
			"enabled": false,
		}
	}
	if _do_init:
		var dt = _data
		var st = dt.state
		st.has_event_name = _str.is_valid(_event_name)
		if st.has_event_name:
			dt.event_name = _event_name
		st.has_val = not _val == null
		if st.has_val:
			dt.val = _val
			dt.vals_amt = _int.incr(dt.vals_amt)
		st.enabled = st.has_event_name if not st.has_val else st.has_event_name && st.has_val
		if st.enabled:
			_data = dt
			_data.state = st


# setters, getters functions
func get_enabled():
	return _data.state.enabled
