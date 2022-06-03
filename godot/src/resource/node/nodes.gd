tool
class_name Nodes extends RecyclableItems

# properties
export(int) var nodes_amt setget , get_nodes_amt
export(bool) var has_nodes setget , get_has_nodes
export(Array, String) var names setget , get_names

# fields
const _TYPE = "NodeItem"
const _RES_PATH = "res://data/node/nodes_storage.tres"

var _storage = preload(_RES_PATH)
var _arr = PoolArrayUtility
var _node = NodeUtility
var _data = {}


# private inherited methods
func _init():
	resource_local_to_scene = false
	_on_init(true)


# public methods
func enable():
	if not _data.state.enabled:
		_on_init(true)
	return _data.state.enabled


func disable():
	if _data.state.enabled && empty() && .on_disable(_RES_PATH, _storage, ResourceSaver.FLAG_COMPRESS):
		_data.state.enabled = not _data.state.enabled
	return not _data.state.enabled


func has(_node_ref = null, _node_name = ""):
	var n = ""
	if _data.state.enabled && _has_nodes():
		var has_node = _node.is_node(_node_ref)
		var name_from_node = _node_ref.name if has_node else ""
		var name_from_node_valid = _str.is_valid(name_from_node)
		var name_valid = _str.is_valid(_node_name)
		if has_node && name_from_node_valid && not name_valid:
			n = name_from_node
		elif (
			(not has_node && not name_from_node_valid && name_valid)
			or (has_node && name_from_node_valid && name_valid && name_from_node == _node_name)
		):
			n = _node_name
	return n if _has_node(n) else false


func add(_node_ref = null):
	var init_amt = 0
	var added_amt = 0
	var final_amt = 0
	if _data.state.enabled && _node.is_node(_node_ref) && not has(_node_ref):
		init_amt = _nodes_amt()
		var node_item = NodeItem
		var name = ""
		var do_add = false
		if self.has_to_recycle:
			node_item = .recycled(_TYPE)
			do_add = node_item.enable(_node_ref)
		else:
			node_item = NodeItem.new(_node_ref)
			do_add = node_item.enabled
		name = node_item.name if node_item.has_name else ""
		do_add = do_add && _str.is_valid(name)
		if do_add:
			_data.nodes[name] = node_item
			added_amt = _int.incr(added_amt)
			if node_item.has_child:
				var children = []
				var child_node_item = NodeItem
				if node_item.has_children:
					children = node_item.children()
				else:
					children = node_item.child()
				if children.size() > 0:
					for c in children:
						do_add = false
						name = c.name
						if not _has_node(name):
							if self.has_to_recycle:
								child_node_item = .recycled(_TYPE)
								do_add = child_node_item.enable(c)
							else:
								child_node_item = NodeItem.new(c)
								do_add = child_node_item.enabled
							name = child_node_item.name if child_node_item.has_name else name
							do_add = do_add && _str.is_valid(name)
							if do_add:
								_data.nodes[name] = child_node_item
								added_amt = _int.incr(added_amt)
			final_amt = _nodes_amt()
	return final_amt > init_amt && final_amt == (init_amt + added_amt)


func remove(_node_name = ""):
	var init_amt = 0
	var final_amt = 0
	var rem_amt = 0
	if _data.state.enabled && _has_node(_node_name):
		var n = _data.nodes[_node_name]
		init_amt = _nodes_amt()
		if n.has_child:
			var children = n.children() if n.has_children else n.child()
			var child_names = _arr.init("str")
			for c in children:
				if c.has_name:
					child_names = _arr.add(child_names, c.name, "str")
			if child_names.size() > 0:
				for cn in child_names:
					if _has_node(cn):
						rem_amt = _on_rem(rem_amt, true, cn)
		rem_amt = _on_rem(rem_amt, true, _node_name)
		final_amt = _nodes_amt()
	return final_amt < init_amt && final_amt == (init_amt - rem_amt)


func empty():
	var init_amt = 0
	var final_amt = 0
	var rem_amt = 0
	var en_has_nodes = _data.state.enabled && _has_nodes()
	var on_empty = false
	if en_has_nodes:
		init_amt = _nodes_amt()
		if _has_nodes():
			for n in _names():
				rem_amt = _on_rem(rem_amt, true, n)
		final_amt = _nodes_amt()
	on_empty = _nodes_amt() == 0
	return on_empty && final_amt == 0 && final_amt == (init_amt - rem_amt) if en_has_nodes else on_empty


# private helper methods
func _on_init(_do_init = true):
	_data = {
		"nodes": null,
		"state":
		{
			"enabled": false,
		}
	}
	if _do_init:
		_data.nodes = {}
		_data.state.enabled = not _data.state.enabled
		._init(_TYPE, _storage)


func _on_rem(_rem_amt = 0, _has_node = false, _node_name = ""):
	if _has_node && _str.is_valid(_node_name):
		var n = _data.nodes[_node_name]
		if n.disable():
			if .add_to_recycle(n) && _data.nodes.erase(_node_name):
				_rem_amt = _int.incr(_rem_amt)
	return _rem_amt


func _has_node(_node_name = ""):
	return _data.nodes.has(_node_name) if _data.state.enabled && _str.is_valid(_node_name) && _has_nodes() else false


func _has_nodes():
	return _nodes_amt() > 0 if _data.state.enabled else false


func _nodes_amt():
	return _data.nodes.keys().size() if _data.state.enabled else 0


func _names():
	return _arr.to_arr(_data.nodes.keys(), "str") if _data.state.enabled && _has_nodes() else []


# setters, getters functions
func get_nodes_amt():
	return _nodes_amt()


func get_has_nodes():
	return _has_nodes()


func get_names():
	return _names()
