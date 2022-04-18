class_name ResourceUtility


static func is_valid(_resource: Resource):
	return not _resource == null && PathUtility.is_valid(_resource.resource_path)
