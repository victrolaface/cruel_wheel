tool
class_name SingletonDatabase extends Resource

# properties
export(bool) var has_cache setget , get_has_cache
export(bool) var has_paths setget , get_has_paths
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled

# fields
enum _TYPE { NONE = 0, MANAGER = 1, SINGLETON = 2, PATH = 3 }

const _CLASS_NAME = "SingletonDatabase"

var _data = {
	"cache": {},
	"paths": {},
	"cache_amount": 0,
	"paths_amount": 0,
	"manager_ref": null,
	"state":
	{
		"initialized": false,
		"enabled": false,
		"has_cache": false,
		"has_paths": false,
		"has_singletons": false,
		"destroyed": false
	}
}


func get_has_cache():
	return _data.state.has_cache


func get_has_paths():
	return _data.state.has_paths


func get_initialized():
	return _data.state.initialized


func get_has_singletons():
	return _data.state.has_cache or _data.state.has_paths


func get_enabled():
	return _data.state.enabled


func initialize(_manager = null):
	if SingletonUtility.is_valid(_manager):
		_data.manager_ref = _manager
		_data.state.initialized = true
		_data.state.enabled = true


# public methods
func is_class(_class):
	return _class == "Singleton" || _class == get_class()


func get_class():
	return _CLASS_NAME


func get_cache():
	return _data.cache


func has(_singleton_or_path):
	var dirty = true
	if _data.state.enabled:
		var is_singleton = _singleton_or_path.is_class("Singleton")
		var is_path = not is_singleton && PathUtility.is_valid(_singleton_or_path)
		var singleton = _singleton_or_path if is_singleton else null
		var path = _singleton_or_path if is_path else null
		var singleton_from_path = ResourceLoader.load(path) if is_path else null
		var is_valid_singleton = is_singleton && SingletonUtility.is_valid(singleton)
		var is_valid_singleton_from_path = is_path && SingletonUtility.is_valid(singleton_from_path)
		if not _data.state.has_singletons:
			if is_valid_singleton:
				_data.cache[singleton.name] = singleton
				_on_add_singleton()
				_data.paths[singleton.name] = singleton.path
				_on_add_path()
				dirty = false
			elif is_valid_singleton_from_path:
				_data.cache[singleton_from_path.name] = singleton_from_path
				_on_add_singleton()
				_data.paths[singleton_from_path.name] = singleton_from_path.path
				_on_add_path()
				dirty = false
		else:
			var has_singleton = false
			var has_path = false
			var singleton_compare = null
			var path_compare = ""
			if is_valid_singleton:
				has_singleton = _data.cache.has(singleton.name)
				has_path = _data.paths.has(singleton.name)
				if not has_singleton:
					_data.cache[singleton.name] = singleton
					_on_add_singleton()
					has_singleton = true
				else:
					singleton_compare = _data.cache[singleton.name]
					if not SingletonUtility.is_copy(singleton, singleton_compare):
						_data.cache[singleton.name] = singleton
					has_singleton = true
				if not has_path:
					_data.paths[singleton.name] = singleton.path
					_on_add_path()
					has_path = true
				else:
					path_compare = _data.paths[singleton.name]
					if not PathUtility.is_valid_copy(singleton.path, path_compare):
						_data.paths[singleton.name] = singleton.path
					has_path = true
			elif is_valid_singleton_from_path:
				has_singleton = _data.cache.has(singleton_from_path.name)
				has_path = _data.paths.has(singleton_from_path.name)
				if not has_singleton:
					_data.cache[singleton_from_path.name] = singleton_from_path
					_on_add_singleton()
					has_singleton = true
				else:
					singleton_compare = _data.cache[singleton_from_path]
					if not SingletonUtility.is_copy(singleton_from_path, singleton_compare):
						_data.cache[singleton_from_path.name] = singleton_from_path
					has_singleton = true
				if not has_path:
					_data.paths[singleton_from_path.name] = singleton_from_path.path
					_on_add_path()
					has_path = true
				else:
					path_compare = _data.paths[singleton_from_path.name]
					if not PathUtility.is_valid_copy(singleton_from_path.path, path_compare):
						_data.paths[singleton_from_path.name] = singleton_from_path.name
					has_path = true
			dirty = not has_singleton && not has_path
	return not dirty


func _on_add_singleton():
	_data.cache_amount = _data.cache_amount + 1
	if not _data.state.has_cache:
		_data.state.has_cache = true


func _on_add_path():
	_data.paths_amount = _data.paths_amount + 1
	if not _data.state.has_paths:
		_data.state.has_paths = true


# Look up a singleton by its script. If it doesn't exist yet, make it.
# If it's a Resource with a persistent file path, load it in from memory.
"""
static func fetch(p_script: Script) -> Object:
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	if not cache.has(p_script):
		if p_script is Resource:
			var path = _get_persistent_path(p_script)
			if path:
				var paths: Dictionary = SINGLETON_CACHE.get_paths()
				cache[p_script] = ResourceLoader.load(path) if ResourceLoader.exists(path) else p_script.new()
				paths[p_script] = path
			else:
				cache[p_script] = p_script.new()
		else:
			cache[p_script] = p_script.new()
	return cache[p_script]
"""
