extends Resource

export(int) var id
export(int) var parent_id
export(bool) var initialized_id
export(bool) var initialized
export(bool) var connected
export(bool) var connected_parent
export(bool) var active

func _init(_id = null, _parent_id = null, _initialized_id = false, _initialized = false, _connected = false, _connected_parent = false, _active = false):
    id = _id
    parent_id = parent_id
    initialized_id = _initialized_id
    initialized = _initialized
    connected = _connected
    connected_parent = _connected_parent
    active = _active