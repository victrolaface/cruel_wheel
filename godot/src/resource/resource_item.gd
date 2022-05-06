tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var local setget , get_local
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var saved setget , get_saved
export(int) var id setget , get_id
export(String) var name setget , get_name
export(String) var path setget , get_path

# fields
var _util = ResourceItemUtility
var _str_util = StringUtility
var _path_util = PathUtility
var _arr_util = PoolArrayUtility

var _i = {
	"name": "",
	"id": 0,
	"path": "res://src/resource/resource_item.gd",
	"class_item_name": "ResourceItem",
	"class_names": PoolStringArray(),
	"paths": PoolStringArray(),
	"state":
	{
		"local": true,
		"saved": false,
		"enabled": false,
	}
}


# private inherited methods
func _init(_paths = [], _class_names = [], _local = true, _id = 0, _editor_only = false):
	var rid = get_rid()
	resource_local_to_scene = _local
	_i.paths = _util.init_paths_param(_paths, _i.path)
	_i.class_names = _util.init_class_names_param(_class_names, _i.class_item_name)
	_i.state.local = _util.init_local_param(_local, _id, resource_local_to_scene)
	_i.id = _util.init_id_param(_local, _id, resource_local_to_scene)
	_i.name = _util.init_name_param(_local, _id, resource_local_to_scene, rid, _class_names, _i.class_item_name)
	resource_name = _i.name if _str_util.is_valid(_i.name) else _i.class_item_name + "-" + String(rid)
	resource_path = _i.paths[0] if not _has_path_only() else _i.path
	if _util.can_enable(_i.paths, _i.class_names, _i.state.local, _i.id, _i.name):
		enable()


# public inherited methods
func is_class(_class = ""):
	var has_class_name = false
	if self.enabled && _str_util.is_valid(_class):
		for c in _i.class_names:
			has_class_name = c == _class
			if has_class_name:
				break
		if not has_class_name:
			has_class_name = _class == "Resource"
	return has_class_name


func get_class():
	var ret_class_name = _state_on_enabled(_has_class_name()) && not _state_on_enabled(_has_class_names())
	return _str_on_enabled(_i.class_item_name) if ret_class_name else _str_on_enabled(_i.class_names[0])


# public methods
func enable():
	return _enable(true)


func disable():
	return _enable(false)


# setters, getters functions
func get_enabled():
	return _state_on_enabled(_i.state.enabled)


func get_saved():
	return _state_on_enabled(_i.state.saved)


func get_has_id():
	return _state_on_enabled(_util.id_is_valid(_i.id))


func get_has_name():
	return _state_on_enabled(_str_util.is_valid(_i.name))


func get_local():
	return _state_on_enabled(_i.state.local)


func get_has_path():
	return _state_on_enabled(_has_path()) if not _state_on_enabled(_has_paths()) else false


func get_name():
	return _str_on_enabled(_i.name)


func get_path():
	var ret_path_only = _state_on_enabled(_has_path_only())
	return _str_on_enabled(_i.path) if ret_path_only else _str_on_enabled(_i.paths[0])


func get_id():
	var _id = 0
	if self.enabled:
		_id = _i.id
	return _id


# private helper methods
func _enable(_do_enable = true):
	var is_enabled_or_disabled = false
	if _do_enable && not _i.state.enabled:
		_i.state.enabled = _do_enable
		is_enabled_or_disabled = _i.state.enabled
	elif not _do_enable && _i.state.enabled:
		_i.state.enabled = _do_enable
		is_enabled_or_disabled = not _i.state.enabled
	return is_enabled_or_disabled


func _state_on_enabled(_state = false):
	var state = false
	if self.enabled:
		state = _state
	return state


func _str_on_enabled(_str = ""):
	var _string = ""
	if self.enabled:
		_string = _str
	return _string


func _has_class_names():
	return _arr_util.has_items(_i.class_names)


func _has_paths():
	return _arr_util.has_items(_i.paths)


func _has_class_name():
	return _str_util.is_valid(_i.class_item_name)


func _has_path():
	return _path_util.is_valid(_i.path)


func _has_path_only():
	return _has_path() && not _has_paths()


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

#func item_is_valid(_item = null):
#	var valid = false
#	var item_class_name = _item.get_class()
#	if not _item == null && _item.enabled && _str_util.str_is_valid(item_class_name) && _item.is_class(self.get_class()):
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
