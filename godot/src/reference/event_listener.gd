tool
class_name EventListener extends Resource

# properties
export(String) var event_name setget , get_event_name
export(String) var listener_name setget , get_listener_name
export(String) var method_name setget , get_method_name
export(bool) var has_event_name setget , get_has_event_name
export(bool) var is_oneshot setget , get_is_oneshot
export(bool) var has_method setget , get_has_method
export(bool) var has_process_mode setget , get_has_process_mode
export(bool) var has_listener_name setget , get_has_listener_name
export(bool) var has_listener_ref setget , get_has_listener_ref
export(bool) var enabled setget , get_enabled
export(int) var process_mode setget , get_process_mode

# fields
const _SEPERATOR = "-"
var _obj = ObjectUtility
var _str = StringUtility
var _data = {}


# private inherited methods
func _init(_event_name = "", _ref = null, _method_name = "", _proc_mode = 0, _oneshot = false):
	resource_local_to_scene = true
	_on_init(true, _event_name, _ref, _method_name, _proc_mode, _oneshot)


# public methods
func destroy():
	_on_init(false)
	return not _data.state.enabled


# private helper methods
func _on_init(_do_init = true, _event_name = "", _ref = null, _method_name = "", _proc_mode = 0, _oneshot = false):
	_data = {
		"event_name": "",
		"listener_name": "",
		"listener_ref": null,
		"method_name": "",
		"proc_mode": 0,
		"state":
		{
			"has_event_name": false,
			"is_oneshot": false,
			"has_method": false,
			"has_proc_mode": false,
			"has_listener_name": false,
			"has_listener_ref": false,
			"enabled": false,
		}
	}
	if _do_init:
		var dt = _data
		var st = dt.state
		st.has_event_name = _str.is_valid(_event_name)
		st.has_listener_ref = _obj.is_valid(_ref, _method_name)
		st.has_method = _data.state.has_listener_ref
		if st.has_method:
			dt.method_name = _method_name
		if st.has_event_name && st.has_listener_ref:
			dt.event_name = _event_name
			dt.listener_ref = _ref
			if dt.listener_ref.is_class("ResourceItem") && dt.listener_ref.has_name:
				dt.listener_name = dt.listener_ref.name
			else:
				dt.listener_name = (
					dt.listener_ref.get_class()
					+ _SEPERATOR
					+ String(dt.listener_ref.resource_id)
					+ _SEPERATOR
				)
				if dt.listener_ref.resource_local_to_scene:
					dt.listener_name = dt.listener_name + String(dt.listener_ref.get_instance_id())
				else:
					dt.listener_name = dt.listener_name + "global"
			st.has_listener_name = _str.is_valid(dt.listener_name)
		st.has_proc_mode = (not _proc_mode == 0 && (_proc_mode == 1 or _proc_mode == 2))
		if st.has_proc_mode:
			dt.proc_mode = _proc_mode
		st.is_oneshot = _oneshot
		for is_st in st.keys():
			st.enabled = is_st
			if not st.enabled:
				break
		if st.enabled:
			_data = dt
			_data.state = st


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
	return _ret_on_enabled(_data.event_name)


func get_listener_name():
	return _ret_on_enabled(_data.listener_name)


func get_method_name():
	return _ret_on_enabled(_data.method_name)


func get_process_mode():
	return _ret_on_enabled(_data.proc_mode)


func get_has_event_name():
	return _ret_on_enabled(_data.state.has_event_name)


func get_is_oneshot():
	return _ret_on_enabled(_data.state.is_oneshot)


func get_has_method():
	return _ret_on_enabled(_data.state.has_method)


func get_has_process_mode():
	return _ret_on_enabled(_data.state.has_proc_mode)


func get_has_listener_name():
	return _ret_on_enabled(_data.state.has_listener_name)


func get_has_listener_ref():
	return _ret_on_enabled(_data.state.has_listener_ref)


func get_enabled():
	return _ret_on_enabled(_data.state.enabled)
