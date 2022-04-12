"""
tool
class_name SignalItemState extends State

export(bool) var exists setget set_exists, get_exists
export(bool) var connected setget set_connected, get_connected
export(bool) var has_method setget set_has_method, get_has_method
export(bool) var has_arguments setget set_has_arguments, get_has_arguments
export(bool) var has_connection_flags setget set_has_connection_flags, get_has_connection_flags

var exist:bool
var connect:bool
var method:bool
var name:bool
var args:bool
var flags:bool

func _init():
    exist = false
    connect = false
    method = false
    name = false
    args = false
    flags = false
    
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

func set_has_arguments(_has_arguments:bool):
    args = _has_arguments

func get_has_arguments():
    return args

func set_has_connection_flags(_has_connection_flags:bool):
    flags = _has_connection_flags

func get_has_connection_flags():
    return flags
"""