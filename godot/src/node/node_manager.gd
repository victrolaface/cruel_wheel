extends Node

# fields
enum _SIGNAL { NONE = 0, NODE_ADDED = 1, NODE_REMOVED = 2, NODE_RENAMED = 3 }

const _SIGNAL_NODE_ADD = "node_added"
const _SIGNAL_NODE_ADD_FUNC = "_on_node_added"
const _SIGNAL_NODE_REM = "node_removed"
const _SIGNAL_NODE_REM_FUNC = "_on_node_removed"
const _SIGNAL_NODE_RENAME = "node_renamed"
const _SIGNAL_NODE_RENAME_FUNC = "_on_node_renamed"

var _int = IntUtility
var _obj = ObjectUtility
var _type = TypeUtility

var _data = {
	"state":
	{
		"enabled": false,
	}
}


# private inherited methods
func _init():
	_enable()


func _ready():
	_enable()


func _enter_tree():
	_enable()


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_enable()
		NOTIFICATION_POSTINITIALIZE:
			_enable()
		NOTIFICATION_PREDELETE:
			_disable()


func _process(_delta):
	pass


func _physics_process(_delta):
	pass


# signal methods
func _on_node_added(_node = null):
	pass


func _on_node_removed(_node = null):
	pass


func _on_node_renamed(_node = null):
	pass


# private helper methods
func _enable():
	if not _data.state.enabled:
		_on_init(true)


func _disable():
	if _data.state.enabled:
		_on_init(false)


func _on_init(_do_init = true):
	var on_init = _do_init && (_data.keys().size() == 0 or not _data.state.enabled)
	var on_deinit = not _do_init && _data.state.enabled
	if on_init or on_deinit:
		_data.root_ref = null
		_data.current_scene_ref = null
		_data.state.has_root_ref = false
		_data.state.has_current_scene_ref = false
		_data.state.has_nodes_storage = false
		_data.state.node_added_to_scene_connected = false
		_data.state.node_rem_from_scene_connected = false
		_data.state.node_renamed_in_scene_connected = false
		if on_init:
			var init_nodes_amt = 0
			var added_nodes_amt = 0
			var all_signals_connected = false
			_data.root_ref = get_tree().get_root()
			_data.state.has_root_ref = _obj.is_valid(_data.root_ref) && _type.is_class_type(_data.root_ref, "TreeItem")
			_data.current_scene_ref = (
				_data.root_ref.get_child(_data.root_ref.get_child_count() - 1)
				if _data.state.has_root_ref
				else _data.current_scene_ref
			)
			_data.state.has_current_scene_ref = (
				_obj.is_valid(_data.current_scene_ref)
				if _data.state.has_root_ref
				else _data.state.has_current_scene_ref
			)
			_data.nodes = Nodes.new()
			_data.state.has_nodes_storage = _data.nodes.enabled
			if _data.state.has_current_scene_ref:
				if _data.state.has_nodes_storage:
					init_nodes_amt = _data.current_scene_ref.get_child_count()
					if init_nodes_amt > 0:
						var nodes = _data.current_scene_ref.get_children()
						if nodes.size() > 0:
							for n in nodes:
								if _data.nodes.add(n):
									added_nodes_amt = _int.incr(added_nodes_amt)
						_data.state.has_nodes_storage = (
							_data.state.has_nodes_storage
							&& _data.nodes.has_nodes
							&& _data.nodes.nodes_amt == init_nodes_amt
							&& _data.nodes.nodes_amt == added_nodes_amt
							&& init_nodes_amt == added_nodes_amt
						)
				all_signals_connected = _on_connect_signals(true)
			_data.state.enabled = (
				_data.state.has_root_ref
				&& _data.state.has_current_scene_ref
				&& _data.state.has_nodes_storage
				&& all_signals_connected
			)
		elif on_deinit && _data.state.enabled:
			if _data.nodes.disable() && _on_connect_signals(false):
				_data.state.enabled = not _data.state.enabled


func _on_connect_signals(_connect = true):
	var all_signals_connected_or_disconnected = false
	for s in _SIGNAL:
		match s:
			_SIGNAL.NODE_ADDED:
				_data.state.node_added_to_scene_connected = _on_connect(_connect, _SIGNAL.NODE_ADDED)
			_SIGNAL.NODE_REMOVED:
				_data.state.node_rem_from_scene_connected = _on_connect(_connect, _SIGNAL.NODE_REMOVED)
			_SIGNAL.NODE_RENAMED:
				_data.state.node_renamed_in_scene_connected = _on_connect(_connect, _SIGNAL.NODE_RENAMED)
			_:
				continue
	all_signals_connected_or_disconnected = (
		(
			_data.state.node_added_to_scene_connected
			&& _data.state.node_rem_from_scene_connected
			&& _data.state.node_renamed_in_scene_connected
		)
		if _connect
		else (
			not _data.state.node_added_to_scene_connected
			&& not _data.state.node_rem_from_scene_connected
			&& not _data.state.node_renamed_in_scene_connected
		)
	)
	return all_signals_connected_or_disconnected


func _on_connect(_connect = true, _signal_type = _SIGNAL.NONE):
	var signal_name = ""
	var signal_func = ""
	var signal_connected = false
	var param = Node
	match _signal_type:
		_SIGNAL.NODE_ADDED:
			signal_name = _SIGNAL_NODE_ADD
			signal_func = _SIGNAL_NODE_ADD_FUNC
		_SIGNAL.NODE_REMOVED:
			signal_name = _SIGNAL_NODE_REM
			signal_func = _SIGNAL_NODE_REM_FUNC
		_SIGNAL.NODE_RENAMED:
			signal_name = _SIGNAL_NODE_RENAME
			signal_func = _SIGNAL_NODE_RENAME_FUNC
	signal_connected = is_connected(signal_name, _data.current_scene_ref, signal_func)
	if _connect && not signal_connected:
		signal_connected = connect(signal_name, _data.current_scene_ref, signal_func, [param], CONNECT_DEFERRED)
	elif not _connect && signal_connected:
		disconnect(signal_name, _data.current_scene_ref, signal_func)
		signal_connected = not signal_connected
	return signal_connected
