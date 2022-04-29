tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled

# fields
var _i = {
	"class_names": PoolStringArray(["ResourceItem, Resource"]),
	"path": "res://src/resource/resource_item.gd",
	"state":
	{
		"editor_only": false,
		"enabled": false,
	}
}


# private inherited methods
func _init(_local = true, _path = "", _editor_only = false, _class_names = []):
	_i.class_names = ResourceItemUtility.init_class_names(_class_names, _i.class_names)
	_i.state.editor_only = ResourceItemUtility.init_editor_only(_editor_only, _i.editor_only)
	self.resource_name = _class_name()
	self.resource_local_to_scene = ResourceItemUtility.init_res_local(_local, self.resource_local_to_scene)
	self.resource_path = ResourceItemUtility.init_res_path(_path, self.resource_path, _i.path)
	_i.path = ResourceItemUtility.init_path(_path, _i.path)
	_enable(true)


# public inherited methods
func is_class(_class):
	return ClassNameUtility.is_class_name(_class, _i.class_names)


func get_class():
	return _class_name()


# public methods
func enable():
	return _enable(true)


func disable():
	return not _enable(false)


func validate(_enabled = true):
	return _i.state.managed == _enabled && _i.state.enabled == _enabled


# private helper methods
func _class_name():
	return _i.class_names[0]


func _enable(_enabled = true):
	_i.state.enabled = _enabled
	return _i.state.enabled


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
