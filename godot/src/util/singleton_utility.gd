class_name SingletonUtility


static func is_valid(_singleton):
	return not _singleton == null && _singleton.is_class("Singleton")
