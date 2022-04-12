tool
class_name SignalItem extends Item

"""
# data
export(Resource) var object_from setget set_object_from, get_object_from
export(Resource) var object_to setget set_object_to, get_object_to
export(String) var method setget set_method, get_method
export(Array) var arguments setget set_arguments, get_arguments
export(int) var connection_flags setget set_connection_flags, get_connection_flags
export(int) var type setget set_type, get_type

# state
export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_arguments setget set_has_arguments, get_has_arguments
export(bool) var has_connection_flags setget set_has_connection_flags, get_has_connection_flags

#var data: SignalItemData
#var state: SignalItemState


func _init():
	data = SignalItemData.new()
	resource_local_to_scene = true
	data.local = resource_local_to_scene


# setters, getters functions
func set_object_from(_obj_from: Object):
	pass


func get_object_from():
	return data.object_from


func set_object_to(_obj_to: Object):
	pass


func get_object_to():
	return data.object_to


func set_method(_method: String):
	pass


func get_method():
	return data.method


func set_arguments(_arguments: Array):
	pass


func get_arguments():
	return data.arguments


func set_connection_flags(_connection_flags: int):
	pass


func get_connection_flags():
	return data.connection_flags


func set_type(_type: int):
	pass


func get_type():
	return data.type


func set_exists(_exists: bool):
	pass


func get_exists():
	return data.exists


func set_connected(_connected: bool):
	pass


func get_connected():
	return data.connected


func set_has_method(_has_method: bool):
	pass


func get_has_method():
	return data.has_method


func set_has_arguments(_has_arguments: bool):
	pass


func get_has_arguments():
	return data.has_arguments


func set_has_connection_flags(_has_connection_flags: bool):
	pass


func get_has_connection_flags():
	return data.has_connection_flags
"""
