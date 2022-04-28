tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var has_self_ref setget , get_has_self_ref
export(bool) var has_base_class_names setget , get_has_base_class_names
export(bool) var is_local_to_scene setget set_is_local_to_scene, get_is_local_to_scene
export(Resource) var self_ref setget set_self_ref, get_self_ref
export(String) var base_class_name setget set_base_class_name, get_base_class_name
export(Array, String) var base_class_names setget set_base_class_names, get_base_class_names

# fields
var _data = {
	"base_class_names": PoolStringArray(["ResourceItem", "Resource"]),
	"self_ref": null,
	"state":
	{
		"enabled": false,
		"is_local": false,
		"has_self_ref": false,
		"has_base_class_names": false,
	}
}


# private inherited methods
func _init(_self_ref = null):
	_data = ResourceUtility.init_default(_self_ref, _data)


# private helper methods
func _on_init_from_manager(_db_ref = null, _manager = null, _self_ref = null):
	_data = ResourceUtility.init_from_manager(_db_ref, _manager, _self_ref, _data)
	return _data.state.enabled


func _on_set_base_class_names(_class_names = []):
	_data.base_class_names = ClassNameUtility.init_base_class_names(_class_names, _data.base_class_names)


# public inherited methods
func is_class(_class):
	return ClassNameUtility.is_class_name(_class, _data.base_class_names)


func get_class():
	return _data.name


# public methods
func init_from_manager(_db_ref = null, _manager = null, _self_ref = null):
	return _on_init_from_manager(_db_ref, _manager, _self_ref)


func enable_from_manager(_db_ref = null, _manager = null, _self_ref = null):
	return _on_init_from_manager(_db_ref, _manager, _self_ref)


func validate():
	return ResourceUtility.data_is_valid(_data)


func disable():
	_data = ResourceUtility.disable_data(_data)
	return not _data.state.enabled


# setters, getters functions
func set_self_ref(_self_ref = null):
	if not _data.state.has_self_ref && ResourceUtility.obj_is_valid(_self_ref):
		_data.self_ref = _self_ref


func get_self_ref():
	return _data.self_ref


func set_base_class_name(_class_name = ""):
	_on_set_base_class_names([_class_name])


func get_base_class_name():
	var last_idx = _data.base_class_names.size() - 1
	return _data.base_class_names[last_idx]


func set_base_class_names(_class_names = []):
	_on_set_base_class_names(_class_names)


func get_base_class_names():
	var class_names = []
	for n in _data.base_class_names:
		class_names.append(n)
	return class_names


func get_enabled():
	return _data.state.enabled


func get_has_self_ref():
	return _data.state.has_self_ref


func get_has_base_class_names():
	return _data.state.has_base_class_names


func get_is_local_to_scene():
	return _data.state.is_local


func set_is_local_to_scene(_is_local = true):
	resource_local_to_scene = _is_local
	_data.state.is_local = _is_local


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
