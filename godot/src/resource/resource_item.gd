tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(String) var name setget , get_name
export(String) var path setget , get_path

# fields
var _i = {
	"name": "",
	"path": "",
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
	_i.class_names = init_class_names(_class_names, _i.class_names)
	if not _editor_only == _i.state.editor_only:
		_i.state.editor_only = _editor_only
	if not _local == _i.state.local:
		_i.state.local = _local
	self.resource_local_to_scene = _i.state.local
	_i.name = _i.class_names[0]
	if _i.state.local && _id > 0:
		_i.name = _i.name + String(_id)
	self.resource_name = _i.name
	var path_valid = _path_valid(_path)
	if path_valid && not _path == _i.path:
		_i.path = _path
	elif not path_valid && _path_valid(_i.base_path):
		_i.path = _i.base_path
	self.resource_path = _i.path
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
static func init_class_names(_class_names = [], _init_class_names = []):
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


func init_path(_path = "", _init_path = ""):
	var path_valid = _path_valid(_path)
	var init_path_valid = _path_valid(_init_path)
	return _path if _dif(path_valid, init_path_valid) else _init_path


func enable():
	return _enable(true)


func disable():
	return _enable(false)


func validate(_enabled = true):
	return _is_enabled_managed() if _enabled else _is_disabled_unmanaged()


# private helper methods
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


func _path_valid(_path):
	return PathUtility.is_valid(_path)


func _dif(_fmr = false, _ltr = false):
	return _fmr && not _ltr


# setters, getters functions
func get_enabled():
	return _i.state.enabled


func get_name():
	return _i.name


func get_path():
	return _i.path


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
