extends Resource
class_name ComponentMetaData

enum BaseComponentSignalType { ENABLE, DISABLE, DESTROY, INITIALIZE }

export(int) var id
export(bool) var is_local
export(bool) var has_id
export(bool) var initialized
export(bool) var enabled
export(bool) var destroyed
export(bool) var enable_connected
export(bool) var disable_connected
export(bool) var destroy_connected
export(bool) var initialize_connected
export(BaseComponentSignalType) var signal_types 

func _init(_id = null, _is_local = true, _has_id = false, _initialized = false, _enabled = false, 
    _destroyed = false, _enable_connected = false, _disable_connected = false, 
    _destroy_connected = false, _initialize_connected = false):
    id = _id
    is_local = _is_local
    has_id = _has_id
    initialized = _initialized
    enabled = _enabled
    destroyed = _destroyed
    enable_connected = _enable_connected
    disable_connected = _disable_connected
    destroy_connected = _destroy_connected
    initialize_connected = _initialize_connected
    