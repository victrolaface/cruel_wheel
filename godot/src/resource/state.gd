tool
class_name State extends Resource

export(bool) var local setget set_local, get_local
export(bool) var has_id setget set_has_id, get_has_id
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var initialized setget set_initialized, get_initialized
export(bool) var enabled setget set_enabled, get_enabled

var enable: bool
var is_init: bool
var util = preload("res://src/util/resource/resource_validation_util.gd")


func _init():
    resource_local_to_scene = true
    enable = false
    is_init = false

# setters, getters functions
func set_local(_local:bool):
    local = util.is_local_valid(_local, resource_local_to_scene)

func get_local():
    return local
    
func set_has_id(_has_id:bool):
    has_id = _has_id

func get_has_id():
    return has_id

func set_has_name(_has_name:bool):
    has_name = _has_name

func get_has_name():
    return has_name
    
func set_initialized(_initialized:bool):
    is_init = _initialized

func get_initialized():
    return is_init

func set_enabled(_enabled:bool):
    enable = _enabled

func get_enabled():
    return enable
