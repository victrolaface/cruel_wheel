tool
class_name EventListener extends Resource

export(int) var id setget , get_id
export(String) var event setget , get_event
export(String) var method setget , get_method
export(int) var processing_mode setget , get_processing_mode

var _data = {
	"id": 0,
	"ref": null,
	"event": "",
	"method": "",
	"data": {},
	"processing_mode": 0,
}


func _init(_ref = null, _event = "", _method = "", _val = null, _proc_mode = 0, _local = true):
	if StringUtility.is_valid(_event):
		_data.event = _event
	if ObjectUtility.is_valid(_ref, _method):
		_data.ref = _ref
		if _data.ref.enabled:
			resource_local_to_scene = _data.ref.local
			if _data.ref.has_id:
				_data.id = _data.ref.id
			_data.method = _method
			_data.data = {}
			if _proc_mode == 0 or _proc_mode == 1:
				_data.processing_mode = _proc_mode


func get_id():
	return _data.id


func get_event():
	return _data.event


func get_method():
	return _data.method


func get_processing_mode():
	return _data.processing_mode


func get_data():
	return _data.data if _data.data.size() > 0 else {}
