tool
class_name ResourceTableSingle extends ResourceTable

var _s = {
	"class_names": PoolStringArray(["ResourceTableSingle"]),
	"path": "res://src/resource/resource_table_single.gd",
	"items": {},
}


func _init(_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	_s.class_names = .init_class_names(_class_names, _s.class_names)
	var local = .init_local_param(_local, _id)
	var path = .init_path_param(_path, _s.path)
	._init(local, path, _editor_only, _s.class_names, _id)
