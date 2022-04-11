tool
class_name SignalItemData extends Data

enum SignalItemType {
	SELF_ONESHOT = 0,
	SELF_DEFERRED = 1,
	NONSELF_ONESHOT = 2,
	NONSELF_DEFERRED = 3
}

# data
export(Resource) var object_from setget set_object_from, get_object_from
export(Resource) var object_to setget set_object_to, get_object_to
export(String) var method setget set_method, get_method
export(Array) var arguments setget set_arguments, get_arguments
export(int) var connection_flags setget set_connection_flags, get_connection_flags
export(SignalItemType) var type setget set_type, get_type

# state
export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_arguments setget set_has_arguments, get_has_arguments
export(bool) var has_connection_flags setget set_has_connection_flags, get_has_connection_flags

var obj_from: Object
var obj_to: Object
var args: Array
var flags: int

func _init():
    obj_from = null
    obj_to = null
    method = ""
    args = []
    flags= CONNECT_DEFERRED
    type = SignalItemType.SELF_DEFERRED
    state = SignalItemState.new()

# setters, getters functions
func set_object_from(_object_from: Object):
    obj_from = _object_from

func get_object_from():
    return obj_from

func set_object_to(_object_to: Object):
    obj_to = _object_to

func get_object_to():
    return obj_to

func set_method(_method:String):
    method = _method

func get_method():
    return method

func set_arguments(_arguments:Array):
    args = _arguments
    
func get_arguments():
    return args

func set_connection_flags(_connection_flags: int):
    flags = _connection_flags

func get_connection_flags():
    return flags

func set_type(_type: int):
    type = _type

func get_type():
    return type

func set_exists(_exists:bool):
    state.exists = _exists

func get_exists():
    return state.exists

func set_connected(_connected:bool):
    state.connected = _connected

func get_connected():
    return state.connected

func set_has_method(_has_method:bool):
    state.has_method = _has_method

func get_has_method():
    return state.has_method

func set_has_arguments(_has_arguments:bool):
    state.has_arguments = _has_arguments

func get_has_arguments():
    return state.has_arguments

func set_has_connection_flags(_has_connection_flags:bool):
    state.has_connection_flags = _has_connection_flags

func get_has_connection_flags():
    return state.has_connection_flags
