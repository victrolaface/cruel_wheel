class_name NodeUtility


# public methods
static func is_instance(_node = null):
	return not _node.filename.empty() if is_node(_node) else false


static func is_node(_node = null):
	return _node.is_class(_type()) if not _node == null else false


# private helper methods
static func _type():
	return "Node"
