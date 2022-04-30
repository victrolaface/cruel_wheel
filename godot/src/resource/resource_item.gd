tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var editor_only setget , get_editor_only
export(bool) var local setget , get_local
export(bool) var has_parent_class setget , get_has_parent_class
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(int) var id setget , get_id
export(String) var name setget , get_name
export(String) var path setget , get_path
export(String) var parent_class setget , get_parent_class

# fields
var _i = {
	"name": "",
	"path": "",
	"id": 0,
	"class_names": PoolStringArray(["ResourceItem, Resource"]),
	"base_path": "res://src/resource/resource_item.gd",
	"state":
	{
		"editor_only": false,
		"local": true,
		"enabled": false,
	}
}


# private inherited methods
func _init(_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	_i.state.local = _init_local(_local, _i.state.local, _id)
	_i.state.editor_only = _init_editor_only(_editor_only, _i.state.editor_only)
	_i.class_names = init_class_names(_class_names, _i.class_names)
	_i.name = _init_name(_i.state.local, _id)
	_i.id = _init_id(_i.state.local, _id)
	_i.path = _init_path(_path, _i.path)
	_enable(true)


# public inherited methods
func is_class(_class = ""):
	var has_class_name = false
	for c in _i.class_names:
		has_class_name = c == _class
		if has_class_name:
			break
	return has_class_name


func get_class():
	return _i.class_names[0]


# public methods
func init_class_names(_class_names = [], _init_class_names = []):
	if _class_names.size() > 0 && _init_class_names.size() > 0:
		var amt = 0
		var idx = 0
		var inval_idx = PoolIntArray()
		inval_idx.clear()
		for c in _class_names:
			for i in _init_class_names:
				if c == i:
					var tmp = PoolIntArray(inval_idx)
					amt = amt + 1
					tmp.resize(amt)
					tmp.set(0, idx)
					inval_idx = PoolIntArray(tmp)
			idx = idx + 1
		if inval_idx.size() > 0:
			for i in inval_idx:
				var tmp = PoolStringArray(_class_names)
				tmp.remove(i)
				_class_names = PoolStringArray(tmp)
		if _class_names.size() > 0:
			var tmp = PoolStringArray()
			tmp.clear()
			amt = _init_class_names.size() + amt
			tmp.resize(amt)
			idx = 0
			for c in _class_names:
				tmp.set(idx, c)
				idx = idx + 1
			for i in _init_class_names:
				tmp.set(idx, i)
				idx = idx + 1
			_init_class_names.clear()
			amt = tmp.size()
			_init_class_names.resize(amt)
			_init_class_names = PoolStringArray(tmp)
	return _init_class_names


func init_local_param(_local = true, _id = 0):
	var local_param = false
	var id_local = _id > 0
	var is_local = _local && id_local
	var is_local_dif = _dif(id_local, _local)
	var on_local = is_local or is_local_dif
	var id_not_local = _id == 0
	var is_not_local = _dif(id_not_local, _local)
	var is_not_local_dif = _local && id_not_local
	var not_on_local = is_not_local or is_not_local_dif
	if on_local:
		local_param = not local_param
	elif not_on_local:
		local_param = local_param
	return local_param


func init_path_param(_path = "", _init_path = ""):
	var path_ret = ""
	var path_valid = path_is_valid(_path)
	var init_path_valid = path_is_valid(_init_path)
	var path_is_init = _path == _init_path
	var is_path = _dif(path_valid, path_is_init)
	var is_init_path = _dif(init_path_valid, path_valid)
	if is_path:
		path_ret = _path
	elif is_init_path:
		path_ret = _init_path
	return path_ret


func str_is_valid(_name = ""):
	return not _name == "" && not _name == null


func item_is_valid(_item = null):
	return not _item == null


func path_is_valid(_path = ""):
	return Directory.new().file_exists(_path)


func id_is_valid(_id = 0):
	return _id > 0


func enable():
	return _enable(true)


func disable():
	return _enable(false)


func validate(_enabled = true):
	return _is_enabled_managed() if _enabled else _is_disabled_unmanaged()


# private helper methods
func _has_parent_class():
	return _i.class_names.size() > 1


func _init_local(_local = true, _init_local = true, _id = 0):
	var is_local = init_local_param(_local, _id)
	if not is_local == _init_local:
		_init_local = local
	self.resource_local_to_scene = _init_local
	return _init_local


func _init_editor_only(_editor_only = false, _init_editor_only = false):
	if not _editor_only == _init_editor_only:
		_init_editor_only = _editor_only
	return _init_editor_only


func _init_name(_init_local = true, _id = 0):
	var _name = _i.class_names[0]
	if _init_local && _id > 0:
		_name = _name + String(_id)
	self.resource_name = _name
	return _name


func _init_id(_init_local = true, _id = 0):
	var init_id = 0
	if _init_local && _id > 0:
		init_id = _id
	return init_id


func _init_path(_path = "", _init_path = ""):
	var path_ret = init_path_param(_path, _init_path)
	if not path_is_valid(path_ret):
		path_ret = _i.base_path
	self.resource_path = path_ret
	return path_ret


func _enable(_abled = true):
	var is_enable = _abled && _is_disabled_unmanaged()
	var is_disable = _dif(_is_enabled_managed(), _abled)
	var is_abled = is_enable or is_disable
	if is_abled:
		_i.state.enabled = _abled
		_i.state.managed = _abled
	return is_abled


func _is_enabled_managed():
	return _i.state.managed && _i.state.enabled


func _is_disabled_unmanaged():
	return not _i.state.managed && not _i.state.enabled


func _dif(_fmr = false, _ltr = false):
	return _fmr && not _ltr


# setters, getters functions
func get_enabled():
	return _i.state.enabled


func get_has_parent_class():
	return _has_parent_class()


func get_has_id():
	return _i.id > 0


func get_has_name():
	return str_is_valid(_i.name)


func get_has_path():
	return path_is_valid(_i.path)


func get_name():
	return _i.name


func get_path():
	return _i.path


func get_editor_only():
	return _i.state.editor_only


func get_local():
	return _i.state.local


func get_parent_class():
	var _parent_class = ""
	if _has_parent_class():
		_parent_class = _i.class_names[1]
	return _parent_class


func get_id():
	return _i.id


# public callbacks
func awake():
	pass


func on_enable():
	pass


func on_disable():
	pass


func enter_tree():
	pass


func exit_tree():
	pass


func ready():
	pass


func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


func input(_event: InputEvent):
	pass


func unhandled_input(_event: InputEvent):
	pass


func unhandled_key_input(_event: InputEvent):
	pass
