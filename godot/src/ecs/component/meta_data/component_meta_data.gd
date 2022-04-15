"""
extends Resource
class_name ComponentMetaData

export(String) var name
export(int) var id
export(bool) var is_local
export(Resource) var state
export(Resource) var connected


func _init():
	name = ""
	id = 0
	is_local = true
	state = ComponentMetaStateData.new()
	connected = ComponentMetaConnectionsData.new()
	resource_local_to_scene = true
"""
