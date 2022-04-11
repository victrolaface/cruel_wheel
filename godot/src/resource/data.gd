tool
class_name Data extends Resource

export(int) var id setget set_id, get_id
export(String) var name setget set_name, get_name
export(bool) var local setget set_local, get_local
export(bool) var has_id setget set_has_id, get_has_id
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var initialized setget set_initialized, get_initialized

var state: State
var util = preload("res://src/util/resource/resource_validation_util.gd")

func _init():
    id = 0
    name = ""
    state = State.new()
    resource_local_to_scene = true

# setters, getters functions
func set_id(_id:int):
    if util.is_valid(state.has_id, _id, 0):
        id = _id
        state.has_id = true

func get_id():
    return id

func set_name(_name:String):
    if util.is_valid(state.has_name, name, ""):
        name = _name
        state.has_name = true
    
func get_name():
    return name

func set_local(_local:bool):
    state.local = util.is_local_valid(_local, resource_local_to_scene)
    
func get_local():
    return state.local

func set_has_name(_has_name:bool):
    pass
    
func get_has_name():
    return state.has_name

func set_has_id(_has_id:bool):
    pass

func get_has_id():
    return state.has_id

func set_initialized(_initialized:bool):
    state.initialized = _initialized

func get_initialized():
    return state.initialized

func set_enabled(_enabled:bool):
    state.enabled = _enabled

func get_enabled():
    return state.enabled