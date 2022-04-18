class_name SingletonUtility


static func is_valid(_singleton):
	return not _singleton == null && _singleton.is_class("Singleton")


static func is_manager_valid(_manager):
	return not _manager == null && _manager.get_class() == "SingletonManager"
