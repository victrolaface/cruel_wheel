class_name NodeUtility


static func is_instance(_node = null):
	var is_inst = false
	if not _node == null:
		is_inst = not _node.filename.empty()
	return is_inst
