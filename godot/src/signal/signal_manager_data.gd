tool
class_name SignalManagerData extends Data

export(Dictionary) var db setget set_db, get_db
export(Resource) var self_oneshot setget set_self_oneshot, get_self_oneshot
export(Resource) var self_deferred setget set_self_deferred, get_self_deferred
export(Resource) var nonself_oneshot setget set_nonself_oneshot, get_nonself_oneshot
export(Resource) var nonself_deferred setget set_nonself_deferred, get_nonself_deferred

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