extends Node

# fields
var _data = {
	"nodes": null,
	"nodes_amt": 0,
	"state":
	{
		"enabled": false,
	}
}
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


func _init():
	pass


func _ready():
	pass
