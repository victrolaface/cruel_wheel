class_name SingletonTableUtility

const _BASE_CLASS_NAME = "Singleton"
const _CLASS_NAME = "SingletonTable"
const _MGR_CLASS_NAME = "SingletonManager"


static func is_loaded_valid(_singleton_table = null):
	return (
		not _singleton_table == null
		&& StringUtility.is_valid(_singleton_table.name)
		&& _singleton_table.has_name
		&& not _singleton_table.has_manager
		&& _singleton_table.initialized
		&& not _singleton_table.cached
		&& not _singleton_table.registered
		&& _singleton_table.saved
		&& not _singleton_table.enabled
		&& not _singleton_table.destroyed
		&& _singleton_table.has_database
		&& _singleton_table.database_amount > 0
	)


static func is_init_valid(_name = "", _self_ref = null, _manager = null):
	return (
		StringUtility.is_valid(_name)
		&& not _self_ref == null
		&& _self_ref.is_class(_BASE_CLASS_NAME)
		&& _self_ref.is_class(_CLASS_NAME)
		&& _self_ref.get_class() == _CLASS_NAME
		&& _self_ref.is_singleton
		&& not _self_ref.resource_local_to_scene
		&& not _self_ref.cached
		&& not _self_ref.saved
		&& not _self_ref.enabled
		&& not _self_ref.initialized
		&& not _self_ref.destroyed
		&& not _self_ref.registered
		&& not _self_ref.has_name
		&& not _self_ref.has_manager
		&& _self_ref.items_amount == 0
		&& not _manager == null
		&& not _manager.resource_local_to_scene
		&& _manager.is_class(_BASE_CLASS_NAME)
		&& _manager.is_class(_MGR_CLASS_NAME)
		&& _manager.get_class() == _MGR_CLASS_NAME
		&& _manager.is_singleton
		&& _manager.has_name
		&& _manager.name == _MGR_CLASS_NAME
		&& _manager.initialized
		&& _manager.has_database
		&& _manager.cached
		&& _manager.enabled
	)


static func is_item_valid(_item = null):
	return (
		not _item == null
		&& _item.is_singleton
		&& not _item.enabled
		&& _item.initialized
		&& not _item.destroyed
		&& not _item.registered
		&& _item.saved
		&& _item.has_name
		&& _item.has_path
		&& not _item.cached
		&& not _item.has_manager
	)


#static func can_fix(_item = null):
#	var can_fix = item == null
#	if can_fix:


static func is_loaded_cache_valid(_cache = null):
	var valid = not _cache == null
	if valid:
		var cache_names = _cache.keys()
		var base_name = ClassType.from_name(_BASE_CLASS_NAME)  #Singleton.CLASS_NAME)
		var valid_names = base_name.get_inheritors_list()
		#var invalid_names = []
		for n in cache_names:
			valid = false
			for v in valid_names:
				if n == v:
					valid = v == _cache[n].name && v == _cache[n].get_class()
					if valid:
						continue
			if not valid:
				break
				#invalid_names.append(n)
		#if invalid_names.count() > 0:
		#	for n in invalid_names:
		#		_cache[n].erase()
	return valid


#static func valid_cache(_cache=null):

#static func invalid_cache_names(_cache = null):
#	var invalid_names = []
#	var valid_names = []


static func _is_cache_item_valid(_cache_item = null):
	return (
		SingletonUtility.is_valid(_cache_item)
		&& not _cache_item.enabled
		&& not _cache_item.destroyed
		&& not _cache_item.registered
		&& not _cache_item.cached
		&& not _cache_item.has_manager
		&& _cache_item.has_name
		&& _cache_item.has_path
		&& _cache_item.initialized
		&& PathUtility.is_valid(_cache_item.path)
	)


#static func _is_loaded_singleton_valid(_singleton_item=null):
#	return SingletonUtility.is_valid && _is_loaded_singleton
#	var valid = false
#	if SingletonUtility.is_valid(_singleton_item):
#		_is_loaded_singleton_valid
"""
export(bool) var is_singleton setget , get_is_singleton
export(bool) var enabled setget , get_enabled
export(bool) var initialized setget , get_initialized
export(bool) var destroyed setget , get_destroyed
export(bool) var registered setget , get_registered
export(bool) var is_editor_only setget , get_is_editor_only
export(bool) var has_name setget , get_has_name
export(bool) var has_path setget , get_has_path
export(bool) var cached setget , get_cached
export(bool) var has_manager setget , get_has_manager
export(String) var name setget , get_name
export(String) var path setget , get_path
export(String) var persistent_path setget , get_persistent_path
"""
#	return valid

#static func is_paths_valid(_paths = null):
#	return false
#func _on_validate_cache_or_paths(_cache_or_paths, _name = ""):
#	return (
#		SingletonUtility.is_valid(_cache_or_paths)
#		&& _cache_or_paths.is_class(SingletonTable.BASE_CLASS_NAME)
#		&& _cache_or_paths.name == _name
#		&& _cache_or_paths.initialized
#		&& _cache_or_paths.has_items
#		&& _cache_or_paths.items_amount > 0
#	)
#static func is_loaded_valid(_singleton_table=null):
#
