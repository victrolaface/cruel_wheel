tool
class_name SingletonDatabase extends Resource

# properties
export(bool) var enabled setget , get_enabled

# fields
var _initialized setget , _get_initialized

const _CLASS_NAME = "SingletonDatabase"

var _data = {
	"cache": {"amount": 0, "singletons": {}},
	"paths": {"amount": 0, "singletons": {}},
	"manager_ref": null,
	"state": {"initialized": false, "enabled": false, "destroyed": false}
}


func _get_initialized():
	return (_data.cache.amount > 0 || _data.paths.amount > 0) && not _data.manager_ref == null


func get_enabled():
	return self._initialized


func add(_singleton, _is_manager = false):
	if _is_manager && SingletonUtility.is_valid(_singleton) && _singleton.is_class("SingletonManager"):
		_data.manager_ref = _singleton


# public methods
func is_class(_class):
	return _class == "Singleton" || _class == get_class()


func get_class():
	return _CLASS_NAME


func get_cache():
	return _data.cache


func has(_singleton):
	return true
