tool
class_name SingletonManager extends Node

const _DB = preload("res://data/singleton_db.tres")

const _CLASS_NAME = "SingletonManager"


func is_class(_class):
	return _class == get_class() or _class == "Singleton"


func get_class():
	return _CLASS_NAME


func _init():
	if not _DB.initialized:
		_DB.initialize()


# wip
static func singleton(_singleton_name_or_path):
	var s = null
	if _DB.has(_singleton_name_or_path):
		s = _DB.singleton(_singleton_name_or_path)
	return s


# wip
static func singleton_editor_only(_singleton_editor_only_class_name: GDScriptNativeClass):
	return null


static func destroy(_singleton: Singleton):
	# rem from cache, paths, confirm
	return true  # destroyed


static func save(_singleton: Singleton):
	# save to cache, paths, confirm
	return true  # saved


static func persistent_path(_singleton: Singleton):
	#--->_singleton.get("persistent_path")<---
	# ret path from singleton
	return ""


static func register_editor_singletons(_plugin: EditorPlugin):
	# register editor only singletons in cache
	return true  # registered


#==============================================================================================================================
"""

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
#=============================================================================================================================================================
"""
tool
class_name CallbackDelegator
extends Node
# author: xdgamestudios
# license: MIT
# description:
#	Manages a ResourceSet of resources and delegates Node callbacks to each instance.
#	As a ResourceSet, only one element of any given type is allowed on a single elements node.
# deps:
#	- ResourceSet
#	- PropertyInfo
#	- ClassType
# usage:
#	- Creating:
#		elements = elements.new()
#	- Adding elements:
#		elements.add_element(MyResource) # Returns a new or pre-existing instance of the element or null if given an invalid element script.
#	- Checking elements:
#		elements.has_element(MyResource) # Returns true if the element exists in the collection.
#	- Retrieving elements:
#		elements.get_element(MyResource) # Returns the element instance of the given type or null if not in the collection.
#	- Removing elements:
#		elements.remove_element(MyResource) # Removes the element from the collection. Returns true if successful. Else, returns false.
# notes:
#		- Public interface of each stored Resource type:
#			- var owner: Node
#			- func get_enabled() -> bool
#		- Initialization Sequence:
#			1. _awake() called during _enter_tree() after CallbackDelegator initializes owner (for Unity familiarity).
#			2. _enter_tree() called immediately after (so they are virtually aliases for each other)
#			3. _ready() called during _ready().

# The collection of Resources. Only one Resource of each type is allowed.
var _elements: ResourceSet = ResourceSet.new()

# The set of resource instances that have successfully registered themselves to each callback.
var _callbacks: Dictionary = {
	"_enter_tree" : {},
	"_exit_tree" : {},
	"_ready" : {},
	"_process" : {},
	"_physics_process" : {},
	"_input" : {},
	"_unhandled_input" : {},
	"_unhandled_key_input" : {}
}

# Assists with inheritance checks and name identification of script classes.
var _class_type: ClassType = ClassType.new()

func _ready() -> void:
	_handle_notification("_ready")


# Initialize every element and de-activate any non-essential CallbackDelegator notifications.
func _enter_tree() -> void:
	var elements = _elements.get_data().values()
	for an_element in elements:
		if not an_element.owner:
			_initialize_element(an_element)
	_check_for_empty_callbacks()

	_handle_notification("_enter_tree")


func _exit_tree() -> void:
	_handle_notification("_exit_tree")


func _process(delta: float) -> void:
	_handle_notification("_process", delta)


func _physics_process(delta: float) -> void:
	_handle_notification("_physics_process", delta)


func _input(event: InputEvent) -> void:
	_handle_notification("_input", event)


func _unhandled_input(event: InputEvent) -> void:
	_handle_notification("_unhandled_input", event)


func _unhandled_key_input(event: InputEventKey) -> void:
	_handle_notification("_unhandled_key_input", event)


# Add an element to the CallbackDelegator. Does nothing if no
# base_type is assigned. See `set_base_type(...)`.
func add_element(p_type: Script) -> Resource:
	var elements = _elements.get_data()

	_class_type.res = p_type
	if not _class_type.is_type(_elements.get_base_type()):
		return null
	if has_element(p_type):
		return get_element(p_type)

	var element: Resource = p_type.new()

	elements[_class_type.get_script_class()] = element
	_initialize_element(element)

	return element


