tool
class_name SingletonManager extends Node

# properties
export(bool) var is_singleton setget , get_is_singleton
export(bool) var initialized setget , get_initialized

# fields
const _CLASS_NAME = "SingletonManager"
const _BASE_CLASS_NAME = "Singleton"

var _data = {
	"name": "",
	"self_ref": null,
	"db": null,
	"state":
	{
		"initialized": false,
		"cached": false,
		"enabled": false,
		"has_self_ref": false,
		"has_name": false,
		"has_db": false,
		"connected_tree_exiting": false
	}
}


# inherited private methods
func _init():
	self.resource_local_to_scene = false
	if not self.is_connected("tree_exiting", self, "_on_tree_exiting"):
		if self.connect("tree_exiting", self, "_on_tree_exit", [], CONNECT_ONESHOT):
			_data.state.connected_tree_exiting = true
	name = _CLASS_NAME
	_data.name = name
	_data.self_ref = self
	_data.state.has_self_ref = not _data.self_ref == null
	_data.state.cached = _data.state.has_name && _data.state.has_self_ref
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.state.initialized = _data.state.connected_tree_exiting && _data.state.cached
	_data.db = SingletonDatabase.new(self)
	_data.state.has_db = _data.db.enabled
	_data.state.enabled = _data.db.enabled


func _ready():
	pass


func _enter_tree():
	pass


func _physics_process(_delta):
	pass


func _process(_delta):
	pass


func _on_tree_exiting():
	if _data.state.enabled && _data.db.disable():
		name = ""
		_data.name = name
		_data.self_ref = null
		_data.db = null
		_data.state.has_name = false
		_data.state.cached = false
		_data.state.has_db = false
		_data.state.initialized = false
		if self.is_connected("tree_exiting", self, "_on_tree_exiting"):
			self.disconnect("tree_exiting", self, "_on_tree_exiting")
		_data.state.connected_tree_exiting = false
		_data.state.enabled = false


# public methods
func is_class(_class):
	return _class == _CLASS_NAME or _class == _BASE_CLASS_NAME


func get_class():
	return _CLASS_NAME


func get_is_singleton():
	return true


# setters, getters functions
func get_initialized():
	return _data.state.initialized
