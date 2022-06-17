tool
class_name NodeItem extends Resource

# properties
export(int) var instance_id setget , get_instance_id
export(bool) var enabled setget , get_enabled
export(bool) var has_node_ref setget , get_has_node_ref
export(bool) var has_instance_id setget , get_has_instance_id
export(bool) var has_encoded_object_as_id setget , get_has_encoded_object_as_id
export(bool) var has_children setget , get_has_children
export(bool) var has_name setget , get_has_name
export(String) var name setget , get_name
export(Resource) var encoded_object_as_id setget , get_encoded_object_as_id

# fields
var _obj = ObjectUtility
var _type = TypeUtility
var _str = StringUtility
var _node = NodeUtility
var _data = {}


# private inherited methods
func _init(_ref = null):
	resource_local_to_scene = true
	_on_init(true, _ref)


# public methods
func enable(_ref = null):
	_on_init(true, _ref)
	return _data.state.enabled


func rename(_ref = null):
	var init_name = ""
	var init_id = 0
	if _data.state.enabled && _node.is_node(_ref):
		init_name = _data.name
		init_id = _data.instance_id
		_on_init(true, _ref)
	return not init_name == _data.name && init_id == _data.instance_id if _data.state.enabled else false


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
		"name": "",
		"instance_id": 0,
		"encoded_obj_as_id": null,
		"state":
		{
			"has_node_ref": false,
			"has_name": false,
			"has_instance_id": false,
			"has_encoded_obj_as_id": false,
			"enabled": false,
		}
	}
	if _do_init:
		var enc_obj = EncodedObjectAsID.new()
		_data.node_ref = _ref
		_data.state.has_node_ref = (
			_type.is_class_type(_data.node_ref, "Node")
			if _obj.is_valid(_data.node_ref)
			else _data.state.has_node_ref
		)
		_data.name = _data.node_ref.name if _data.state.has_node_ref else _data.name
		_data.instance_id = _data.node_ref.get_instance_id() if _data.state.has_node_ref else _data.instance_id
		_data.state.has_instance_id = _data.instance_id > 0 if _data.state.has_node_ref else _data.state.has_instance_id
		enc_obj.object_id = _data.instance_id
		_data.encoded_obj_as_id = enc_obj
		_data.state.has_encoded_obj_as_id = (
			(
				_obj.is_valid(_data.encoded_obj_as_id)
				&& _type.is_class_type(_data.encoded_obj_as_id, "EncodedObjectAsID")
				&& _data.encoded_obj_as_id.object_id > 0
			)
			if _data.state.has_node_ref && _data.state.has_instance_id
			else _data.state.has_encoded_obj_as_id
		)
		_data.state.enabled = _data.state.has_node_ref && _data.state.has_instance_id && _data.state.has_encoded_obj_as_id


func _has_child():
	return _data.node_ref.get_child_count() == 1 or _has_children() if _data.state.enabled else false


func _has_children():
	return _data.node_ref.get_child_count() > 1 if _data.state.enabled else false


# setters, getters functions
func get_instance_id():
	return _data.instance_id if _data.state.enabled && _data.state.has_instance_id else 0


func get_enabled():
	return _data.state.enabled


func get_has_node_ref():
	return _data.state.has_node_ref if _data.state.enabled else false


func get_has_instance_id():
	return _data.state.has_instance_id if _data.state.enabled else false


func get_has_encoded_object_as_id():
	return _data.state.has_encoded_obj_as_id if _data.state.enabled else false


func get_has_child():
	return _has_child()


func get_has_children():
	return _has_children()


func get_has_name():
	return _data.state.has_name if _data.state.enabled else false


func get_name():
	return _data.name if _data.state.enabled && _data.state.has_name else ""


func get_encoded_object_as_id():
	return _data.encoded_obj_as_id if _data.state.enabled && _data.state.has_encoded_object_as_id else null
