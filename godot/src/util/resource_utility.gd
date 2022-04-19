class_name ResourceUtility


static func is_valid(_resource: Resource):
	return not _resource == null && PathUtility.is_valid(_resource.resource_path)


static func is_name_valid(_resource: Resource, _name: String):
	return _resource.resource_name == _name && is_valid(_resource)


static func is_path_valid(_resource: Resource, _path: String):
	return _resource.resource_path == _path && is_valid(_resource)
