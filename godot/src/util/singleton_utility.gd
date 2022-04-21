class_name SingletonUtility

const BASE_CLASS_NAME = "Singleton"


static func is_params_valid(_name = "", _self_ref = null, _mgr_ref = null):
	return (
		StringUtility.is_valid(_name)
		&& not _self_ref == null
		&& not _mgr_ref == null
		&& not _self_ref.resource_local_to_scene
		&& not _mgr_ref.resource_local_to_scene
		&& _self_ref.is_class(BASE_CLASS_NAME)
		&& _mgr_ref.is_class(BASE_CLASS_NAME)
		&& _self_ref.is_singleton
		&& _mgr_ref.is_singleton
		&& _mgr_ref.name == "SingletonManager"
	)


"""
static func _is_valid(_singleton = null):
	return (
		not _singleton == null
		&& not _singleton.resource_local_to_scene
		&& _singleton.is_class(BASE_CLASS_NAME)  #Singleton.BASE_CLASS_NAME)
		&& _singleton.get_class() == _singleton.resource_name
		&& StringUtility.is_valid(_singleton.get_class())
		&& StringUtility.is_valid(_singleton.resource_name)
		&& PathUtility.is_valid(_singleton.resource_path)
	)
"""

#static func _is_valid(_singleton):
#	return (
#		not _singleton == null
#		&& _singleton.is_class("Singleton")
#		&& not _singleton.resource_local_to_scene
#		&& StringUtility.is_valid(_singleton.resource_name)
#		&& _singleton.get_class() == _singleton.resource_name
#		&& PathUtility.is_valid(_singleton.resource_path)
#	)
"""
static func is_valid(_singleton):
	var valid = false
	if _is_valid(_singleton):
		var singleton_compare = ResourceLoader.load(_singleton.path)
		if _is_valid(singleton_compare):
			valid = is_copy(_singleton, singleton_compare)
	return valid


static func is_copy(_singleton, _singleton_compare):
	return (
		_singleton.name == _singleton_compare.name
		&& _singleton.path == _singleton_compare.path
		&& _singleton.get_class() == _singleton_compare.get_class()
		&& _singleton.resource_path == _singleton_compare.resource_path
	)


static func _is_valid(_singleton):
	return (
		not _singleton == null
		&& _singleton.is_class("Singleton")
		&& _singleton.enabled
		&& _singleton.has_path
		&& PathUtility.is_valid(_singleton.path)
		&& _singleton.has_name
		&& StringUtility.is_valid(_singleton.name)
		&& _singleton.name == _singleton.get_class()
		&& ResourceUtility.is_name_valid(_singleton, _singleton.name)
		&& ResourceUtility.is_path_valid(_singleton, _singleton.path)
	)

static func is_params_valid(_name = "", _path = "", _singleton = null, _manager = null):
	return StringUtility.is_valid(_name) && PathUtility.is_valid(_path) && is_valid(_singleton) && is_valid(_manager)
"""
