tool
class_name SingletonDatabase extends Resource

# properties
export(bool) var enabled setget , get_enabled
#export(String) var name setget , get_name
#export(bool) var has_name setget , get_has_name
#export(bool) var has_manager setget , get_has_manager
#export(bool) var has_database setget , get_has_database
#export(bool) var has_singletons setget , get_has_singletons
#export(bool) var initialized setget , get_initialized
#export(bool) var cached setget , get_cached
#export(bool) var destroyed setget , get_destroyed
#export(bool) var first_initialization setget , get_first_initialization
#export(Resource) var database setget , get_database
#export(int) var singletons_amount setget , get_singletons_amount

# fields
const _BASE_CLASS_NAME = "Singleton"
const _CLASS_NAME = "SingletonDatabase"
const _PATH = "res://data/singleton_db.tres"

var _data = {
	"name": "",
	"manager_ref": null,
	"self_ref": null,
	"db": null,
	"state":
	{
		"first_init": true,
		"has_name": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"has_db": false,
		"cached": false,
		"initialized": false,
		"enabled": false,
		"destroyed": false,
	}
}

#func get_name():
#	return _data.name

#func get_first_initialization():
#	return _data.state.first_init

#func get_has_manager():
#	return _data.state.has_manager_ref

#func get_has_database():
#	return _data.state.has_db


func is_class(_class: String):
	return _class == _CLASS_NAME or _class == _BASE_CLASS_NAME


func get_class():
	return _CLASS_NAME


func _init(_manager = null):
	if _manager.initialized:
		var data = ResourceLoader.load(_PATH)
		if data.first_initialization:
			data = _on_init_name_mgr(data, _manager)
			var base_type = ClassType.from_name(_BASE_CLASS_NAME)
			var singleton_class_names = base_type.get_inheritors_list()
			var singleton_class_names_amt = singleton_class_names.count()
			if singleton_class_names_amt > 0:
				var db_init = SingletonTable.new(_CLASS_NAME, self, _manager)
				if db_init.enabled:
					var added_amt = 0
					for singleton_class_name in singleton_class_names:
						var singleton = ClassType.from_name(singleton_class_name)
						singleton._init()
						singleton.init_from_manager(_manager)
						if singleton.enabled && db_init.add(singleton.name, singleton):
							added_amt = added_amt + 1
					if (
						db_init.has_items
						&& db_init.items_amount == singleton_class_names_amt
						&& db_init.items_amount == added_amt
					):
						_data.db = db_init
						_data.state.has_db = true
						_data.self_ref = self
						_data.state.has_self_ref = not _data.self_ref == null
						_data.state.cached = _data.state.has_name && _data.state.has_self_ref && _data.state.has_manager_ref
						_data.state.initialized = _data.state.cached
						_data.state.first_init = not _data.state.initialized
						_data.state.enabled = _data.state.initialized
						if _data.state.enabled:
							ResourceLoader.save(_PATH, self)
		else:
			data = _on_init_name_mgr(data, _manager)
			if not data.db.enable(self, _manager):
				data.db.remove_disabled()
			if not data.db.valid():
				data.db.remove_invalid()
				#pass
				# check for any invalid names, paths
				# check file sys for any non-added singletons


func _on_init_name_mgr(_loaded_data, _mgr):
	_loaded_data.name = _CLASS_NAME
	_loaded_data.has_name = StringUtility.is_valid(_loaded_data.has_name)
	_loaded_data.manager_ref = _mgr
	_loaded_data.has_manager_ref = not _loaded_data.manager_ref == null
	return _loaded_data


func _on_has_invalid_class_name(_loaded_data, _name):
	var has_invalid_class_name = not _loaded_data.db[_name].has_path  #false
	if not has_invalid_class_name:
		has_invalid_class_name = not PathUtility.is_valid(_loaded_data[_name].path)
	return has_invalid_class_name


func enable(_manager = null):
	var _enabled = false
	if not _data.state.enabled:
		var data = ResourceLoader.load(_PATH)
		if not data.first_initialization && SingletonDatabaseUtility.is_init_valid(_manager):
			data = _on_init_name_mgr(data, _manager)
			var singleton_class_names = data.db.keys
			var has_invalid_class_name = false
			for n in singleton_class_names:
				has_invalid_class_name = _on_has_invalid_class_name(data, n)
				if has_invalid_class_name:
					break
			if has_invalid_class_name:
				var invalid_class_names = []
				for n in singleton_class_names:
					has_invalid_class_name = _on_has_invalid_class_name(data, n)
					if has_invalid_class_name:
						invalid_class_names.append(n)
					var invalid_class_names_amt = invalid_class_names.count()
					var removed_amt = 0
					var init_amt = data.db.items_amount
					for i in invalid_class_names:
						if data.db.remove(i):
							removed_amt = removed_amt + 1
						else:
							push_warning("unable to remove invalid item.")
					if not removed_amt == invalid_class_names_amt or not data.db.items_amount == init_amt - removed_amt:
						push_error("unable to remove invalid items.")

	return _enabled


func disable():
	var disabled = false
	if _data.state.enabled:
		_data.name = ""
		_data.manager_ref = null
		_data.self_ref = null
		_data.state.has_name = false
		_data.state.has_manager_ref = false
		_data.state.cached = false
		_data.state.enabled = false
		if not _data.db.disable():
			push_error("unable to disable singleton database.")
	return disabled


# setters, getters functions
func get_enabled():
	return _data.state.enabled


#func get_has_name():
#	return _data.state.has_name

#func get_has_manager_ref():
#	return _data.state.has_manager_ref

#func get_cached():
#	return _data.state.cached

#func get_singletons_amount():
#	return _data.db.items_amount  #amount

#func get_database():
#	return _data.db

#func get_destroyed():
#	return _data.destroyed

#func get_initialized():
#	return _data.state.initialized

#func get_has_singletons():
#	return _data.db.has_items

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
