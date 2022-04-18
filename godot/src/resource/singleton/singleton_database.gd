tool
class_name SingletonDatabase extends Resource

# fields
var _data = {"cache": {}, "paths": {}}


# public methods
func get_cache():
	return _data.cache


func get_paths():
	return _data.paths
