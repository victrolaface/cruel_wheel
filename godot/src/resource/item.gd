tool
class_name Item extends Resource

export(int) var id setget set_id, get_id
export(String) var name setget set_name, get_name
export(bool) var local setget set_local, get_local
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled

var data:Data
var util = preload("res://src/util/resource/resource_validation_util.gd")

func _init():
    resource_local_to_scene = true
    data = Data.new()

# setters, getters functions
func set_id(_id:int):
    if util.is_valid(data.has_id, _id, 0):
        data.id = _id

func get_id():
    return data.id

func set_name(_name:String):
    if util.is_valid(data.has_name, _name, ""):
        data.name = _name

func get_name():
    return data.name

func set_local(_local:bool):
    data.local = util.is_local_valid(_local, resource_local_to_scene)

func get_local():
    return data.local

func set_initialized(_initialized:bool):
    data.initialized = _initialized

func get_initialized():
    return data.initialized

func set_enabled(_enabled:bool):
    data.enabled = _enabled

func get_enabled():
    return data.enabled
