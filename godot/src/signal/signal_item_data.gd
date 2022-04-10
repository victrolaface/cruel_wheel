tool
class_name SignalItemData extends Resource

enum SignalItemType {
	SELF_ONESHOT = 0,
	SELF_DEFERRED = 1,
	NONSELF_ONESHOT = 2,
	NONSELF_DEFERRED = 3
}

export(String) var name setget set_name, get_name
export(Resource) var object_from setget set_object_from, get_object_from
export(Resource) var object_to setget set_object_to, get_object_to
export(String) var method setget set_method, get_method
export(Array) var arguments setget set_arguments, get_arguments
export(int) var connection_flags setget set_connection_flags, get_connection_flags
export(SignalItemType) var type setget set_type, get_type
export(Resource) var state setget set_state, get_state

var obj_from: Object
var obj_to: Object
var args: Array
var flags: int

func _init():
    name = ""
    obj_from = null
    obj_to = null
    method = ""
    args = []
    flags= CONNECT_DEFERRED
    type = SignalItemType.SELF_DEFERRED
    state = SignalItemState.new()
    resource_local_to_scene = true

# setters, getters functions
func set_name(_name:String):
    pass

func get_name():
    return name

func set_object_from(_object_from: Object):
    pass

func get_object_from():
    return obj_from

func set_object_to(_object_to: Object):
    pass

func get_object_to():
    return obj_to

func set_method(_method:String):
    pass

func get_method():
    return method

func set_arguments(_arguments:Array):
    pass

func get_arguments():
    return args

func set_connection_flags(_connection_flags: int):
    pass

func get_connection_flags():
    return flags

func set_type(_type: int):
    pass

func get_type():
    return type

func set_state(_state: SignalItemState):
    pass

func get_state():
    return state