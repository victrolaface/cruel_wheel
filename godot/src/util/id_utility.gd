tool
class_name IDUtility extends Resource


static func is_valid(_id):
	return _id != null && _id > 0


static func object_is_valid(_obj: Object):
	var id = _obj.get_instance_id()
	return _obj != null && is_valid(id)
