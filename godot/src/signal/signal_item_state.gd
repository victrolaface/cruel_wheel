tool
class_name SignalItemState extends Resource

export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_name setget set_has_name, get_has_name
export(bool) var has_args setget set_has_args, get_has_args
export(bool) var has_flags setget set_has_flags, get_has_flags
export(bool) var initialized setget set_initialized, get_initialized

var exist: bool
var connect:bool
var method: bool
var name: bool
var args: bool
var flags: bool
var init: bool

func _init():
    exist = false
    connect = false
    method = false
    name = false
    args = false
    flags = false
    init = false
    resource_local_to_scene = true

# setters, getters methods
func set_exists(_exists:bool): 
    exist = _exists

func get_exists():
    return exist

func set_connected(_connected:bool): 
    connect = _connected

func get_connected():
    return connect

func set_has_method(_has_method:bool):
    method = _has_method
    
func get_has_method():
    return method

func set_has_name(_has_name:bool):
    name = _has_name

func get_has_name():
    return name

func set_has_args(_has_args:bool):
    args = _has_args

func get_has_args():
    return args

func set_has_flags(_has_flags:bool):
    flags = _has_flags

func get_has_flags():
    return flags

func set_initialized(_initialized:bool):
    init = _initialized

func get_initialized():
    return init