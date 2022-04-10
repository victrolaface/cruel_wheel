tool
class_name SignalItem extends Resource

enum SignalItemType {
	SELF_ONESHOT = 0,
	SELF_DEFERRED = 1,
	NONSELF_ONESHOT = 2,
	NONSELF_DEFERRED = 3
}

export(bool) var connected setget set_connected, get_connected
export(Resource) var object_from setget set_object_from, get_object_from
export(String) var name setget set_name, get_name
export(Resource) var object_to setget set_object_to, get_object_to
export(String) var method setget set_method, get_method
export(Array) var arguments setget set_arguments, get_arguments
export(int) var connection_flags setget set_connection_flags, get_connection_flags
export(SignalItemType) var type setget set_type, get_type

var flags: int
var is_connected: bool
var signal_name: String
var signal_method: String
var args: Array
var obj_to: Resource
var obj_from: Resource
var item_type: int

func _init():
	is_connected = false
	obj_from = null
	name = ""
	obj_to = null
	method = ""
	args = []
	flags = CONNECT_DEFERRED
	item_type = SignalItemType.SELF_DEFERRED
	resource_local_to_scene = true

# setters, getters functions
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