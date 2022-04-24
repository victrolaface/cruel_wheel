tool
class_name ResourceTable extends Resource

var _data = {
	"name": "",
	"database_ref": null,
	"manager_ref": null,
	"state": {"has_name": false, "has_database_ref": false, "has_manager_ref": false, "initialized": false, "enabled": false}
}

const _CLASS_NAME = "ResourceTable"
const _BASE_CLASS_NAME = "Resource"

func _init():
    pass

func initialize(_class_name = "", _database_ref = null, _manager_ref = null):
	_data.name = _class_name
	_data.database_ref = _database_ref
	_data.manager_ref = _manager_ref
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.state.has_database_ref = not _data.database_ref == null
	_data.state.has_manager_ref = not _data.manager_ref == null
	_data.state.initialized = _data.state.has_name && _data.state.has_database_ref && _data.state.has_manager_ref
	_data.state.enabled = _data.state.initialized

func is_class(_class):
    return _class == _data.name or _class == _CLASS_NAME or _class == _BASE_CLASS_NAME

func get_class():
    return _CLASS_NAME