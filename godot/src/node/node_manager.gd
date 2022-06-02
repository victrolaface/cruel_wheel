extends Node

# fields
enum _SIGNAL { NONE = 0, NODE_ADDED = 1, NODE_REMOVED = 2, NODE_RENAMED = 3 }
var _obj = ObjectUtility
var _type = TypeUtility

var _data = {
	"state":
	{
		"enabled": false,
	}
}
#"nodes": null,
#"nodes_amt": 0,
#"state":
#{
##	"enabled": false,
#}
#}


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


func _enable():
	if not _data.state.enabled:
		_on_init(true)


func _disable():
	if _data.state.enabled:
		_on_init(false)


func _on_init(_do_init = true):
	var on_do_init = _do_init && (_data.keys().size() == 0 or not _data.state.enabled)
	var on_do_deinit = not _do_init && _data.state.enabled
	if on_do_init or on_do_deinit:
		_data.root_ref = null
		_data.state.has_root_ref = false
		_data.current_scene_ref = null
		_data.state.has_current_scene_ref = false
		_data.state.node_added_to_scene_connected = false
		_data.state.node_rem_from_scene_connected = false
		_data.state.node_renamed_in_scene_connected = false
		_data.nodes = null
		_data.state.enabled = false
		if on_do_init:
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


"""
_data.root_ref = null
_data.scene_tree_ref = null
_data.state.node_added_to_scene_tree_connected=false
_data.state.node_removed_from_scene_tree_connected=false
_data.state.node_renamed_in_scene_tree_connected=false
_data.state.scene_tree_changed_connected=false
_data.state.has_root_ref = false
_data.state.has_scene_tree_ref = false
"""

#pass

#func _ready():
#	pass
