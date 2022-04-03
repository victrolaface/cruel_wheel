extends Resource
class_name BaseComponent

#warning-ignore-all:unused_signal
signal enabled(id)
signal disabled(id)
signal initialized(id)
signal destroyed(id)

export(Resource) var meta_data = preload("component_meta_data.gd")

func _init():
    _setup_local_to_scene()
    if not meta_data.initialized:    
        if not meta_data.has_id:
            if not meta_data.is_local:
                meta_data.id = get_rid()
            else:
                meta_data.id = get_instance_id()
            meta_data.has_id = meta_data.id != null
            if meta_data.has_id:
                emit_changed()
        else:
            var dirty = false
            for signal_type in meta_data.signal_types:
                var is_oneshot = signal_type == "DESTROY" || signal_type == "INITIALIZE"
                match signal_type:
                    "ENABLE":
                        meta_data.enabled_connected = _connected(meta_data.enabled_connected, is_oneshot, "enabled", "enable")
                        dirty = not meta_data.enabled_connected
                    "DISABLE":
                        meta_data.disabled_connected = _connected(meta_data.disabled_connected, is_oneshot, "disabled", "disable")
                        dirty = not meta_data.disabled_connected
                    "DESTROY":
                        meta_data.destroyed_connected = _connected(meta_data.destroyed_connected, is_oneshot, "destroyed", "destroy")
                        dirty = not meta_data.destroyed_connected
                    "INITIALIZE":
                        meta_data.initialized_connected = _connected(meta_data.initialized_connected, is_oneshot, "initialized", "_on_init")
                        dirty = not meta_data.initialized_connected
                if dirty:
                    break
            if not dirty:
                emit_signal("initialized", meta_data.id)
    
func _setup_local_to_scene():
    if not meta_data.is_local == resource_local_to_scene:
        resource_local_to_scene = meta_data.is_local
        emit_changed()

func _notification(what):
    match what:
        "NOTIFICATION_POST_INITIALIZE":
            _init()
        "NOTIFICATION_PREDELETE":
            destroy()

func _connected(_is_connected: bool, _is_oneshot: bool, _signal: String, _method: String):
    if not _is_connected:
        _is_connected = is_connected(_signal, self, _method)
        if not _is_connected:
            var flag = CONNECT_DEFERRED
            if _is_oneshot:
                flag = CONNECT_ONESHOT
            _is_connected = connect(_signal, self, _method, [], flag)
            if _is_connected && not _is_oneshot:
                emit_signal(_signal, meta_data.id)
    return _is_connected

func _emitted(_emit: bool, _signal: String):
    if _emit:
        emit_signal(_signal, meta_data.id)
        emit_changed()
    return _emit

func _on_init():
    meta_data.initialized = true
    emit_changed()
    
func enable():
    _init()
    meta_data.enabled = _emitted(!meta_data.enabled, "enabled")

func disable():
    meta_data.enabled = !_emitted(meta_data.enabled, "disabled")

func destroy():
    disable()
    meta_data.destroyed = _emitted(!meta_data.destroyed, "destroyed")
