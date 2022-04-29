tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled

# fields
var _i = {
	"class_names": PoolStringArray(["Resource", "ResourceItem"]),
	"path": "res://src/resource/resource_item.gd",
	"state":
	{
		"editor_only": false,
		"enabled": false,
	}
}


# private inherited methods
func _init(_local = true, _editor_only = false, _class_names = []):
	init_resource(_local, self.resource_local_to_scene, _i.class_names[1], self.resource_name, _i.path, self.resource_path)
	_i.class_names = ClassNameUtility.class_names(_class_names, _i.class_names)
	_i.state.editor_only = _editor_only
	_i.state.enabled = _is_enabled(_i.class_names)


# public inherited methods
func is_class(_class):
	return ClassNameUtility.is_class_name(_class, _i.class_names)


func get_class():
	return self.resource_name


# public methods
func init_resource(_local = true, _r_local = true, _name = "", _r_name = "", _path = "", _r_path = ""):
	var init_res_local = self.resource_local_to_scene
	var init_res_name = self.resource_local_to_scene
	var init_res_path = self.resource_local_to_scene
	var dif = false
	self.resource_local_to_scene = ResourceItemUtility.local_to_scene(_local, _r_local)
	self.resource_name = ResourceItemUtility.name(_name, _r_name)
	self.resource_path = ResourceItemUtility.path(_path, _r_path, self.resource_name)
	var local_dif = not init_res_local == self.resource_local_to_scene
	var name_dif = not init_res_name == self.resource_name
	var path_dif = not init_res_path == self.resource_path
	var name_path_dif = name_dif && path_dif
	dif = local_dif or name_path_dif
	return dif


func enable():
	return _enable(true)


func disable():
	return not _enable(false)


func validate(_enabled = true):
	return _i.state.managed == _enabled && _i.state.enabled == _enabled


# private helper methods
func _enable(_enabled = true):
	_i.state.managed = _enabled
	_i.state.enabled = _enabled
	return _i.state.enabled


func _is_enabled(_class_names = []):
	return _class_names.size() > 1


# setters, getters functions
func get_enabled():
	return _i.state.enabled


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
