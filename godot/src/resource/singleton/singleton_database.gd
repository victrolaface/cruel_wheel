tool
class_name SingletonDatabase extends Resource

# properties
export(String) var name setget , get_name
export(bool) var has_cache setget , get_has_cache
export(bool) var has_paths setget , get_has_paths
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var has_singletons setget , get_has_singletons
export(bool) var destroyed setget , get_destroyed
export(int) var cache_amount setget , get_cache_amount
export(int) var paths_amount setget , get_paths_amount
export(Resource) var cache setget , get_cache
export(Resource) var paths setget , get_paths


func get_cache_amount():
	return _data.cache_amount


func get_paths_amount():
	return _data.paths_amount


# fields
const _CLASS_NAME = "SingletonDatabase"
const _PATH = "res://data/singleton_db.tres"

var _data = {
	"name": "",
	"manager_ref": null,
	"cache": null,
	"paths": null,
	"cache_amount": 0,
	"paths_amount": 0,
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


func get_paths():
	return _data.paths


func get_destroyed():
	return _data.destroyed


func get_name():
	return _data.name


func is_class(_class: String):
	return _class == SingletonUtility.BASE_CLASS_NAME or _class == _CLASS_NAME


func get_class():
	return _CLASS_NAME


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


func _on_init_load_cache(_cache = null):
	if not _cache == null:
		_data.cache = _cache


func _on_init_load_paths(_paths = null):
	if not _paths == null:
		_data.paths = _paths


func _validate_cache():
	return false


func _validate_paths():
	return false


func initialize(_manager = null, _enable = false):
	var loaded = ResourceLoader.load(_PATH)
	if not loaded:
		push_error("cannot load resource.")
	elif not loaded == null && loaded.initialized && not loaded.destroyed:
		var validated = false
		_data.name = loaded.name
		_data.cache_amount = loaded.cache_amount
		_data.paths_amount = loaded.paths_amount
		_data.state.has_cache = loaded.has_cache
		_data.state.has_paths = loaded.has_paths
		_data.state.has_singletons = loaded.has_singletons
		if _data.state.has_singletons:
			_on_init_load_cache(loaded.cache)
			_on_init_load_paths(loaded.paths)
			validated = _validate_cache() && _validate_paths()
		elif _data.state.has_cache:
			_on_init_load_cache(loaded.cache)
			validated = _validate_cache()
		elif _data.state.has_paths:
			_on_init_load_paths(loaded.paths)
			validated = _validate_paths()
		else:
			validated = true
		if validated:
			_data.name = _CLASS_NAME
			_data.manager_ref = _manager
			var saved = ResourceSaver.save(_PATH, self)
			if not saved:
				push_error("cannot save resource.")
			# validate
			# save
			pass
	else:
		# default init
		# save
		pass

	# set manager_ref
	# final init
	# if enable, do enable


"""
if SingletonUtility.is_valid(_manager):
	_data.manager_ref = _manager
	_data.state.initialized = true
	if not _data.state.has_singletons:
		var base_type = ClassType.from_name("Singleton")
		var singletons = base_type.get_inheritors_list()
		for s in singletons:
			var ct = ClassType.from_name(s)
			if not ct.initialized:
				ct.new(_manager)
			if ct.initialized:
				_add_to_cache(ct)
				_add_to_paths(ct)
		if _data.state.has_singletons:
			var names = _data.cache.keys
			for n in names:
				_data.cache[n].register()
			ResourceSaver.save(PATH, self)
			#ResourceSaver
			#for s in _data.cache.
				#ResourceSaver.save(paths[p_script], cache[p_script])

	#_data.state.enabled = true
"""


func _add_to_cache(_singleton):
	_data.cache[_singleton.name] = _singleton
	_data.cache_amount = _on_add_amount(_data.cache_amount)
	_data.state.has_cache = _on_has(_data.state.has_cache)
	_data.state.has_singletons = _on_has_singletons(_data.state.has_paths, _data.state.has_singletons)


func _add_to_paths(_singleton):
	_data.paths[_singleton.name] = _singleton.path
	_data.paths_amount = _on_add_amount(_data.paths_amount)
	_data.state.has_paths = _on_has(_data.state.has_paths)
	_data.state.has_singletons = _on_has_singletons(_data.has_cache, _data.state.has_singletons)


func _on_add_amount(_amount):
	return _amount + 1


func _on_has(_has):
	if not _has:
		return not _has


func _on_has_singletons(_has, _has_singletons):
	if _has && not _has_singletons:
		return _has


# public methods
func get_cache():
	return _data.cache


"""
func _is_singleton(_singleton):
	return _singleton.is_class("Singleton")


func _is_path(_is_singleton, _singleton):
	return not _is_singleton && PathUtility.is_valid(_singleton)


func _is_name(_is_singleton, _is_path):
	return not _is_singleton && not _is_path


func singleton(_singleton_name_or_path):
	var singleton = null
	if has(_singleton_name_or_path):
		var name = _singleton_name(_singleton_name_or_path)
		if StringUtility.is_valid(name):
			singleton = _data.cache[name]
	return singleton


func _singleton_name(_singleton_name_or_path):
	var singleton_name = ""
	var validate_name_in_cache_paths = false
	var is_singleton = _is_singleton(_singleton_name_or_path)
	var is_path = _is_path(is_singleton, _singleton_name_or_path)
	var is_name = _is_name(is_singleton, is_path)
	if is_name or is_singleton:
		var dirty = true
		if is_name && StringUtility.is_valid(_singleton_name_or_path):
			singleton_name = _singleton_name_or_path
			dirty = false
		elif is_singleton:
			var name_from_singleton = _singleton_name_or_path.name
			if StringUtility.is_valid(name_from_singleton):
				singleton_name = name_from_singleton
				dirty = false
		validate_name_in_cache_paths = not dirty
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
			var name_from_paths = names[idx]
			if StringUtility.is_valid(name_from_paths):
				var cached_singleton = _data.cache[name_from_paths]
				if cached_singleton.path == path && cached_singleton.name == name_from_paths:
					singleton_name = cached_singleton.name
					validate_name_in_cache_paths = true
	if validate_name_in_cache_paths && (not _data.cache.has(singleton_name) or not _data.paths.has(singleton_name)):
		singleton_name = ""
	return singleton_name


func singleton_editor_only(_singleton_editor_only):
	var singleton_editor_only = null
	if not Engine.editor_hint:
		push_warning("Cannot access '%s' (editor-only class) at runtime." % _singleton_editor_only.get_class())
	elif has(_singleton_editor_only):
		singleton_editor_only = singleton(_singleton_editor_only)
	return singleton_editor_only


func destroy(_singleton_to_destroy):
	var destroyed = false
	var name = _singleton_name(_singleton_to_destroy)
	if StringUtility.is_valid(name):
		_data.cache.erase(name)
		_data.paths.erase(name)
		destroyed = true
	return destroyed


func has(_singleton_name_or_path):
	var dirty = true
	var has_singleton = false
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
			var has_valid_singleton = false
			var has_valid_path = false
			if is_valid_singleton:
				has_valid_singleton = _on_has_valid_singleton(singleton)
				has_valid_path = _on_has_valid_path(singleton)
			elif is_valid_singleton_from_path:
				has_valid_singleton = _on_has_valid_singleton(singleton_from_path)
				has_valid_path = _on_has_valid_path(singleton_from_path)
			elif is_valid_singleton_from_name:
				has_valid_singleton = _on_has_valid_singleton(singleton_from_name)
				has_valid_path = _on_has_valid_path(singleton_from_name)
			dirty = not has_valid_singleton or not has_valid_path
	has_singleton = not dirty
	return has_singleton


func _on_has_dirty(_singleton):
	return not _added_singleton(_singleton) or not _added_path(_singleton.name, _singleton.path)


func _on_has_valid_singleton(_singleton):
	var has_singleton = _data.cache.has(_singleton.name)
	if not has_singleton:
		has_singleton = _added_singleton(_singleton)
	else:
		if not SingletonUtility.is_copy(_singleton, _data.cache[_singleton.name]):
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
"""
