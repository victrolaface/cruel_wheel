class_name ResourceUtility


# public methods
static func init_default(_self_ref = null, _data = null):
	var data = _on_init_default(_self_ref, _data)
	data.state.cached = _init_cached(data.state, true)
	data = _init_enabled(data)
	return data


static func init_from_manager(_db_ref = null, _mgr_ref = null, _self_ref = null, _data = null):
	var data = _on_init_default(_self_ref, _data)
	data.db_ref = _db_ref
	data.mgr_ref = _mgr_ref
	data.state.has_db_ref = obj_is_valid(_data.db_ref)
	data.state.has_mgr_ref = obj_is_valid(_data.mgr_ref)
	data.state.cached = _init_cached(data.state, false)
	data = _init_enabled(data)
	return data


static func data_is_valid(_data = null):
	var valid = true
	var data_keys = _data.keys()
	var str_arr = PoolStringArray()
	var obj_arr = []

	for k in data_keys:
		if k == "name":
			str_arr.append(_data[k])
		elif k == "base_class_names":
			var names = _data[k]
			for n in names:
				str_arr.append(n)
		elif k == "self_ref" or k == "mgr_ref" or k == "db_ref":
			obj_arr.append(_data[k])

	while valid:
		valid = PathUtility.is_valid(_data.path)  #path(_d.path)
		for s in str_arr:
			valid = StringUtility.is_valid(s)  #str(s)
		for o in obj_arr:
			valid = obj_is_valid(o)  #obj(o)
		valid = _state_is_valid(_data.state)
	return valid


static func disable_data(_data = null):
	if _data.state.enabled:
		_data.self_ref = null
		_data.name = ""
		_data.path = ""
		_data.base_class_names = PoolStringArray()
		_data.db_ref = null
		_data.mgr_ref = null
		_data.state.has_self_ref = false
		_data.state.has_name = false
		_data.state.has_path = false
		_data.state.has_base_class_names = false
		_data.state.has_db_ref = false
		_data.state.has_mgr_ref = false
		_data.state.cached = false
		_data.state.initialized = false
		_data.state.enabled = false
	return _data


# private helper methods
static func obj_is_valid(_obj = null):
	return not _obj == null


static func _on_init_default(_self_ref = null, _data = null):
	if not _data.state.has_self_ref:
		_data.self_ref = _self_ref
	_data.state.has_self_ref = obj_is_valid(_data.self_ref)
	_data.state.is_local = _data.self_ref.resource_local_to_scene
	_data.name = _data.self_ref.resource_name()
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.state.has_base_class_names = _data.base_class_names.size() > 0
	if _data.state.has_name && _data.state.has_base_class_names:
		_data.base_class_names = ClassNameUtility.init_base_class_names([_data.name], _data.base_class_names)
	_data.path = _data.self_ref.resource_path()
	_data.state.has_path = PathUtility.is_valid(_data.path)
	return _data


static func _init_enabled(_data = null):
	_data.state.initialized = _data.state.cached
	_data.state.enabled = _data.state.initialized
	return _data


static func _init_cached(_state = {}, _is_default = false):
	var is_cached = _state.has_self_ref && _state.has_name && _state.has_base_class_names && _state.has_path
	if not _is_default:
		is_cached = is_cached && _state.has_db_ref && _state.has_mgr_ref
	return is_cached


static func _state_is_valid(_state = null):
	var state_keys = _state.keys()
	var state_amt = state_keys.count()
	var state_valid = state_amt > 0
	if state_valid:
		for k in state_keys:
			var kv = _state[k]
			if k == "editor_only":
				if not kv:
					state_valid = not kv
			else:
				state_valid = kv
			if not state_valid:
				break
	return state_valid
