class_name Events extends Reference

signal all_tasks_finished()

class TaskGroup extends Reference:

	signal _finished(results)

	var _obj = ObjectUtility
	var _arr = PoolArrayUtility
	var _int = IntUtility

	var _data = {
		"tasks_amt": 0,
		"mutex": null,
		"task_results": _arr.init("byte")
	}

	func _init(_threaded=true):
		if _threaded:
			_mutex = Mutex.new()


	func connect(_listener=null, _method="", binds=[], _flags=0):
		var can_connect = _obj.is_valid(_listener) && _listener.has_method(_method)
		var connected = false
		if can_connect:
			connected = connect("finished", _listener, _method, binds, _flags | CONNECT_ONESHOT)
		else:
			connected = can_connect
			push_warning("object '%s' cannot call method '%s' " % [_listener, _method])
			push_warning(ERR_METHOD_NOT_FOUND)
		return connected


	func connect_deferred(_listener=null, _method="", _binds = [], _flags= 0):
		return connect(_listener,_method, _binds,_flags | CONNECT_DEFERRED)

	func add_task(_task=null):
		_task.group = self
		_task.id = _data.tasks_amt
		
		
		_data.tasks_amt = _int.incr(_data.tasks_amt)

		#_task.group = self
		#_task.id_in_group = task_count
		#_task_count += 1
		#_task_results.resize(task_count)


	func mark_task_finished(task, result) -> void:
		if mutex:
			mutex.lock()
		task_count -= 1
		task_results[task.id_in_group] = result
		var is_last_task = task_count == 0
		if mutex:
			mutex.unlock()
		if is_last_task:
			emit_signal("finished", task_results)


class Task:
	"""
	A single task to be executed.

	Connect to the `finished` signal to receive the result either manually
	or by calling `then`/`then_deferred`.
	"""
	extends Reference

	signal finished(result)

	var object: Object
	var method: String
	var args: Array
	var group: TaskGroup = null
	var id_in_group: int = -1


	func then(signal_responder: Object, method: String, binds: Array = [], flags: int = 0) -> int:
		"""
		Helper method for connecting to the `finished` signal.

		This enables the following pattern:

			dispatch_queue.dispatch(object, method).then(signal_responder, method)
		"""
		if signal_responder.has_method(method):
			return connect("finished", signal_responder, method, binds, flags | CONNECT_ONESHOT)
		else:
			push_error("Object '%s' has no method named %s" % [signal_responder, method])
			return ERR_METHOD_NOT_FOUND


	func then_deferred(signal_responder: Object, method: String, binds: Array = [], flags: int = 0) -> int:
		"""
		Helper method for connecting to the `finished` signal with deferred flag
		"""
		return then(signal_responder, method, binds, flags | CONNECT_DEFERRED)


	func execute() -> void:
		var result = object.callv(method, args)

		# Handle a thread function which is in a yielding state
		while result is GDScriptFunctionState:
			result = yield(result, "completed")

		emit_signal("finished", result)
		if group:
			group.mark_task_finished(self, result)


class _WorkerPool:
	extends Reference

	var threads = []
	var should_shutdown = false
	var mutex = Mutex.new()
	var semaphore = Semaphore.new()

	func _notification(what: int) -> void:
		if what == NOTIFICATION_PREDELETE and self:
			shutdown()

	func shutdown() -> void:
		if threads.empty():
			return
		should_shutdown = true
		for i in threads.size():
			semaphore.post()
		for t in threads:
			if t.is_active():
				t.wait_to_finish()
		threads.clear()
		should_shutdown = false


var _task_queue = []
var _workers: _WorkerPool = null


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and self:
		shutdown()


func create_serial() -> void:
	"""Attempt to create a threaded Dispatch Queue with 1 Thread"""
	create_concurrent(1)


func create_concurrent(thread_count: int = 1) -> void:
	"""Attempt to create a threaded Dispatch Queue with thread_count Threads"""
	if not OS.can_use_threads() or thread_count == get_thread_count():
		return

	if is_threaded():
		shutdown()

	_workers = _WorkerPool.new()
	for i in max(1, thread_count):
		var thread = Thread.new()
		_workers.threads.append(thread)
		thread.start(self, "_run_loop", _workers)


func dispatch(object: Object, method: String, args: Array = []) -> Task:
	var task = Task.new()
	if object.has_method(method):
		task.object = object
		task.method = method
		task.args = args

		if is_threaded():
			_workers.mutex.lock()
			_task_queue.append(task)
			_workers.mutex.unlock()
			_workers.semaphore.call_deferred("post")
		else:
			if _task_queue.empty():
				call_deferred("_sync_run_next_task")
			_task_queue.append(task)
	else:
		push_error("Object '%s' has no method named %s" % [object, method])
	return task


