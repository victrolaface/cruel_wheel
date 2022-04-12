tool
class_name SignalManagerData extends Data

# data
export(Dictionary) var db setget set_db, get_db
export(Resource) var self_oneshot setget set_self_oneshot, get_self_oneshot
export(Resource) var self_deferred setget set_self_deferred, get_self_deferred
export(Resource) var nonself_oneshot setget set_nonself_oneshot, get_nonself_oneshot
export(Resource) var nonself_deferred setget set_nonself_deferred, get_nonself_deferred

# state
export(bool) var has_self_oneshot setget set_has_self_oneshot, get_has_self_oneshot
export(bool) var has_self_deferred setget set_has_self_deferred, get_has_self_deferred
export(bool) var has_nonself_oneshot setget set_has_nonself_oneshot, get_has_nonself_oneshot
export(bool) var has_nonself_deferred setget set_has_nonself_deferred, get_has_nonself_deferred
export(bool) var initialized_self_oneshot setget set_initialized_self_oneshot, get_initialized_self_oneshot
export(bool) var initialized_self_deferred setget set_initialized_self_deferred, get_initialized_self_deferred
export(bool) var initialized_nonself_oneshot setget set_initialized_nonself_oneshot, get_initialized_nonself_oneshot
export(bool) var initialized_nonself_deferred setget set_initialized_nonself_deferred, get_initialized_nonself_deferred

#var state: SignalManagerState

func _init():
    self_oneshot = null
    self_deferred = null
    nonself_oneshot = null
    nonself_deferred = null
    db = {
        "self": {
            "oneshot": self_oneshot,
            "deferred": self_deferred
        },
        "nonself": {
            "oneshot": nonself_oneshot,
            "deferred": nonself_deferred
        }
    }
    state = SignalManagerState.new()

# setters, getters functions
func set_db(_db:Object):
    pass

func get_db():
    return db

func set_self_oneshot(_self_oneshot:ResourceCollection):
    pass

func get_self_oneshot():
    return self_oneshot

func set_self_deferred(_self_deferred:ResourceCollection):
    pass

func get_self_deferred():
    return self_deferred

func set_nonself_oneshot(_nonself_oneshot:ResourceCollection):
    pass

func get_nonself_oneshot():
    return nonself_oneshot

func set_nonself_deferred(_nonself_deferred:ResourceCollection):
    pass

func get_nonself_deferred():
    return nonself_deferred

func set_has_self_oneshot(_has_self_oneshot:bool):
    pass
    
func get_has_self_oneshot():
    return self_oneshot != null && state.initialized_self_oneshot && state.has_self_oneshot
    
func set_has_self_deferred(_has_self_deferred:bool):
    pass

func get_has_self_deferred():
    return self_deferred != null && state.initialized_self_deferred && state.has_self_deferred
    
func set_has_nonself_oneshot(_has_nonself_oneshot:bool):
    pass

func get_has_nonself_oneshot():
    return nonself_oneshot != null && state.initialized_nonself_oneshot && state.has_nonself_oneshot
    
func set_has_nonself_deferred(_has_nonself_deferred:bool):
    pass

func get_has_nonself_deferred():
    return nonself_deferred != null && state.initialized_nonself_deferred && state.has_nonself_deferred

func set_initialized_self_oneshot(_initialized_self_oneshot:bool):
    pass

func get_initialized_self_oneshot():
    return state.initialized_self_oneshot

func set_initialized_self_deferred(_initialized_self_deferred:bool):
    pass
func get_initialized_self_deferred():
    return state.initialized_self_deferred

func set_initialized_nonself_oneshot(_initialized_nonself_oneshot:bool):
    pass

func get_initialized_nonself_oneshot():
    return state.initialized_nonself_oneshot

func set_initialized_nonself_deferred(_initialized_nonself_deferred:bool):
    pass

func get_initialized_nonself_deferred():
    return state.initialized_nonself_deferred
