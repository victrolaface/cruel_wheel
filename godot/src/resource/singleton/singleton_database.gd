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


func _is_singleton(_singleton):
	return _singleton.is_class("Singleton")


func _is_path(_is_singleton, _singleton):
	return not _is_singleton && PathUtility.is_valid(_singleton)


func _is_name(_is_singleton, _is_path):
	return not _is_singleton && not _is_path


func singleton(_singleton_name_or_path):
	var singleton = null
	if has(_singleton_name_or_path):
		var is_singleton = _is_singleton(_singleton_name_or_path)
		var is_path = _is_path(is_singleton, _singleton_name_or_path)
		var is_name = _is_name(is_singleton, is_path)
		if is_name or is_singleton:
			var name = _singleton_name_or_path if is_name else _singleton_name_or_path.name
			singleton = _data.cache[name]
		elif is_path:
			var path = _singleton_name_or_path
			var paths = _data.paths.values()
			var has_path = false
			var idx = 0
			for p in paths:
				has_path = p == path
				if has_path:
					break
				idx = idx + 1
			if has_path:
				var names = _data.paths.keys()
				var name = names[idx]
				if StringUtility.is_valid(name) && _data.cache.has(name):
					var cached_singleton = _data.cache[name]
					if cached_singleton.path == path && cached_singleton.name == name:
						singleton = cached_singleton
	return singleton


func singleton_editor_only(_singleton_editor_only):
	var singleton_editor_only = null
	if not Engine.editor_hint:
		push_warning("Cannot access '%s' (editor-only class) at runtime." % _singleton_editor_only.get_class())
	elif has(_singleton_editor_only):
		singleton_editor_only = singleton(_singleton_editor_only)
	return singleton_editor_only


func destroy(_singleton_to_destroy):
	"""
	# Remove a singleton from the cache and any paths associated with it.
	static func erase(p_script: Script) -> bool:
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	var paths: Dictionary = SINGLETON_CACHE.get_paths()
	var erased = cache.erase(p_script)
	#warning-ignore:return_value_discarded
	paths.erase(p_script)
	return erased
	"""
	#var destroyed = false
	#if _DB.has(_singleton_to_destroy):
	#	destroyed = _DB.destroy(_singleton_to_destroy)
	#return destroyed


func has(_singleton_name_or_path):
	var dirty = true
	if _data.state.enabled:
		var is_singleton = _is_singleton(_singleton_name_or_path)  #_singleton_name_or_path.is_class("Singleton")
		var is_path = _is_path(is_singleton, _singleton_name_or_path)  # not is_singleton && PathUtility.is_valid(_singleton_name_or_path)
		var is_name = _is_name(is_singleton, is_path)  #not is_singleton && not is_path
		var singleton = _singleton_name_or_path if is_singleton else null
		var path = _singleton_name_or_path if is_path else null
		var name = _singleton_name_or_path if is_name else null
		var singleton_from_path = ResourceLoader.load(path) if is_path else null
		var singleton_from_name = ClassReference.from_name(name) if is_name else null
		var is_valid_singleton = is_singleton && SingletonUtility.is_valid(singleton)
		var is_valid_singleton_from_path = is_path && SingletonUtility.is_valid(singleton_from_path)
		var is_valid_singleton_from_name = is_name && SingletonUtility.is_valid(singleton_from_name)
		if not _data.state.has_singletons:
			if is_valid_singleton:
				dirty = _on_has_dirty(singleton)
			elif is_valid_singleton_from_path:
				dirty = _on_has_dirty(singleton_from_path)
			elif is_valid_singleton_from_name:
				dirty = _on_has_dirty(singleton_from_name)
		else:
			var has_singleton = false
			var has_path = false
			if is_valid_singleton:
				has_singleton = _on_has_valid_singleton(singleton)
				has_path = _on_has_valid_path(singleton)
			elif is_valid_singleton_from_path:
				has_singleton = _on_has_valid_singleton(singleton_from_path)
				has_path = _on_has_valid_path(singleton_from_path)
			elif is_valid_singleton_from_name:
				has_singleton = _on_has_valid_singleton(singleton_from_name)
				has_path = _on_has_valid_path(singleton_from_name)
			dirty = not has_singleton && not has_path
	return not dirty


func _on_has_dirty(_singleton):
	return not _added_singleton(_singleton) && not _added_path(_singleton.name, _singleton.path)


func _on_has_valid_singleton(_singleton):
	var has_singleton = _data.cache.has(_singleton.name)
	if not has_singleton:
		has_singleton = _added_singleton(_singleton)
	else:
		if not SingletonUtility.is_copy(_singleton, _data.cache[_singleton.name]):  #singleton_compare):
			_data.cache[_singleton.name] = _singleton
		has_singleton = true
	return has_singleton


func _on_has_valid_path(_singleton):
	var has_path = _data.paths.has(_singleton.name)
	if not has_path:
		has_path = _added_path(_singleton.name, _singleton.path)
	else:
		if not PathUtility.is_valid_copy(_singleton.path, _data.paths[_singleton.name]):
			_data.paths[_singleton.name] = _singleton.path
		has_path = true
	return has_path


func _added_singleton(_singleton):
	_data.cache[_singleton.name] = _singleton
	_data.cache_amount = _data.cache_amount + 1
	if not _data.state.has_cache:
		_data.state.has_cache = true
	return _data.state.has_cache


func _added_path(_singleton_name = "", _singleton_path = ""):
	_data.paths[_singleton_name] = _singleton_path
	_data.paths_amount = _data.paths_amount + 1
	if not _data.state.has_paths:
		_data.state.has_paths = true
	return _data.state.has_paths