# Return the element with the same type as p_type.
func get_element(p_type: Script) -> Resource:
	var elements = _elements.get_data()
	_class_type.res = p_type
	return elements.get(_class_type.get_script_class(), null)


# Returns true if the element exists in the internal collection.
func has_element(p_type: Script) -> bool:
	var elements = _elements.get_data()
	_class_type.res = p_type
	return elements.has(_class_type.get_script_class())


# Returns true if successfully able to remove the element
# from the internal collection. Else, returns false.
func remove_element(p_type: Script) -> bool:
	var elements = _elements.get_data()
	var element = get_element(p_type)
	if element:
		_remove_from_callbacks(element)
		_class_type.res = p_type
		return elements.erase(_class_type.get_script_class())
	return false


# The order of returned Scripts is not deterministic.
func get_element_types() -> Array:
	return _elements.get_data().keys()


# The order of returned Resources is not deterministic.
func get_elements() -> Array:
	return _elements.get_data().values()


func _parse_property(p_inspector: EditorInspectorPlugin, p_pinfo: PropertyInfo) -> void:
	match p_pinfo.name:
		"_elements":
			p_inspector.add_custom_control(InspectorControls.new_button("Initialize Default Behavior", false, self, "_set_base_type_behavior"))


func _get_property_list() -> Array:
	return [ PropertyInfoFactory.new_resource("_elements").to_dict() ]


# Helper method to facilitate delegation of the callback.
func _handle_notification(p_name: String, p_param = null) -> void:
	if Engine.editor_hint:
		return
	if p_param:
		for an_element in _callbacks[p_name]:
			an_element.call(p_name, p_param)
	else:
		for an_element in _callbacks[p_name]:
			an_element.call(p_name)


# Setup the owner and initialization of the element. Ensure it updates its callbacks if the script is modified.
func _initialize_element(p_element: Resource) -> void:
	_awake(p_element)
	#warning-ignore:return_value_discarded
	p_element.connect("script_changed", self, "_refresh_callbacks", [p_element])
	_add_to_callbacks(p_element)


# Register necessary callbacks for the element.
func _add_to_callbacks(p_element: Resource) -> void:
	for a_callback in _callbacks:
		if p_element.has_method(a_callback) and p_element.get_enabled():
			_callbacks[a_callback][p_element] = null


# Unregister all callbacks for the element.
func _remove_from_callbacks(p_element: Resource) -> void:
	for a_callback in _callbacks:
		_callbacks[a_callback].erase(p_element)
	_check_for_empty_callbacks()


# Only delegate the call if a callback-implementing, enabled resource relies on it.
func _check_for_empty_callbacks() -> void:
	for a_callback in _callbacks:
		match a_callback:
			"_process":
				set_process(not _callbacks[a_callback].empty())
			"_physics_process":
				set_physics_process(not _callbacks[a_callback].empty())
			"_input":
				set_process_input(not _callbacks[a_callback].empty())
			"_unhandled_input":
				set_process_unhandled_input(not _callbacks[a_callback].empty())
			"_unhandled_key_input":
				set_process_unhandled_key_input(not _callbacks[a_callback].empty())


# Sets up the owner instance on the Behavior.
func _awake(p_element: Resource) -> void:
	p_element.owner = self
	if p_element.has_method("_awake"):
		p_element._awake()


# Reset callback registrations in the event that the script is modified.
func _on_element_script_change(p_element: Resource) -> void:
	_remove_from_callbacks(p_element)
	_add_to_callbacks(p_element)


func _set_base_type_behavior() -> void:
	_class_type.name = "Behavior"
	_elements.set_base_type(_class_type.res)
"""

#====================================================================================================================
"""
tool
class_name Singletons
extends Reference
# author: xdgamestudios
# license: MIT
# description: An API for accessing singletons
# deps:
#	- singleton_cache.tres

const SINGLETON_CACHE = preload("res://addons/godot-next/data/singleton_cache.tres")


"""
