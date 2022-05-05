tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var editor_only setget , get_editor_only
export(bool) var local setget , get_local
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var saved setget , get_saved
export(int) var id setget , get_id
export(String) var name setget , get_name
export(String) var path setget , get_path

# fields
var _i = {
	"name": "",
	"id": 0,
	"path": "res://src/resource/resource_item.gd",
	"class_names": PoolStringArray(["ResourceItem"]),
	"paths": PoolStringArray(),
	"state":
	{
		"editor_only": false,
		"local": true,
		"saved": false,
		"enabled": false,
	}
}


# private inherited methods
func _init(_paths = [], _class_names = [], _local = true, _id = 0, _editor_only = false):
	_i.paths = ResourceItemUtility.init_paths_param(_paths, _i.path)
	_i.class_names = ResourceItemUtility.init_class_names_param(_i.class_names, _class_names)
	_i.state.local = ResourceItemUtility.init_local_param(_local, _id)
	_i.state.editor_only = ResourceItemUtility.init_editor_only_param(_editor_only)
	# init name
	# init id
	enable()


# public inherited methods
func is_class(_class = ""):
	var has_class_name = false
	if StringUtility.str_is_valid(_class) && self.enabled:
		for c in _i.class_names:
			has_class_name = c == _class
			if has_class_name:
				break
		if not has_class_name:
			has_class_name = _class == "Resource"
	return has_class_name


func get_class():
	var cl_name = ""
	if self.enabled:
		cl_name = _i.class_names[_i.class_names.size() - 1]
	return cl_name


# public methods
func enable():
	return _able(true)


func disable():
	return _able(false)


func _able(_abled = true):
	var is_abled = (
		(_abled && not _i.state.managed && not _i.state.enabled)
		or (_i.state.managed && _i.state.enabled && not _abled)
	)
	if is_abled:
		_i.state.enabled = _abled
		_i.state.managed = _abled
	return is_abled


# setters, getters functions
func get_enabled():
	return _i.state.enabled


func get_saved():
	return _i.state.saved


func get_has_id():
	return ResourceItemUtility.id_is_valid(_i.id)


func get_has_name():
	return StringUtility.str_is_valid(_i.name)


func _has_paths():
	return _i.paths.size() > 0


func _has_path():
	return PathUtility.is_valid(_i.path)


func get_has_path():
	var has = _has_paths()
	if not has:
		has = _has_path()
	return has


func get_name():
	return _i.name


func get_path():
	var _path = ""
	if _has_paths():
		_path = _i.paths[0]
	elif _has_path():
		_path = _i.path
	return _path


func get_editor_only():
	return _i.state.editor_only


func get_local():
	return _i.state.local


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

#func init_class_names(_class_names = [], _init_class_names = []):
#	if _class_names.size() > 0 && _init_class_names.size() > 0:
#		var amt = 0
#		var idx = 0
#		var inval_idx = PoolIntArray()
#		inval_idx.clear()
#		for c in _class_names:
#			for i in _init_class_names:
#				if c == i:
#					var tmp = PoolIntArray(inval_idx)
#					amt = amt + 1
#					tmp.resize(amt)
#					tmp.set(0, idx)
#					inval_idx = PoolIntArray(tmp)
#			idx = idx + 1
#		if inval_idx.size() > 0:
#			for i in inval_idx:
#				var tmp = PoolStringArray(_class_names)
#				tmp.remove(i)
#				_class_names = PoolStringArray(tmp)
#		if _class_names.size() > 0:
#			var tmp = PoolStringArray()
#			tmp.clear()
#			amt = _init_class_names.size() + amt
#			tmp.resize(amt)
#			idx = 0
#			for c in _class_names:
#				tmp.set(idx, c)
#				idx = idx + 1
#			for i in _init_class_names:
#				tmp.set(idx, i)
#				idx = idx + 1
#			_init_class_names.clear()
#			amt = tmp.size()
#			_init_class_names.resize(amt)
#			_init_class_names = PoolStringArray(tmp)
#	return _init_class_names

#func init_local_param(_local = true, _id = 0):
#	var local_param = false
#	var id_local = id_is_valid(_id)
#	var id_not_local = not id_local
#	if (_local && id_local) or (id_local && not _local):
#		local_param = true
#	elif (id_not_local && not _local) or (_local && id_not_local):
#		local_param = false
#	return local_param

#func init_path_param(_path = "", _init_path = ""):
#	var path_ret = ""
#	var path_valid = _path_is_valid(_path)
#	if path_valid && not _path == _init_path:
#		path_ret = _path
#	elif _path_is_valid(_init_path) && path_valid:
#		path_ret = _init_path
#	return path_ret

#func item_is_valid(_item = null):
#	var valid = false
#	var item_class_name = _item.get_class()
#	if not _item == null && _item.enabled && StringUtility.str_is_valid(item_class_name) && _item.is_class(self.get_class()):
#		var name_valid = false
#		if _item.has_name:
#			var _name = item_class_name
#			if _item.local && _item.has_id:
#				_name = _name + String(_item.id)
#				name_valid = _item.name == _name
#			elif not _item.local:
#				name_valid = _item.name == item_class_name
#			if name_valid:
#				name_valid = _item.resource_name == _name
#		valid = (
#			(_item.resource_local_to_scene if _item.local else not _item.resource_local_to_scene)
#			&& _item.has_path
#			&& PathUtility.is_valid(_item.path)
#			&& _item.resource_path == _item.path
#			&& name_valid
#		)
#	return valid

#func str_is_valid(_name = ""):
#	return not _name == "" && not _name == null

#func _path_is_valid(_path = ""):
#	return Directory.new().file_exists(_path)

#func id_is_valid(_id = 0):
#	return _id > 0

#func validate(_enabled = true):
#	return _is_enabled_managed() if _enabled else _is_disabled_unmanaged()

# private helper methods
#func _init_local(_local = true, _init_local = true, _id = 0):
#	var is_local = init_local_param(_local, _id)
#	if not is_local == _init_local:
#		_init_local = local
#	self.resource_local_to_scene = _init_local
#	return _init_local

#func _init_editor_only(_editor_only = false, _init_editor_only = false):
#	if not _editor_only == _init_editor_only:
#		_init_editor_only = _editor_only
#	return _init_editor_only

#func _init_name(_init_local = true, _id = 0):
#	var _name = _i.class_names[0]
#	if _init_local && id_is_valid(_id):
#		_name = _name + String(_id)
#	self.resource_name = _name
#	return _name

#func _init_id(_init_local = true, _id = 0):
#	var init_id = 0
#	if _init_local && id_is_valid(_id):
#		init_id = _id
#	return init_id

#func _init_path(_path = "", _init_path = ""):
#	var path_ret = #init_path_param(_path, _init_path)
#	if not _path_is_valid(path_ret):
#		path_ret = _i.base_path
#	self.resource_path = path_ret
#	return path_ret
