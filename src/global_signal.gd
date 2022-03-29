extends Node

var _init = false
var _timer = null
var _emit_queue = []
var _emitters = {}
var _listeners = {}
var _emitters_remove_queue = []
var _listeners_remove_queue = []
var _destroyed = 0

func _process(_delta):
    if not _init:
        init()
    set_process(false)
    set_physics_process(false)

func init():
    for emitted_signal in _emit_queue: # process emit queue
        emitted_signal.args.push_front(emitted_signal.signal_name)
        emitted_signal.emitter.callv('emit_signal', emitted_signal.args)
    _emit_queue.clear()

    _listeners.clear()
    _emitters_remove_queue.clear()
    _listeners_remove_queue.clear()
    
    _timer = Timer.new() # timer polls signals to destroy
    add_child(_timer)
    _timer.connect("timeout", self, "remove_signals")
    _timer.set_wait_time(1.0)
    _timer.set_one_shot(false)
    _timer.start()

    _init = true # initialized

func emit_signal_on_ready(signal_name: String, args: Array, emitter: Object):
    if not _emitters.has(signal_name):
        push_error('GlobalSignal.emit_signal_on_ready: Signal is not registered with GlobalSignal (' + signal_name + ').')
        return
    if not _init:
        _emit_queue.push_back({ 'signal_name': signal_name, 'args': args, 'emitter': emitter})
    else:
        args.push_front(signal_name)
        emitter.callv('emit_signal', args)

func remove_signals():
    if _emitters_remove_queue.size() > 0:
        for id in _emitters_remove_queue:
            if _emitters.has(id):
                _emitters.erase(id)
        _emitters_remove_queue.clear()
    if _listeners_remove_queue.size() > 0:
        for id in _listeners_remove_queue:
            if _listeners.has(id):
                _listeners.erase(id)
        _listeners_remove_queue.clear()

func add_emitter(signal_name: String, emitter: Object):
    var id = emitter.get_instance_id();
    var data = { 'object': emitter, 'object_id': id }
    if not _emitters.has(signal_name):
        _emitters[signal_name] = {}
    _emitters[signal_name][id] = data
    if _listeners.has(signal_name):
        connect_to_listeners(signal_name, emitter)
    
func add_listener(signal_name: String, listener: Object, method: String):
    var id = listener.get_instance_id()
    var data = { 'object': listener, 'object_id': id, 'method': method }
    if not _listeners.has(signal_name):
        _listeners[signal_name] = {}
    _listeners[signal_name][id] = data
    if _emitters.has(signal_name):
        connect_to_emitters(signal_name, listener, method)

func connect_to_listeners(signal_name: String, emitter: Object):
    var listeners = _listeners[signal_name]
    for listener in listeners.values():
        var _connected = emitter.connect(signal_name, listener.object, listener.method)

func connect_to_emitters(signal_name: String, listener: Object, method: String):
    var emitters = _emitters[signal_name]
    for emitter in emitters.values():
        var _connected = emitter.object.connect(signal_name, listener, method)






func _connect_emitter_to_listeners(signal_name: String, emitter: Object) -> void:
  var listeners = _listeners[signal_name]
  for listener in listeners.values():
    if _process_purge(listener, listeners):
      continue
    emitter.connect(signal_name, listener.object, listener.method)


func _connect_listener_to_emitters(signal_name: String, listener: Object, method: String) -> void:
  var emitters = _emitters[signal_name]
  for emitter in emitters.values():
    if _process_purge(emitter, emitters):
      continue
    emitter.object.connect(signal_name, listener, method)












func remove_emitter(signal_name: String, emitter: Object):
    var id = emitter.get_instance_id()
    if not _emitters.has(signal_name) || not _emitters[signal_name].has(id): return
    if _listeners.has(signal_name):
        for listener in _listeners[signal_name].values():
            if emitter.is_connected(signal_name, listener.object, listener.method):
                emitter.disconnect(signal_name, listener.object, listener.method)
                if not to_remove_has(_emitters_remove_queue, id):
                    _emitters_remove_queue.append(id)

func remove_listener(signal_name: String, listener: Object, method: String):
    var id = listener.get_instance_id()
    if not _listeners.has(signal_name) || not _listeners[signal_name].has(id): return
    if _emitters.has(signal_name):
        for emitter in _emitters[signal_name].values():
            if emitter.object.is_connected(signal_name, listener, method):
                emitter.object.disconnect(signal_name, listener, method)
                if not to_remove_has(_listeners_remove_queue, id):
                    _listeners_remove_queue.append(id)

func to_remove_has(remove_queue: Array, id: int):
    var amount = remove_queue.size()
    if amount < 1:
        return false
    elif amount == 1:
        return remove_queue[0] == id
    else:
        for i in remove_queue:
            if i == id:
                return true
            else:
                continue
    return false