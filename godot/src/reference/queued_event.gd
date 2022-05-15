tool
class_name QueuedEvent extends Resource

var _data = {
	"event_name": "",
	"val": null,
	"proc_mode": 0,
	"listener_names": [],
	"listener_names_oneshot": [],
	"listener_names_called": [],
	"listener_names_oneshot_called": [],
	"state":
	{
		"has_event_name": false,
		"has_val": false,
		"has_proc_mode": false,
		"has_listeners": false,
		"has_listeners_oneshot": false,
		"called_all_listeners": false,
		"called_all_listeners_oneshot": false,
		"enabled": false,
	}
}


func _init(_event_name = "", _val = null, _proc_mode = 0, _listener_names = [], _listener_names_oneshot = []):
	resource_local_to_scene = true
	