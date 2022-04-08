tool
extends Resource
class_name SignalMeta

export(Dictionary) var item


func _init():
	item = {
		"obj_from": null,
		"connected": false,
		"signal": "",
		"obj_to": null,
		"method": "",
		"args": [],
		"flags": CONNECT_DEFERRED
	}
