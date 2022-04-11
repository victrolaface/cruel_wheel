tool
class_name SignalItem extends Item

# data
export(Resource) var object_from setget set_object_from, get_object_from
export(Resource) var object_to setget set_object_to, get_object_to
export(String) var method setget set_method, get_method
export(Array) var arguments setget set_arguments, get_arguments
export(int) var connection_flags setget set_connection_flags, get_connection_flags
export(int) var type setget set_type, get_type

# state
"""
export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var has_arguments setget set_has_arguments, get_has_arguments
export(bool) var has_connection_flags setget set_has_connection_flags, get_has_connection_flags
"""

# var data:SignalItemData

func _init():
	data = SignalItemData.new()

# setters, getters functions
func set_object_from(_obj_from:Object):
	data.object_from = _obj_from

func get_object_from():
	return data.object_from

func set_object_to(_obj_to:Object):
	data.object_to = _obj_to

func get_object_to():
	return data.object_to

func set_method(_method:String):
	data.method = _method

func get_method():
	return data.method

func set_arguments(_arguments:Array):
	data.arguments = _arguments

func get_arguments():
	return data.arguments

func set_connection_flags(_connection_flags:int):
	data.connection_flags = _connection_flags

func get_connection_flags():
	return data.connection_flags

func set_type(_type: int):
	data.type = _type

func get_type():
	return data.type

"""
export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var has_arguments setget set_has_arguments, get_has_arguments
export(bool) var has_connection_flags setget set_has_connection_flags, get_has_connection_flags
"""
func set_exists(_exists:bool):
	data.exists = _exists

#func get_exists():
#func _init():
	#is_connected = false
	#obj_from = null
	#name = ""
	#obj_to = null
	#method = ""
	#args = []
	#flags = CONNECT_DEFERRED
	#item_type = SignalItemType.SELF_DEFERRED
	#resource_local_to_scene = true

# setters, getters functions
"""
func set_connected(_connected:bool):
	pass

func get_connected():
	return is_connected

func set_object_from(_obj_from: Resource):
	pass

func get_object_from():
	return obj_from

func set_name(_name:String):
	pass

func get_name():
	return signal_name

func set_object_to(_obj_to:Resource):
	pass

func get_object_to():
	return obj_to

func set_method(_method:String):
	pass

func get_method():
	return signal_method

func set_arguments(_args:Array):
	pass

func get_arguments():
	return args

func set_connection_flags(_flags:int):
	pass

func get_connection_flags():
	return flags

func set_type(_type:int):
	pass

func get_type():
	return item_type
"""