func dispatch_group(task_list: Array) -> TaskGroup:
	var group = TaskGroup.new(is_threaded())
	for args in task_list:
		var task = callv("dispatch", args)
		if task.object:
			group.add_task(task)

	return group


func is_threaded() -> bool:
	return _workers != null


func get_thread_count() -> int:
	if is_threaded():
		return _workers.threads.size()
	else:
		return 0


func size() -> int:
	var result
	if is_threaded():
		_workers.mutex.lock()
		result = _task_queue.size()
		_workers.mutex.unlock()
	else:
		result = _task_queue.size()
	return result


func is_empty() -> bool:
	return size() <= 0


func clear() -> void:
	if is_threaded():
		_workers.mutex.lock()
		_task_queue.clear()
		_workers.mutex.unlock()
	else:
		_task_queue.clear()


func shutdown() -> void:
	clear()
	if is_threaded():
		var current_workers = _workers
		_workers = null
		current_workers.shutdown()


func _run_loop(pool: _WorkerPool) -> void:
	while true:
		pool.semaphore.wait()
		if pool.should_shutdown:
			break

		pool.mutex.lock()
		var task = _pop_task()
		pool.mutex.unlock()
		if task:
			task.execute()


func _sync_run_next_task() -> void:
	var task = _pop_task()
	if task:
		task.execute()
		call_deferred("_sync_run_next_task")


func _pop_task() -> Task:
	var task: Task = _task_queue.pop_front()
	if task and _task_queue.empty():
		task.then_deferred(self, "_on_last_task_finished")
	return task


func _on_last_task_finished(_result):
	if is_empty():
		emit_signal("all_tasks_finished")


#class_name Events extends ResourceItem

#func _init(_name="", _id=0, _path="")











"""
var _e = {
	"listeners": {
		"event": {
			
		}
	},
	"listeners_amt": 0,
}

var _listener = {

}
var _obj = ObjectUtility
var _int = IntUtility


func _init():
	.	


# Connect a handler, obj has to have a function that corresponds to the parameter.
#	message_type: type of the message, we call obj.function(message) based on this.
#	obj: object that holds the callback.
#	function: function to be called on the object.
func connect_listener(_event = "", _listener = null, _func = ""):  #obj: Object, function: String) -> void:
	var connected = false
	
	
	if _listener_valid(_event, _listener, _func):#_str.is_valid(_event) && _obj.is_valid(_listener, _func):
		if _can_connect_listener(_event):#not _has_listeners() or not _e.listeners.has(_event):
			_e._listeners[_event] = _arr.init("vec2")
		var lstn_fn = _arr.to_arr([], "vec2", false, Vector2(_listener, _func))  #_arr.init("vec2")
		var tmp = _e._listeners[_event]
		tmp = _arr.to_arr(tmp, "vec2", true, lstn_fn)
		_e.listeners = tmp
		_e.listeners_amt = _int.incr(_e.listeners_amt)
		connected = true
	return connected

func _has_listeners():
	return _e.listeners_amt > 0

func _can_connect_listener(_event=""):
	return not _has_listeners() or not _e.listeners.has(_event)

#func listener_valid(_event="", _listener=null):
	#return _str.is_valid(_event) && _obj.is_valid(_listener):
func _listener_valid(_event = "", _listener = null, _func = ""):
	var event_valid = _str.is_valid(_event)
	var func_valid = _str.is_valid(_func)
	return _obj.is_valid(_listener, _func) if event_valid && func_valid else _obj.is_valid(_listener) && event_valid && not func_valid

func disconnect_listener(_event="", _listener=null)
	var disconnected = false
	if _listener_valid(_event, _listener):
		if _has_listeners():
			#_e.listeners[_event].erase()
			
			#_can_connect_
	#var disconnected = false
	#if 

# Disconnect a handler, this assumes that some handler with this message type has been registered
#	message_type: type of the message, we call obj.function(message) based on this.
#	obj: object that holds the callback.
#	function: function to be called on the object.
func disconnect_message(message_type: String, obj: Object, function: String) -> void:
	assert(_message_handlers[message_type] != null)
	_message_handlers[message_type].erase([obj, function])


# Disconnect all handlers.
func disconnect_all_message() -> void:
	_message_handlers = {}


# Emits a message to all handlers, message can be modified by the handlers
# and it will show up inside the dictionary that was passed by the caller.
#	message_type: the type of the message, decides which handlers to call.
#	message_data: extra data that can be used by the handler or where the handler can store results.
#	return: returns if it was passed to any handler or not.
func emit_message(message_type: String, message_data: Dictionary) -> bool:
	var handlers = _message_handlers[message_type]
	if handlers != null:
		var invalid = []
		for handler in handlers:
			if is_instance_valid(handler[0]):
				handler[0].call(handler[1], message_type, message_data)
			else:
				invalid.push_back(handler)

		for handler in invalid:
			handlers.erase(handler)

	return handlers != null && !handlers.empty()
