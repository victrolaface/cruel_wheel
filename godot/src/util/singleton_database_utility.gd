class_name SingletonDatabaseUtility

const _CLASS_NAME = "SingletonDatabase"
const _BASE_CLASS_NAME = "Singleton"
const _MGR_CLASS_NAME = "SingletonManager"


static func is_init_valid(_manager = null):
	return (
		not _manager == null
		&& not _manager.resource_local_to_scene
		&& _manager.name == _MGR_CLASS_NAME
		&& _manager.cached
		&& _manager.initialized
		&& not _manager.enabled
		&& not _manager.has_database
		&& _manager.has_name
		&& _manager.is_singleton
		&& _manager.is_class(_MGR_CLASS_NAME)
		&& _manager.is_class(_BASE_CLASS_NAME)
		&& _manager.get_class() == _MGR_CLASS_NAME
	)
