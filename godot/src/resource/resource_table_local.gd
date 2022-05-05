tool
class_name ResourceTableLocal extends ResourceTable

enum _INSTANCE { DISABLED = 0, ENABLED = 1 }

var _l = {
	"class_names": PoolStringArray(["ResourceTableLocal"]),
	"path": "res://src/resource/resource_table_local.gd",
	"items": {},
}


#_path = "", _class_names = [], _local = true, _id = 0, _editor_only = false
func _init(_id = 0, _editor_only = false):  #(_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	#_l.class_names = .init_class_names(_class_names, _l.class_names)
	#var local = .init_local_param(_local, _id)
	#var path = .init_path_param(_path, _l.path)
	# (_paths = [], _class_names = [], _local = true, _id = 0, _editor_only = false)
	._init(_l.path, _l.class_names, true, _id, _editor_only)  #local, path, _editor_only, _l.class_names, _id)


func add(_val = null, _id = 0, _validated = false):
	var added = false
	var can_add = false
	if self.enabled:
		var valid = _validated
		if not valid:
			valid = .item_is_valid(_val)
		if valid:
			var key = _val.get_class()
			var id = _id if _validated else _val.id
			if .str_is_valid(key) && .id_is_valid(id) && _val.local && _val.has_id && _val.id == id && _val.enabled:
				can_add = not self.has_items
				if not can_add:
					can_add = not can_add if not _has_key(key) else not _l.items[key].has(id)
	if can_add:
		var key = _val.get_class()
		var id = _val.id
		var on_add = false
		var tmp = _l.items[key]
		if not tmp.has(id):
			on_add = tmp.add(id)
		else:
			tmp = ResourceItemsLocal.new()
			on_add = tmp._init(id)
		if on_add:
			_l.items[key] = tmp
			added = .add(id, _val, true)
	return added


func remove(_key = "", _id = 0):
	var rem = false
	if self.enabled && .str_is_valid(_key) && .id_is_valid(_id):
		if _has_key(_key):
			if _l.items[_key].has(_id):
				var tmp = _l.items[_key]
				if tmp.remove(_id):
					_l.items[_key] = tmp
					rem = .remove(_id)
	return rem


# private helper methods
func _has_key(_key = ""):
	return _l.items.has(_key)
