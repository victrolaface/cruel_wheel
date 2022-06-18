extends Node

# fields
enum _SIGNAL {
	NONE = 0,
	SCENE_TREE_ADDED_NODE = 1,
	SCENE_TREE_REMOVED_NODE = 2,
	SCENE_TREE_RENAMED_NODE = 3,
	CURRENT_SCENE_READY = 4,
	CURRENT_SCENE_ENTERED = 5,
	CURRENT_SCENE_RENAMED = 6,
	CURRENT_SCENE_EXITING = 7
}

enum _REF_TYPE { NONE = 0, SCENE_TREE = 1, CURRENT_SCENE = 2 }

var _int = IntUtility
var _obj = ObjectUtility
var _type = TypeUtility
var _str = StringUtility
var _node = NodeUtility

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
func _on_scene_tree_added_node(_node_ref = null):
	pass


#func _on_node_added(_node_ref = null):
#	if not _node_ref == null && not _data.nodes.has(_node_ref):
#		_data.nodes.add(_node_ref)


func _on_scene_tree_removed_node(_node_ref = null):
	pass


#func _on_node_removed(_node_ref = null):
#	if not _node_ref == null && _data.nodes.has(_node_ref):
#		_data.nodes.remove(_node_ref.name)


func _on_scene_tree_renamed_node(_node_ref = null):
	if _node.is_node(_node_ref):
		var name = _node.name
		var id = _node.get_instance_id()
		if id > 0 && _str.is_valid(name) && _data.nodes.has_instance_id(id):
			if not _data.nodes.rename(_node):
				push_warning("unable to rename node.")


func _on_current_scene_ready():
	# current scene = _data.current_scene_ref
	pass


func _on_current_scene_entered():
	pass


func _on_current_scene_renamed():
	pass


func _on_current_scene_exiting():
	pass


# private helper methods
func _enable():
	if not _data.state.enabled:
		_on_init(true)


func _disable():
	if _data.state.enabled:
		_on_init(false)


func _valid_has(_object = null, _class_type = ""):
	return _type.is_class_type(_object, _class_type) if _obj.is_valid(_object) && _str.is_valid(_class_type) else false


func _valid_val(_val = null, _valid = false, _val_invalid = null):
	return _val if _valid else _val_invalid


