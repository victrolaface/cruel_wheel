tool
class_name SingletonDatabase extends Resource

# properties
export(String) var name setget , get_name
export(bool) var has_name setget , get_has_name
export(bool) var has_manager_ref setget , get_has_manager_ref
export(bool) var has_singletons setget , get_has_singletons
export(bool) var has_cache setget , get_has_cache
export(bool) var has_paths setget , get_has_paths
export(bool) var initialized setget , get_initialized
export(bool) var cached setget , get_cached
export(bool) var registered setget , get_registered
export(bool) var saved setget , get_saved
export(bool) var enabled setget , get_enabled
export(bool) var destroyed setget , get_destroyed
export(Resource) var cache setget , get_cache
export(Resource) var paths setget , get_paths
export(int) var cache_amount setget , get_cache_amount
export(int) var paths_amount setget , get_paths_amount

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
		"has_name": false,
		"has_manager_ref": false,
		"has_singletons": false,
		"has_cache": false,
		"has_paths": false,
		"initialized": false,
		"cached": false,
		"registered": false,
		"saved": false,
		"enabled": false,
		"destroyed": false
	}
}


func get_name():
	return _data.name


func is_class(_class: String):
	return _class == SingletonUtility.BASE_CLASS_NAME or _class == _CLASS_NAME


func get_class():
	return _CLASS_NAME


func _validate_singleton(_singleton):
	return SingletonUtility.is_valid(_singleton)


func _validate_paths(_has_cache = false):
	return false


func _is_loaded_valid(_loaded: SingletonTable, _is_cache = false, _is_paths = false):  #=null):
	var valid = false
	if _is_cache:
		valid = SingletonTableUtility.is_loaded_valid(_loaded) && SingletonTableUtility.is_loaded_cache_valid(_loaded)
	elif _is_paths:
		valid = SingletonTableUtility.is_loaded_valid(_loaded) && SingletonTableUtility.is_loaded_paths_valid(_loaded)
	return valid


func _valid_loaded_database(_loaded_db = null):
	return (
		not _loaded_db == null
		&& StringUtility.is_valid(_loaded_db.name)
		&& _loaded_db.has_name
		&& not _loaded_db.has_manager_ref
		&& _loaded_db.initialized
		&& not _loaded_db.cached
		&& not _loaded_db.registered
		&& _loaded_db.saved
		&& not _loaded_db.enabled
		&& not _loaded_db.destroyed
		&& (_loaded_db.cache_amount > 0 or _loaded_db.paths_amount > 0)
		&& (
			(_loaded_db.has_singletons && _loaded_db.has_cache && _loaded_db.has_paths)
			or (_loaded_db.has_cache or _loaded_db.has_paths)
		)
	)


func _init(_manager = null, _enable = false):
	var loaded = ResourceLoader.load(_PATH)
	if not loaded:
		push_error("cannot load resource.")
	elif _valid_loaded_database(loaded):
		_data.name = loaded.name
		_data.cache_amount = loaded.cache_amount
		_data.paths_amount = loaded.paths_amount
		_data.state.has_cache = loaded.has_cache
		_data.state.has_paths = loaded.has_paths
		_data.state.has_singletons = loaded.has_singletons
		var validate_cache = _data.state.has_singletons or _data.state.has_cache  # or
		var validate_paths = _data.state.has_singletons or _data.state.has_paths
		if validate_cache:
			if _is_loaded_valid(loaded.cache, true):
				_data.cache = loaded.cache
			else:
				_data.cache = SingletonTableUtility.valid_cache(loaded.cache)
		if validate_paths:
			if _is_loaded_valid(loaded.paths, false, true):
				_data.paths = loaded.paths
			else:
				_data.paths = SingletonTableUtility.valid_paths(loaded.paths)
		# validate, compare cache names and paths
	else:
		# default init
		# save
		pass

	# set manager_ref
	# final init
	# if enable, do enable


# setters, getters functions
func get_has_name():
	return _data.state.has_name


func get_has_manager_ref():
	return _data.state.has_manager_ref


func get_cached():
	return _data.state.cached


func get_registered():
	return _data.state.registered


func get_saved():
	return _data.state.saved


func get_cache_amount():
	return _data.cache_amount


func get_paths_amount():
	return _data.paths_amount


func get_cache():
	return _data.cache


func get_paths():
	return _data.paths


func get_destroyed():
	return _data.destroyed


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


"""
#if _data.state.has_singletons:
#	validate_cache = true
#	validate_paths = true
	#validated_cache = _on_init_load_cache(loaded.cache)
	#validated_paths = _on_init_load_paths(loaded.paths)
#elif _data.state.has_cache:
#	validate_cache = true
	#_on_init_load_cache(loaded.cache)
	#validated = _validate_cache()
#elif _data.state.has_paths:
#	validate_paths = true
	#_on_init_load_paths(loaded.paths)
	#validated = _validate_paths()
#else:
#	validated = true
#if validated:
	#_data.name = _CLASS_NAME
	#_data.manager_ref = _manager
	#var saved = ResourceSaver.save(_PATH, self)
	#if not saved:
	#	push_error("cannot save resource.")
	# validate
	#if _validate():
	# save
	#pass
#func _add_to_cache(_singleton):
#	_data.cache[_singleton.name] = _singleton
#	_data.cache_amount = _on_add_amount(_data.cache_amount)
#	_data.state.has_cache = _on_has(_data.state.has_cache)
#	_data.state.has_singletons = _on_has_singletons(_data.state.has_paths, _data.state.has_singletons)
#func _add_to_paths(_singleton):
#	_data.paths[_singleton.name] = _singleton.path
#	_data.paths_amount = _on_add_amount(_data.paths_amount)
#	_data.state.has_paths = _on_has(_data.state.has_paths)
#	_data.state.has_singletons = _on_has_singletons(_data.has_cache, _data.state.has_singletons)
#func _on_add_amount(_amount):
#	return _amount + 1
#func _on_has(_has):
#	if not _has:
#		return not _has
#func _on_has_singletons(_has, _has_singletons):
#	if _has && not _has_singletons:
#		return _has
#func _validate():
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
