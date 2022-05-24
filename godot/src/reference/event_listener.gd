tool
class_name EventListener extends Resource

# properties
#export(bool) var method_takes_val setget , get_method_takes_val
export(int) var val_built_in_type setget , get_val_built_in_type
export(bool) var is_oneshot setget , get_is_oneshot
export(bool) var takes_val setget , get_takes_val
export(bool) var takes_val_obj setget , get_takes_val_obj
export(bool) var takes_val_built_in setget , get_takes_val_built_in
export(bool) var enabled setget , get_enabled
export(String) var val_obj_type setget , get_val_obj_type

# fields
var _obj = ObjectUtility
var _str = StringUtility
var _type = TypeUtility
var _data = {}

func get_val_built_in_type():
	var built_in_type = 0
	if _data.state.method_takes_val && _data.state.method_val_is_built_in_type:
		built_in_type = _data.method_val_built_in_type
	return built_in_type

func get_val_obj_type():
	var obj_type = ""
	if _data.state.method_takes_val && _data.state.method_val_is_type:
		obj_type = _data.method_val_type
	return obj_type

# private inherited methods
func _init(_ref = null, _method = "", _val = null, _oneshot = false):
	resource_local_to_scene = true
	_on_init(true, _ref, _method, _val, _oneshot)


# public methods
func enable(_ref = null, _method = "", _val = null, _oneshot = false):
	_on_init(true, _ref, _method, _val, _oneshot)
	return _data.state.enabled


func call_funcref(_val = null):
	var called = false
	if _data.state.enabled:
		if not _val == null && _data.state.method_takes_val && _method_takes(_val):
			_data.method_funcref.call_func(_val)
		else:
			_data.method_funcref.call_func()
		called = true
	return called


func disable():
	_on_init(false)
	return not _data.state.enabled


func _method_takes(_val = null):
	var takes = false
	if not _val == null && _data.state.method_takes_val:
		if _type.is_built_in_type(_val) && _data.state.method_val_is_built_in_type:
			takes = _type.built_in_type(_val) == _data.method_val_built_in_type
		if not takes:
			takes = _val.get_class() == _data.state.method_val_type
	return takes


# private helper functions
func _on_init(_do_init = false, _ref = null, _method = "", _val = null, _oneshot = false):
	_data = {
		"ref": null,
		"method_funcref": null,
		"method_val_type": "",
		"method_val_built_in_type": 0,
		"state":
		{
			"enabled": false,
			"is_oneshot": false,
			"has_ref": false,
			"method_takes_val": false,
			"method_val_is_built_in_type": false,
			"method_val_is_type": false,
		},
	}
	if _do_init:
		var dt = _data
		var st = _data.st
		st.has_ref = _obj.is_valid(_ref, _method)
		if st.has_ref:
			dt.ref = _ref
			dt.method_funcref = funcref(dt.ref, _method)
		st.method_takes_val = st.has_ref && not _val == null
		if st.method_takes_val:
			st.method_val_is_built_in_type = _type.is_built_in_type(_val)
			if st.method_val_is_built_in_type:
				dt.method_val_built_in_type = _type.built_in_type(_val)
			else:
				dt.method_val_type = _val.get_class()
				st.method_val_is_type = _str.is_valid(dt.val_type)
		st.is_oneshot = _oneshot
		if st.has_ref:
			if st.method_takes_val:
				st.enabled = st.method_val_is_built_in_type or st.method_val_is_type
			else:
				st.enabled = st.has_ref
		if st.enabled:
			_data = dt
			_data.state = st


# setters, getters functions
#func get_method_takes_val():
#	return _data.state.method_takes_val


func get_is_oneshot():
	return _data.state.is_oneshot


func get_takes_val():
	return _data.state.method_takes_val


func get_takes_val_obj():
	return _data.state.method_takes_val && _data.state.method_val_is_type  #takes_val


func get_takes_val_built_in():
	return _data.state.method_takes_val && _data.state.method_val_is_built_in_type  #_type_built_in


func get_enabled():
	return _data.state.enabled
