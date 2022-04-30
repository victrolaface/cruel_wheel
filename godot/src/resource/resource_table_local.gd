tool
class_name ResourceTableLocal extends ResourceTable

var _l = {
	"class_names": PoolStringArray(["ResourceTableLocal"]),
	"path": "res://src/resource/resource_table_local.gd",
	"items": {},
}


func _init(_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	_l.class_names = .init_class_names(_class_names, _l.class_names)
	var local = .init_local_param(_local, _id)
	var path = .init_path_param(_path, _l.path)
	._init(local, path, _editor_only, _l.class_names, _id)
