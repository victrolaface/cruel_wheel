class_name SingletonManagerStorage
extends Singletons


func pushed(_class_name: String, _path: String, _obj: Object):
	if _class_name != null && _class_name != "" && _path != null && _path != "" && _obj != null:
		var cache_pushed = false
		var cache: Dictionary = SINGLETON_CACHE.get_cache()
		var cache_keys = cache.keys()
		for k in cache_keys:
			if k == _class_name:
				if cache[k] != null:
					var id = _obj.get_instance_id()
					var cached_id = cache[k].get_instance_id()
					if id != cached_id:
						cache[k] = _obj
						cache_pushed = true
				else:
					cache[k] = _obj
					cache_pushed = true
			if cache_pushed:
				break
		if not cache_pushed:
			cache[_class_name] = _obj
			cache_pushed = true
		var path_pushed = false
		var paths: Dictionary = SINGLETON_CACHE.get_paths()
		var paths_keys = paths.keys()
		for k in paths_keys:
			if k == _class_name:
				var val = paths[k]
				if val != null:
					if val != _path:
						paths[k] = _path
						path_pushed = true
				else:
					paths[k] = _path
					path_pushed = true
			if path_pushed:
				break
		if not path_pushed:
			paths[_class_name] = _path
			path_pushed = true
		return cache_pushed && path_pushed
	return false
