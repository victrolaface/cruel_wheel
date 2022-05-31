tool
class_name NodeItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var has_children setget , get_has_children
export(bool) var has_name setget , get_has_name
export(String) var name setget , get_name

# fields
var _str = StringUtility
var _data = {}


# private inherited methods
func _init(_ref = null):
	resource_local_to_scene = true
	_on_init(true, _ref)


# public methods
func enable(_ref = null):
	_on_init(true, _ref)
	return _data.state.enabled


func disable():
	_on_init(false)
	return not _data.state.enabled


func children():
	var children_arr = []
	if _has_children():
		children_arr = _data.node_ref.get_children()
	return children_arr


func child():
	var child_ref = null
	var children_arr = []
	if _has_child():
		children_arr = _data.node_ref.get_children()
		if children_arr.size() == 1:
			child_ref = children_arr[0]
	return child_ref


# private helper methods
func _on_init(_do_init = true, _ref = null):
	_data = {
		"node_ref": null,
		"state":
		{
			"enabled": false,
		}
	}
	if _do_init:
		var has_ref = not _ref == null && _ref.is_class("Node")
		if has_ref:
			_data.node_ref = _ref
		_data.state.enabled = has_ref


func _has_child():
	return _data.node_ref.get_child_count() == 1 or _has_children() if _data.state.enabled else false


func _has_children():
	return _data.node_ref.get_child_count() > 1 if _data.state.enabled else false


func _name():
	return _data.node_ref.name if _data.state.enabled else ""


# setters, getters functions
func get_enabled():
	return _data.state.enabled


func get_has_child():
	return _has_child()


func get_has_children():
	return _has_children()


func get_has_name():
	return _str.is_valid(_name())


func get_name():
	return _name()
