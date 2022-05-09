tool
class_name ResourceItem extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var local setget , get_local
export(bool) var has_id setget , get_has_id
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var saved setget , get_saved
export(int) var id setget , get_id
export(String) var name setget , get_name
export(String) var path setget , get_path

# fields
const _CHANGED_SIGNAL = "changed"
const _CHANGED_METHOD = "_on_changed"

var _i = {
	"name": "",
	"id": 0,
	"path": "res://src/resource/resource_item.gd",
	"class_item_name": "ResourceItem",
	"class_names": PoolStringArray(),
	"paths": PoolStringArray(),
	"state":
	{
		"local": true,
		"saved": false,
		"enabled": false,
	}
}

var _util = ResourceItemUtility
var _str = StringUtility


# private inherited methods
func _init(_class_names = [], _rids = [], _paths = [], _local = true, _id = 0):
	self.resource_local_to_scene = _local
	var rid = self.get_rid()
	var res_loc = self.resource_local_to_scene
	var params = _util.init_params(_class_names, _i.class_item_name, _rids, rid, _id, _local, res_loc, _paths, _i.path)
	if params.size() > 0 && params.can_enable:
		_i.name = params.name
		_i.id = params.id
		_i.rids = params.rids
		_i.class_names = params.class_names
		_i.paths = params.paths
		_i.state.local = params.local
		self.resource_name = _i.name
		self.resource_path = _i.paths[0]
		var connected = _changed_connected()
		if not connected:
			connected = _on_changed_connected(true)
		if connected:
			_i.state.enabled = params.can_enable
			enable()


# public inherited methods
func is_class(_class = ""):
	var has_class_name = false
	if _str.is_valid(_class):
		for c in _i.class_names:
			has_class_name = c == _class
			if has_class_name:
				break
		if not has_class_name:
			has_class_name = _class == "Resource"
	return has_class_name


func get_class():
	return _i.class_names[0]


# public methods
func init_parent(_class_names = [], _class_name = "", _rids = [], _rid = 0, _id = 0, _paths = [], _path = ""):
	return _util.init_params_parent(_class_name, _class_name, _rids, _rid, _id, _paths, _path)


func enable():
	return _enable(true)


func disable():
	return _enable(false)


func save():
	_i.state.saved = true


func emit_changed():
	if _changed_connected():
		_on_changed()


# setters, getters functions
func get_enabled():
	return _i.state.enabled


func get_saved():
	return _i.state.saved


func get_has_id():
	return _util.valid_id(_i.id)


func get_has_name():
	return _str.is_valid(_i.name)


func get_local():
	return _i.state.local


func get_has_path():
	return _i.paths.size() > 0


func get_name():
	return _i.name


func get_path():
	return _i.paths[0]


func get_id():
	return _i.id


# private helper methods
func _on_changed():
	if _i.state.saved:
		_i.state.saved = not _i.state.saved


func _changed_connected():
	return self.is_connected(_CHANGED_SIGNAL, self, _CHANGED_METHOD)


func _on_changed_connected(_connect = true):
	var conn_or_disconn = false
	if _connect:
		conn_or_disconn = self.connect(_CHANGED_SIGNAL, self, _CHANGED_METHOD, [], CONNECT_DEFERRED)
	else:
		self.disconnect(_CHANGED_SIGNAL, self, _CHANGED_METHOD)
		conn_or_disconn = not _connect
	return conn_or_disconn


func _enable(_do_enable = true):
	var is_enabled_or_disabled = false
	if _do_enable && not _i.state.enabled:
		_i.state.enabled = _do_enable
		is_enabled_or_disabled = _i.state.enabled
	elif not _do_enable && _i.state.enabled:
		_i.state.enabled = _do_enable
		var disconn = false
		if _changed_connected():
			disconn = _on_changed_connected(false)
		is_enabled_or_disabled = disconn && not _i.state.enabled
	return is_enabled_or_disabled


# public callbacks
func awake():
	pass


func on_enable():
	pass


func on_disable():
	pass


func enter_tree():
	pass


func exit_tree():
	pass


func ready():
	pass


func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


func input(_event: InputEvent):
	pass


func unhandled_input(_event: InputEvent):
	pass


func unhandled_key_input(_event: InputEvent):
	pass
