tool
class_name NodesStorage extends RecyclableStorage

# properties
export(int) var nodes_to_recycle_amt setget set_nodes_to_recycle_amt, get_nodes_to_recycle_amt
export(bool) var enable setget set_enable, get_enable
export(bool) var has_nodes_to_recycle setget , get_has_nodes_to_recycle

# fields
const _TYPE = "NodeItem"


# private inherited methods
func _init():
	var valid_instance = NodeItem.new()
	._init(_TYPE, valid_instance)


# setters, getters functions
func set_nodes_to_recycle_amt(_amt = 0):
	if not .storage_enabled():
		_init()
	.on_to_recycle_amt(_amt)


func get_nodes_to_recycle_amt():
	return .to_recycle_amt()


func set_enable(_enable = false):
	if _enable:
		_init()


func get_enable():
	return .storage_enabled()


func get_has_nodes_to_recycle():
	return .has_to_recycle()
