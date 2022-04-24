tool
class_name Singleton extends Resource

# properties
export(bool) var is_singleton setget , get_is_singleton
export(bool) var enabled setget , get_enabled

# fields
var _data = {
	"name": "",
	"path": "",
	"self_ref": null,
	"manager_ref": null,
	"state":
	{
		"editor_only": false,
		"has_name": false,
		"cached": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"initialized": false,
		"enabled": false
	}
}
var _invalid_params = {}
var _init_vals = {}

const _BASE_CLASS_NAME = "Singleton"


# inherited methods private
func _init(_self_ref = null):
	_on_init(_self_ref)


# public methods
func init_from_manager(_manager = null):
	_init_vals = _data
	_data.manager_ref = _manager
	_data.state.has_manager_ref = not _data.manager_ref == null
	_data.state.cached = _data.state.has_name && _data.state.has_path && _data.state.has_manager_ref
	_data.state.initialized = _data.state.cached && _data.state.emit_changed_connected
	_data.state.enabled = _data.state.initialized
	return _data.state.enabled


func enable(_self_ref = null, _manager = null):
	var _enabled = false
	_on_init(_self_ref)
	_enabled = init_from_manager(_manager)
	_enabled = _enabled && _data.state.enabled
	return _enabled


func validate():
	var invalid = false
	var validating = true
	var invalid_params_keys = _invalid_params.keys
	var invalid_params_state_keys = _invalid_params.state.keys()
	while validating:
		for k in invalid_params_keys:
			var on_non_state = not k == "state"
			var on_invalid_params_non_state = _invalid_params[k] == _data[k]
			if on_non_state:
				if k == "path":
					invalid = on_invalid_params_non_state or not PathUtility.is_valid(_data[k])
				else:
					invalid = on_invalid_params_non_state
			else:
				for s in invalid_params_state_keys:
					invalid = _invalid_params.state[s] == _data.state[s]
					if invalid:
						break
			validating = not invalid
		validating = false
	return not invalid


func disable():
	var disabled = false
	if _data.state.enabled:
		_init_vals = _data
		_data.name = ""
		_data.path = ""
		_data.self_ref = null
		_data.manager_ref = null
		_data.state.editor_only = false
		_data.state.has_name = false
		_data.state.cached = false
		_data.state.has_manager_ref = false
		_data.state.has_self_ref = false
		_data.state.initialized = false
		_data.state.enabled = false
		disabled = not _data.state.enabled
	return disabled


# public inherited methods
func is_class(_class):
	return (_data.state.has_name && _class == _data.name) || _class == _BASE_CLASS_NAME


func get_class():
	return _BASE_CLASS_NAME


# private helper methods
func _on_init(_self_ref = null):
	_invalid_params = _data
	_init_vals = _data
	_data.self_ref = _self_ref
	_data.state.has_self_ref = not _data.self_ref == null
	if _data.state.has_self_ref:
		_data.name = _self_ref.resource_name
		_data.state.has_name = StringUtility.is_valid(_data.name)
		_data.path = _self_ref.resource_path
		_data.state.has_path = PathUtility.is_valid(_data.path)


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


# setters, getters public
func get_is_singleton():
	return true


func get_enabled():
	return _data.state.enabled