func _on_init(_do_init = true):
	var on_init = _do_init && (_data.keys().size() == 0 or not _data.state.enabled)
	var on_deinit = not _do_init && _data.state.enabled
	if on_init or on_deinit:
		_data.scene_tree_ref = null
		_data.root_ref = null
		_data.current_scene_ref = null
		_data.state.has_scene_tree_ref = false
		_data.state.has_root_ref = false
		_data.state.has_current_scene_ref = false
		_data.state.has_nodes_storage = false
		_data.state.scene_tree_added_node_connected = false
		_data.state.scene_tree_removed_node_connected = false
		_data.state.scene_tree_renamed_node_connected = false
		_data.state.current_scene_ready_connected = false
		_data.state.current_scene_entered_connected = false
		_data.state.current_scene_renamed_connected = false
		_data.state.current_scene_exiting_connected = false
		if on_init:
			var init_nodes_amt = 0
			var added_nodes_amt = 0
			var all_signals_connected = false
			var scene_tree = get_tree()
			_data.state.has_scene_tree_ref = _valid_has(scene_tree, "SceneTree")
			_data.scene_tree_ref = _valid_val(scene_tree, _data.state.has_scene_tree_ref, _data.scene_tree_ref)
			_data.root_ref = _valid_val(_data.scene_tree_ref.get_root(), _data.state.has_scene_tree_ref, _data.root_ref)
			_data.state.has_root_ref = _valid_has(_data.root_ref, "TreeItem")
			_data.current_scene_ref = _valid_val(
				_data.root_ref.get_child(_data.root_ref.get_child_count() - 1),
				_data.state.has_root_ref,
				_data.current_scene_ref
			)
			_data.state.has_current_scene_ref = _valid_val(
				_obj.is_valid(_data.current_scene_ref), _data.state.has_root_ref, _data.state.has_current_scene_ref
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


func _on_connect(_connect = true, _ref_type = _REF_TYPE.NONE, _signal_name = "", _signal_func = ""):
	var param = Node
	var ref_valid = not _ref_type == _REF_TYPE.NONE
	var signal_connected = false
	var signal_disconnected = false
	if _str.is_valid(_signal_name) && _str.is_valid(_signal_func) && ref_valid:
		match _ref_type:
			_REF_TYPE.SCENE_TREE:
				signal_connected = is_connected(_signal_name, _data.scene_tree_ref, _signal_func)
				if _connect && not signal_connected:
					signal_connected = connect(_signal_name, _data.scene_tree_ref, _signal_func, [param], CONNECT_DEFERRED)
				elif not _connect && signal_connected:
					disconnect(_signal_name, _data.scene_tree_ref, _signal_func)
					signal_connected = not signal_connected
			_REF_TYPE.CURRENT_SCENE:
				signal_connected = is_connected(_signal_name, _data.current_scene_ref, _signal_func)
				if _connect && not signal_connected:
					signal_connected = connect(_signal_name, _data.current_scene_ref, _signal_func)
				elif not _connect && signal_connected:
					disconnect(_signal_name, _data.current_scene_ref, _signal_func)
					signal_disconnected = not signal_disconnected
	return signal_connected if _connect else signal_disconnected


func _on_connect_signals(_connect = true):
	for s in _SIGNAL:
		match s:
			_SIGNAL.SCENE_TREE_ADDED_NODE:
				_data.state.scene_tree_added_node_connected = _on_connect(
					_connect, _REF_TYPE.SCENE_TREE, "node_added", "_on_scene_tree_added_node"
				)
			_SIGNAL.SCENE_TREE_REMOVED_NODE:
				_data.state.scene_tree_removed_node_connected = _on_connect(
					_connect, _REF_TYPE.SCENE_TREE, "node_removed", "_on_scene_tree_removed_node"
				)
			_SIGNAL.SCENE_TREE_RENAMED_NODE:
				_data.state.scene_tree_renamed_node_connected = _on_connect(
					_connect, _REF_TYPE.SCENE_TREE, "node_renamed", "_on_scene_tree_renamed_node"
				)
			_SIGNAL.CURRENT_SCENE_READY:
				_data.state.current_scene_ready_connected = _on_connect(
					_connect, _REF_TYPE.CURRENT_SCENE, "ready", "_on_current_scene_ready"
				)
			_SIGNAL.CURRENT_SCENE_ENTERED:
				_data.state.current_scene_entered_connected = _on_connect(
					_connect, _REF_TYPE.CURRENT_SCENE, "tree_entered", "_on_current_scene_entered"
				)
			_SIGNAL.CURRENT_SCENE_RENAMED:
				_data.state.current_scene_renamed_connected = _on_connect(
					_connect, _REF_TYPE.CURRENT_SCENE, "renamed", "_on_current_scene_renamed"
				)
			_SIGNAL.CURRENT_SCENE_EXITING:
				_data.state.current_scene_exiting_connected = _on_connect(
					_connect, _REF_TYPE.CURRENT_SCENE, "tree_exiting", "_on_current_scene_exiting"
				)
			_:
				continue
	var all_signals_connected = (
		_data.state.scene_tree_added_node_connected
		&& _data.state.scene_tree_removed_node_connected
		&& _data.state.scene_tree_renamed_node_connected
		&& _data.state.current_scene_ready_connected
		&& _data.state.current_scene_entered_connected
		&& _data.state.current_scene_renamed_connected
		&& _data.state.current_scene_exiting_connected
	)
	var all_signals_disconnected = (
		not _data.state.scene_tree_added_node_connected
		&& not _data.state.scene_tree_removed_node_connected
		&& not _data.state.scene_tree_renamed_node_connected
		&& not _data.state.current_scene_ready_connected
		&& not _data.state.current_scene_entered_connected
		&& not _data.state.current_scene_renamed_connected
		&& not _data.state.current_scene_exiting_connected
	)
	return all_signals_connected if _connect else all_signals_disconnected
