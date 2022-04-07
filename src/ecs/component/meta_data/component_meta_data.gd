extends Resource
class_name ComponentMetaData

export(String) var name
export(int) var id
export(Resource) var state
export(Resource) var connected


func _init():
	name = null
	id = null
	state = ComponentMetaStateData.new()
	connected = ComponentMetaConnectionsData.new()
	resource_local_to_scene = true


func initialize(_name: String, _id: int, _is_local: bool):
	name = _name
	id = _id
	resource_local_to_scene = _is_local
