tool
class_name SignalManagerState extends State

export(bool) var has_self_oneshot setget set_has_self_oneshot, get_has_self_oneshot
export(bool) var has_self_deferred setget set_has_self_deferred, get_has_self_deferred
export(bool) var has_nonself_oneshot setget set_has_nonself_oneshot, get_has_nonself_oneshot
export(bool) var has_nonself_deferred setget set_has_nonself_deferred, get_has_nonself_deferred
export(bool) var initialized_self_oneshot setget set_initialized_self_oneshot, get_initialized_self_oneshot
export(bool) var initialized_self_deferred setget set_initialized_self_deferred, get_initialized_self_deferred
export(bool) var initialized_nonself_oneshot setget set_initialized_nonself_oneshot, get_initialized_nonself_oneshot
export(bool) var initialized_nonself_deferred setget set_initialized_nonself_deferred, get_initialized_nonself_deferred

var self_oneshot:bool
var self_deferred:bool
var nonself_oneshot:bool
var nonself_deferred:bool
var init_self_oneshot: bool
var init_self_deferred: bool
var init_nonself_oneshot: bool
var init_nonself_deferred: bool

func _init():
    self_oneshot = false
    self_deferred = false
    nonself_oneshot = false
    nonself_deferred = false
    init_self_oneshot = false
    init_self_deferred = false
    init_nonself_oneshot = false
    init_nonself_deferred = false
    
func set_has_self_oneshot(_has_self_oneshot:bool):
    self_oneshot = _has_self_oneshot
    
func get_has_self_oneshot():
    return init_self_oneshot && self_oneshot
    
func set_has_self_deferred(_has_self_deferred:bool):
    self_deferred = _has_self_deferred

func get_has_self_deferred():
    return init_self_deferred && self_deferred
    
func set_has_nonself_oneshot(_has_nonself_oneshot:bool):
    nonself_oneshot = _has_nonself_oneshot

func get_has_nonself_oneshot():
    return init_nonself_oneshot && nonself_oneshot
    
func set_has_nonself_deferred(_has_nonself_deferred:bool):
    nonself_deferred = _has_nonself_deferred

func get_has_nonself_deferred():
    return init_nonself_deferred && nonself_deferred

func set_initialized_self_oneshot(_initialized_self_oneshot:bool):
    init_self_oneshot = _initialized_self_oneshot

func get_initialized_self_oneshot():
    return init_self_oneshot

func set_initialized_self_deferred(_initialized_self_deferred:bool):
    init_self_deferred = _initialized_self_deferred

func get_initialized_self_deferred():
    return init_self_deferred

func set_initialized_nonself_oneshot(_initialized_nonself_oneshot:bool):
    init_nonself_oneshot = _initialized_nonself_oneshot

func get_initialized_nonself_oneshot():
    return init_nonself_oneshot

func set_initialized_nonself_deferred(_initialized_nonself_deferred:bool):
    init_nonself_deferred = _initialized_nonself_deferred

func get_initialized_nonself_deferred():
    return init_nonself_deferred
