extends Node
class_name ComponentBase

#warning-ignore-all: unused_signal
signal initialized_id(id, init_id)
signal initialized(init)
signal enabled(enable)
signal destroyed()

var _meta_data = preload("component_meta_data.gd")
var init_conditions = [ NOTIFICATION_ENTER_TREE, NOTIFICATION_MOVED_IN_PARENT, 
    NOTIFICATION_READY, NOTIFICATION_UNPAUSED, NOTIFICATION_PHYSICS_PROCESS, 
    NOTIFICATION_PROCESS, NOTIFICATION_PARENTED, NOTIFICATION_INSTANCED, 
    NOTIFICATION_POST_ENTER_TREE ]

func _init():
    _meta_data.resource_local_to_scene = true
    _on_init();

func _notification(what):
    for cond in init_conditions:
        if cond == what:
            _on_init()

func _on_init():
    if not _meta_data.enabled:
        if not _meta_data.initialized:
            if not _meta_data.initialized_id:
                _on_init_emit("initialized_id", "_init_id", get_instance_id())
            else:
                _on_init_emit("initialized", "_init_self")
        else:
            _on_init_emit("enabled", "_enable")

func _on_init_emit(_signal: String, method: String, id = null):
    var has_id = id != null
    var args = []
    var emit = not self.is_connected(_signal, self, method)
    if has_id:
        args.append(id)
    args.append(emit)
    if emit && self.connect(_signal, self, method, args):
        if has_id:
            emit_signal(_signal, id, emit)
        else:
            emit_signal(_signal, emit)

func _init_id(id: int, init_id: bool):
    _meta_data.id = id    
    _meta_data.initialized_id = init_id
    
func _init_self(init: bool):
    _meta_data.initialized = init

func _enable(enable: bool):
    _meta_data.enabled = enable

