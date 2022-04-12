tool
class_name Data extends Resource

export(int) var parent_id setget set_parent_id, get_parent_id
export(int) var id setget set_id, get_id
export(String) var name setget set_name, get_name


func _init():
	parent_id = 0
	id = 0
	name = ""
	resource_local_to_scene = true


# setters, getters functions
func set_parent_id(_parent_id: int):
	parent_id = _parent_id


func get_parent_id():
	return parent_id


func set_id(_id: int):
	id = _id


func get_id():
	return id


func set_name(_name: String):
	name = _name


func get_name():
	return name
