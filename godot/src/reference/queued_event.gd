tool
class_name QueuedEvent extends Resource

# properties
export(String) var event_name setget , get_event_name
export(int) var process_mode setget , get_process_mode
export(bool) var has_event_name setget , get_has_event_name
export(bool) var has_val setget , get_has_val
export(bool) var has_process_mode setget , get_has_process_mode
export(bool) var has_listeners setget , get_has_listeners
export(bool) var has_listeners_oneshot setget , get_has_listeners_oneshot
export(bool) var enabled setget , get_enabled

# fields
var _obj = ObjectUtility
var _str = StringUtility
var _arr = PoolArrayUtility
var _int = IntUtility
var _data = {}


# private inherited methods
func _init(_event_name = "", _val = null, _proc_mode = 0, _listener_names = [], _listener_names_oneshot = []):
	resource_local_to_scene = true
	_on_init(true, _event_name, _val, _proc_mode, _listener_names, _listener_names_oneshot)

func destroy():
	_on_init(false)
	return not _data.state.enabled
	
# private helper methods
func _on_init(_do_init = false, _ev_name = "", _v = null, _proc_mode = 0, _l_names = [], _l_names_oneshot = []):
	_data = {
		"event_name": "",
		"val": null,
		"proc_mode": 0,
		"listener_names": [],
		"listener_names_oneshot": [],
		"listener_names_called": [],
		"listener_names_oneshot_called": [],
		"state":
		{
			"has_event_name": false,
			"has_val": false,
			"has_proc_mode": false,
			"has_listeners": false,
			"has_listeners_oneshot": false,
			"called_all_listeners": false,
			"called_all_listeners_oneshot": false,
			"enabled": false,
		}
	}
	if _do_init:
		var dt = _data
		var st = dt.state
		var ls_valid = false
		st.has_event_name = _str.is_valid(_ev_name)
		if st.has_event_name:
			dt.event_name = _ev_name
		st.has_val = not _v == null
		if st.has_val:
			dt.val = _v
		st.has_proc_mode = not _proc_mode == 0 && _proc_mode == 1 or _proc_mode == 2
		if st.has_proc_mode:
			dt.proc_mode = _proc_mode
		st.has_listeners = _l_names.size() > 0
		st.has_listeners_oneshot = _l_names_oneshot.size() > 0
		if st.has_listeners:
			dt.listener_names = _arr.to_arr(_l_names, "str")
		if st.has_listeners_oneshot:
			dt.listener_names_oneshot = _arr.to_arr(_l_names_oneshot, "str")
		if st.has_listeners && st.has_listeners_oneshot:
			if _valid_listener_names(dt.listener_names):
				ls_valid = _valid_listener_names(dt.listener_names_oneshot)
		elif st.has_listeners && not st.has_listeners_oneshot:
			ls_valid = _valid_listener_names(dt.listener_names)
		elif not st.has_listeners && st.has_listeners_oneshot:
			ls_valid = _valid_listener_names(dt.listener_names_oneshot)
		st.enabled = (
			ls_valid
			&& st.has_event_name
			&& st.has_val
			&& st.has_proc_mode
			&& (st.has_listeners or st.has_listeners_oneshot)
		)
		if st.enabled:
			_data = dt
			_data.state = st


func _valid_listener_names(_ls = []):
	var valid = false
	var idx = 0
	for n in _ls:
		valid = _str.is_valid(n)
		if valid:
			continue
		else:
			break
		idx = _int.incr(idx)
	return valid


func _ret_on_enabled(_val = null):
	var ret_invalid = null
	match typeof(_val):
		TYPE_STRING:
			ret_invalid = ""
		TYPE_BOOL:
			ret_invalid = false
		TYPE_INT:
			ret_invalid = 0
	return _val if _data.state.enabled else ret_invalid


# setters, getters functions
func get_event_name():
	_ret_on_enabled(_data.event_name)


func get_process_mode():
	_ret_on_enabled(_data.proc_mode)


func get_has_event_name():
	_ret_on_enabled(_data.state.has_event_name)


func get_has_val():
	_ret_on_enabled(_data.state.has_val)


func get_has_process_mode():
	_ret_on_enabled(_data.state.has_proc_mode)


func get_has_listeners():
	_ret_on_enabled(_data.state.has_listeners)


func get_has_listeners_oneshot():
	_ret_on_enabled(_data.state.has_listeners_oneshot)


func get_enabled():
	_ret_on_enabled(_data.state.enabled)
