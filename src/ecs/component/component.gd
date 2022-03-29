extends Node
class_name Component

#warning-ignore-all: unused_signal
signal initialized()
signal connected()
signal activated()

var _data = {}

func _init():
    _data = {
        'id': null,
        'parent': null,
        'parent_id': null,
        'initialized': false,
        'connected': false,
        'active': false,
    }
    _on_init();

func _on_init():
    if not _data.initialized:
        var id = get_instance_id()
        if id != null:
            if _data.id == null || _data.id != id:
                _data.id = id
        var parent_cached = get_parent()
        var parent_cached_id = parent_cached.get_instance_id()
        if parent_cached != null:
            if _data.parent == null:
                _data.parent = parent_cached
            if _data.parent_id == null || _data.parent_id != parent_cached_id:
                _data.parent_id = parent_cached_id
        _connect_signal("initialized", "_initialize", _data.id != null && _data.parent != null && _data.parent_id != null)
    _connect_signal("connected", "_connect", !_data.connected)
    _connect_signal("activated", "_activate", !_data.active && _data.connected)

func _connect_signal(_signal: String, method, _connect: bool):
    if not self.is_connected(_signal, self, method) && _connect:
        if self.connect(_signal, self, method):
            emit_signal(_signal)

func _initialize():
    _data.initialized = _signal(_data.initialized)

func _connect():
    _data.connected = _signal(_data.connected)

func _activate():
    _data.activated = _signal(_data.activated)

func _signal(signaled: bool):
    var do = false
    if not signaled:
        do = true
    return do

#func _notification(what):
#    match what:
#        NOTIFICATION_PARENTED:
            #parent_cache = get_parent()
            #if _can_connect() && _initialized:
                #var args = [_id]
                #parent_cache.connect("connected_to_child", self, "_on_connected_to_parent", args, )


