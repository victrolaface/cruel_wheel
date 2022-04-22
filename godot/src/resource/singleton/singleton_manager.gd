tool
class_name SingletonManager extends Node

# properties
export(bool) var is_singleton setget , get_is_singleton
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(bool) var cached setget , get_cached
export(bool) var has_name setget , get_has_name
export(bool) var has_database setget , get_has_database

# fields
const _CLASS_NAME = "SingletonManager"
const _BASE_CLASS_NAME = "Singleton"

var _data = {
	"self_ref": null,
	"db": null,
	"state": {"initialized": false, "cached": false, "enabled": false, "has_name": false, "has_db": false}
}


# inherited private methods
func _init():
	self.resource_local_to_scene = false
	name = _CLASS_NAME
	_data.self_ref = self
	_data.state.cached = true
	_data.state.has_name = true
	_data.state.initialized = true
	_data.db = SingletonDatabase.new(self, true)
	_data.state.has_db = _data.db.enabled
	_data.enabled = _data.state.has_db  #db.enabled#_data.initialized


# public methods
func is_class(_class):
	return _class == _CLASS_NAME or _class == _BASE_CLASS_NAME  #Singleton.CLASS_NAME


func get_is_singleton():
	return true


# setters, getters functions
func get_initialized():
	return _data.state.initialized


func get_enabled():
	return _data.state.enabled


func get_cached():
	return _data.state.cached


func get_has_name():
	return _data.state.has_name


func get_has_database():
	return _data.state.has_database


"""
#func get_name():
#	return _CLASS_NAME
#func name():
#	return _CLASS_NAME
#func get_class():
#	return _CLASS_NAME
#func resource_name():
#	return _CLASS_NAME
static func singleton(_singleton_name_or_path):
	return _DB.singleton(_singleton_name_or_path)
static func singleton_editor_only(_singleton_editor_only: GDScriptNativeClass):
	return _DB.singleton_editor_only(_singleton_editor_only)
static func destroy(_singleton_to_destroy: Singleton):
	return _DB.destroy(_singleton_to_destroy)
static func save(_singleton: Singleton):
	return _DB.save(_singleton)
static func save_all():
	return _DB.save_all()
static func register_editor_singletons(_plugin: EditorPlugin):
	var registered = false
	registered = _DB.register_editor_singletons()
	return registered
#==============================================================================================================================
static func save(p_script: Script) -> void:
	var paths: Dictionary = SINGLETON_CACHE.get_paths()
	if not paths.has(p_script):
		return
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	#warning-ignore:return_value_discarded
	ResourceSaver.save(paths[p_script], cache[p_script])
static func save_all() -> void:
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	var paths: Dictionary = SINGLETON_CACHE.get_paths()
	for a_script in paths:
		#warning-ignore:return_value_discarded
		ResourceSaver.save(paths[a_script], cache[a_script])
static func _get_persistent_path(p_script: Script):
	return p_script.get("SELF_RESOURCE")
# Register all editor-only singletons.
static func _register_editor_singletons(plugin: EditorPlugin):
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	cache[UndoRedo] = plugin.get_undo_redo()
	cache[EditorInterface] = plugin.get_editor_interface()
	cache[ScriptEditor] = plugin.get_editor_interface().get_script_editor()
	cache[EditorSelection] = plugin.get_editor_interface().get_selection()
	cache[EditorSettings] = plugin.get_editor_interface().get_editor_settings()
	cache[EditorFileSystem] = plugin.get_editor_interface().get_resource_filesystem()
	cache[EditorResourcePreview] = plugin.get_editor_interface().get_resource_previewer()
# Returns an editor-only singleton by its class name.
#static func fetch_editor(p_class: GDScriptNativeClass) -> Object:
#	if not Engine.editor_hint:
#		push_warning("Cannot access '%s' (editor-only class) at runtime." % p_class.get_class())
#		return null
#	var cache: Dictionary = SINGLETON_CACHE.get_cache()
#	if cache.has(p_class):
#		return cache[p_class]
#	return null
===============================================================================================================================
# Look up a singleton by its script. If it doesn't exist yet, make it.
# If it's a Resource with a persistent file path, load it in from memory.
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
# Returns a singleton by its class_name as a String.
static func fetchs(p_name: String) -> Object:
	var ct = ClassType.new(p_name)
	if ct.res:
		return fetch(ct.res)
	return null
# Returns an editor-only singleton by its class name.
static func fetch_editor(p_class: GDScriptNativeClass) -> Object:
	if not Engine.editor_hint:
		push_warning("Cannot access '%s' (editor-only class) at runtime." % p_class.get_class())
		return null
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	if cache.has(p_class):
		return cache[p_class]
	return null
# Remove a singleton from the cache and any paths associated with it.
static func erase(p_script: Script) -> bool:
	var cache: Dictionary = SINGLETON_CACHE.get_cache()
	var paths: Dictionary = SINGLETON_CACHE.get_paths()
	var erased = cache.erase(p_script)
	#warning-ignore:return_value_discarded
	paths.erase(p_script)
	return erased
"""
