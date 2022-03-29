extends Resource

export(int) var id
export(int) var parent_id
export(bool) var initialized
export(bool) var connected
export(bool) var active 

func _init(_id = null, _parent_id = null, _initialized = false, _connected = false, _active = false):
    id = _id
    parent_id = parent_id
    initialized = _initialized
    connected = _connected
    active = _active